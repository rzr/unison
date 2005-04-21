(* $I1: Unison file synchronizer: src/osx.ml $ *)
(* $I2: Last modified by bcpierce on Mon, 06 Sep 2004 14:48:05 -0400 $ *)
(* $I3: Copyright 1999-2004 (see COPYING for details) $ *)

external isMacOSXPred : unit -> bool = "isMacOSX"

let isMacOSX = isMacOSXPred ()

(* FIX: this should be somewhere else *)
(* Only used to check whether pty is supported *)
external isLinuxPred : unit -> bool = "isLinux"
let isLinux = isLinuxPred ()

(****)

let rsrcSync =
  Prefs.createString "rsrc" "default"
    "synchronize resource forks and HFS meta-data \
     (`true', `false', or `default')"
    "When set to {\\tt true}, this flag causes Unison to synchronize \
     resource forks and HFS meta-data.  On filesystems that do not \
     natively support resource forks, this data is stored in \
     Carbon-compatible .\\_ AppleDouble files.  When the flag is set \
     to {\\tt false}, Unison will not synchronize these data.  \
     Ordinarily, the flag is set to {\\tt default}, and these data are
     automatically synchronized if either host is running OSX.  In \
     rare circumstances it is useful to set the flag manually."

(* Defining this variable as a preference ensures that it will be propagated
   to the other host during initialization *)
let rsrc =
  Prefs.createBool "rsrc-aux" false
    "*synchronize resource forks and HFS meta-data" ""

let init b =
  Prefs.set rsrc
    (Prefs.read rsrcSync = "yes" ||
     Prefs.read rsrcSync = "true" ||
     (Prefs.read rsrcSync = "default" && b))

(****)

let appleDoubleFile fspath path =
  let f = Fspath.concatToString fspath path in
  let len = String.length f in
  try
    let i = 1 + String.rindex f '/' in
    let res = String.create (len + 2) in
    String.blit f 0 res 0 i;
    res.[i] <- '.';
    res.[i + 1] <- '_';
    String.blit f i res (i + 2) (len - i);
    res
  with Not_found ->
    assert false

let doubleMagic = "\000\005\022\007"
let doubleVersion = "\000\002\000\000"
let doubleFiller = String.make 16 '\000'
let finfoLength = Int64.of_int 32
let emptyFinderInfo = String.make 32 '\000'

let getInt2 buf ofs = (Char.code buf.[ofs]) * 256 + Char.code buf.[ofs + 1]

let getInt4 buf ofs =
  let get i = Int64.of_int (Char.code buf.[ofs + i]) in
  let combine x y = Int64.logor (Int64.shift_left x 8) y in
  combine (combine (combine (get 0) (get 1)) (get 2)) (get 3)

let getID buf ofs =
  let get i = Char.code buf.[ofs + i] in
  if get ofs <> 0 || get (ofs + 1) <> 0 || get (ofs + 2) <> 0 then
    `UNKNOWN
  else
    match get (ofs + 3) with
      2 -> `RSRC
    | 9 -> `FINFO
    | _ -> `UNKNOWN

let setInt4 v =
  let s = String.create 4 in
  let l255 = Int64.of_int 255 in
  let set i =
    s.[i] <-
      Char.chr (Int64.to_int (Int64.logand l255
                               (Int64.shift_right v (24 - 8 * i)))) in
  set 0; set 1; set 2; set 3;
  s

let fail path msg =
  raise (Util.Transient
           (Format.sprintf "Malformed AppleDouble file '%s' (%s)" path msg))

let readDouble path inch len =
  let buf = String.create len in
  begin try
    really_input inch buf 0 len
  with End_of_file ->
    fail path "truncated"
  end;
  buf

let readDoubleFromOffset path inch offset len =
  LargeFile.seek_in inch offset;
  readDouble path inch len

let writeDoubleFromOffset path outch offset str =
  LargeFile.seek_out outch offset;
  output_string outch str

let protect f g =
  try
    f ()
  with Sys_error _ | Unix.Unix_error _ | Util.Transient _ as e ->
    begin try g () with Sys_error _  | Unix.Unix_error _ -> () end;
    raise e

let openDouble fspath path =
  let path = appleDoubleFile fspath path in
  let inch = try open_in_bin path with Sys_error _ -> raise Not_found in
  protect (fun () ->
    Util.convertUnixErrorsToTransient "opening AppleDouble file" (fun () ->
      let header = readDouble path inch 26 in
      if String.sub header 0 4 <> doubleMagic then
        fail path "bad magic number";
      if String.sub header 4 4 <> doubleVersion then
        fail path "bad version";
      if String.sub header 8 16 <> doubleFiller then
        fail path "bad filler";
      let numEntries = getInt2 header 24 in
      let entries = ref [] in
      for i = 1 to numEntries do
        let entry = readDouble path inch 12 in
        let id = getID entry 0 in
        let ofs = getInt4 entry 4 in
        let len = getInt4 entry 8 in
        entries := (id, (ofs, len)) :: !entries
      done;
      (path, inch, !entries)))
    (fun () -> close_in inch)

(****)

type 'a ressInfo =
    NoRess
  | HfsRess of Uutil.Filesize.t
  | AppleDoubleRess of int * float * float * Uutil.Filesize.t * 'a

type ressStamp = unit ressInfo

let ressStampToString r =
  match r with
    NoRess         ->
      "NoRess"
  | HfsRess len ->
      Format.sprintf "Hfs(%s)" (Uutil.Filesize.toString len)
  | AppleDoubleRess (ino, mtime, ctime, len, _) ->
      Format.sprintf "Hfs(%d,%f,%f,%s)"
        ino mtime ctime (Uutil.Filesize.toString len)

type info =
  { ressInfo : (string * int64) ressInfo;
    typeCreator : string }

external getFileInfosInternal : string -> string * int64 = "getFileInfos"
external setFileInfosInternal : string -> string -> unit = "setFileInfos"

let defaultInfos = { ressInfo = NoRess; typeCreator = "" }

let noTypeCreator = String.make 8 '\000'
let normalizeTC tc = if tc = noTypeCreator then "" else tc

let getFileInfos fspath path typ =
  Util.convertUnixErrorsToTransient "getting file informations" (fun () ->
    if not (Prefs.read rsrc) || typ <> `FILE then defaultInfos else
    try
      let (typeCreator, rsrcLength) =
        getFileInfosInternal (Fspath.concatToString fspath path) in
      { ressInfo =
          if rsrcLength = Int64.zero then NoRess
          else HfsRess (Uutil.Filesize.ofInt64 rsrcLength);
        typeCreator = normalizeTC typeCreator }
    with Unix.Unix_error ((Unix.EOPNOTSUPP | Unix.ENOSYS), _, _) ->
      (* Not a HFS volume.  Look for an AppleDouble file *)
      try
        let (fspath, path) = Fspath.findWorkingDir fspath path in
        let (doublePath, inch, entries) = openDouble fspath path in
        let (rsrcOffset, rsrcLength) =
          try List.assoc `RSRC entries with Not_found ->
            (Int64.zero, Int64.zero)
        in
        let typeCreator =
          protect (fun () ->
            try
              let (ofs, len) = List.assoc `FINFO entries in
              if len <> finfoLength then fail doublePath "bad finder info";
              readDoubleFromOffset doublePath inch ofs 8
            with Not_found ->
              "")
            (fun () -> close_in inch)
        in
        close_in inch;
        let stats = Unix.LargeFile.stat doublePath in
        { ressInfo =
            if rsrcLength = Int64.zero then NoRess else
            AppleDoubleRess
              (begin match Util.osType with
                 `Win32 -> 0
               | `Unix  -> stats.Unix.LargeFile.st_ino
               end,
               stats.Unix.LargeFile.st_mtime,
               begin match Util.osType with
                 `Win32 -> stats.Unix.LargeFile.st_ctime
               | `Unix  -> 0.
               end,
               Uutil.Filesize.ofInt64 rsrcLength,
               (doublePath, rsrcOffset));
          typeCreator = normalizeTC typeCreator }
      with Not_found ->
        defaultInfos)

let setFileInfos fspath path tc =
  Util.convertUnixErrorsToTransient "setting file informations" (fun () ->
    let tc = if tc = "" then noTypeCreator else tc in
    try
      setFileInfosInternal (Fspath.concatToString fspath path) tc
    with Unix.Unix_error ((Unix.EOPNOTSUPP | Unix.ENOSYS), _, _) ->
      (* Not a HFS volume.  Look for an AppleDouble file *)
      let (fspath, path) = Fspath.findWorkingDir fspath path in
      begin try
        let (doublePath, inch, entries) = openDouble fspath path in
        close_in inch;
        begin try
          let (ofs, len) = List.assoc `FINFO entries in
          if len <> finfoLength then fail doublePath "bad finder info";
          let outch =
            open_out_gen [Open_wronly; Open_binary] 0o600 doublePath in
          protect (fun () -> writeDoubleFromOffset doublePath outch ofs tc)
            (fun () -> close_out outch);
          close_out outch
        with Not_found ->
          raise (Util.Transient
                   (Format.sprintf
                      "Unable to set the file type and creator: \n\
                       The AppleDouble file '%s' has no fileinfo entry."
                      doublePath))
        end
      with Not_found ->
        (* No AppleDouble file, create one if needed. *)
        if tc <> noTypeCreator then begin
          let path = appleDoubleFile fspath path in
          let outch =
            open_out_gen
              [Open_wronly; Open_creat; Open_excl; Open_binary] 0o600 path
          in
          protect (fun () ->
            output_string outch doubleMagic;
            output_string outch doubleVersion;
            output_string outch doubleFiller;
            output_string outch "\000\001"; (* One entry *)
            output_string outch "\000\000\000\009"; (* Finder info *)
            output_string outch "\000\000\000\038"; (* offset *)
            output_string outch "\000\000\000\032"; (* length *)
            output_string outch tc;
            output_string outch (String.sub emptyFinderInfo 8 24);
            close_out outch)
            (fun () -> close_out outch)
        end
      end)

let ressUnchanged info info' t0 dataUnchanged =
  match info, info' with
     NoRess, NoRess ->
       true
   | HfsRess len, HfsRess len' ->
       dataUnchanged && len = len'
   | AppleDoubleRess (ino, mt, ct, _, _),
     AppleDoubleRess (ino', mt', ct', _, _) ->
       ino = ino' && mt = mt' && ct = ct' &&
       if Some mt' <> t0 then
         true
       else begin
         begin try
           Unix.sleep 1
         with Unix.Unix_error _ -> () end;
         false
       end
   |  _ ->
       false

(****)

let name1 = Name.fromString "..namedfork"
let name2 = Name.fromString "rsrc"
let ressPath p = Path.child (Path.child p name1) name2

let stamp info =
  match info.ressInfo with
    NoRess ->
      NoRess
  | (HfsRess len) as s ->
      s
  | AppleDoubleRess (inode, mtime, ctime, len, _) ->
      AppleDoubleRess (inode, mtime, ctime, len, ())

let ressFingerprint fspath path info =
  match info.ressInfo with
    NoRess ->
      Fingerprint.dummy
  | HfsRess _ ->
      Fingerprint.file fspath (ressPath path)
  | AppleDoubleRess (_, _, _, len, (path, offset)) ->
      Fingerprint.subfile path offset len

let ressLength ress =
  match ress with
    NoRess                            -> Uutil.Filesize.zero
  | HfsRess len                       -> len
  | AppleDoubleRess (_, _, _, len, _) -> len

let ressDummy = NoRess

(****)

let openRessIn fspath path =
  Util.convertUnixErrorsToTransient "reading ressource fork" (fun () ->
    try
      Unix.openfile
        (Fspath.concatToString fspath (ressPath path))
        [Unix.O_RDONLY] 0o444
    with Unix.Unix_error (Unix.ENOTDIR, _, _) ->
      let (doublePath, inch, entries) = openDouble fspath path in
      let ch = Unix.descr_of_in_channel inch in
      try
        let (rsrcOffset, rsrcLength) = List.assoc `RSRC entries in
        protect (fun () ->
          ignore (Unix.LargeFile.lseek ch rsrcOffset Unix.SEEK_SET))
          (fun () -> close_in inch);
        ch
      with Not_found ->
        close_in inch;
        raise (Util.Transient "No ressource fork found"))

let openRessOut fspath path length =
  Util.convertUnixErrorsToTransient "writing ressource fork" (fun () ->
    try
      Unix.openfile
        (Fspath.concatToString fspath (ressPath path))
        [Unix.O_WRONLY;Unix.O_TRUNC] 0o600
    with Unix.Unix_error (Unix.ENOTDIR, _, _) ->
      let path = appleDoubleFile fspath path in
      let outch =
        open_out_gen
          [Open_wronly; Open_creat; Open_excl; Open_binary] 0o600 path
      in
      protect (fun () ->
        output_string outch doubleMagic;
        output_string outch doubleVersion;
        output_string outch doubleFiller;
        output_string outch "\000\002"; (* Two entries *)
        output_string outch "\000\000\000\009"; (* Finder info *)
        output_string outch "\000\000\000\050"; (* offset *)
        output_string outch "\000\000\000\032"; (* length *)
        output_string outch "\000\000\000\002"; (* Ressource fork *)
        output_string outch "\000\000\000\082"; (* offset *)
        output_string outch (setInt4 (Uutil.Filesize.toInt64 length));
                                                (* length *)
        output_string outch emptyFinderInfo;
        flush outch)
        (fun () -> close_out outch);
      Unix.descr_of_out_channel outch)
