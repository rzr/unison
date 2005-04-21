(* Dealing with HFS files (which have resource forks and other metadata) *)

(* During startup the client determines which roots are HFS file
   systems.  All hosts need to know whether all roots are HFS, and
   whether only some roots are HFS.  We ensure this by storing the
   information in a pref so that it is propagated to all the hosts
   with the rest of the prefs. *)
(* FIX: like case sensitivity this should really be a directory-specific
   property, because UFS and HFS volumes can be mounted on the same
   machine, and there can be soft links between them. *)
let hfsSome =
  Prefs.createBool "hfsSome" false
    "synchronizing with an HFS file system"
    ("When set to {\\tt true}, this flag causes Unison to synchronize "
     ^ "resource forks.  It is set automatically by Unison.")
let hfsAll =
  Prefs.createBool "hfsAll" false
    "synchronizing between two HFS file systems"
    ("When set to {\\tt true}, this flag causes Unison to synchronize "
     ^ "resource forks.  It is set automatically by Unison.")
let someHfs () = Prefs.read hfsSome
let allHfs () = Prefs.read hfsAll
let init someHostIsHfs allHostsAreHFS = begin
  Prefs.set hfsSome
    (someHostIsHfs || Prefs.read hfsSome);
  Prefs.set hfsAll
    (allHostsAreHFS || Prefs.read hfsAll)
end

let debug = Trace.debug "hfs"

(* Parsing and writing AppleDouble files *)
module AppleDouble = struct

  (**************************** Debugging ****************************)
  let entryId2string id =
    if id > Int64.of_int 15 then "UNKNOWN" else
    match Int64.to_int id with
      1 -> "Data fork"
    | 2 -> "Resource fork"
    | 3 -> "File's name as created on home file system"
    | 4 -> "Standard Macintosh comment"
    | 5 -> "Standard Macintosh black and white icon"
    | 6 -> "Macintosh colour icon"
    | 8 -> "File creation date, modification date, and so on"
    | 9 -> "Standard Macintosh Finder information"
    | 10 -> "Macintosh file information, attributes and so on"
    | 11 -> "ProDOS file information, attributes and so on"
    | 12 -> "MS-DOS file information, attributes and so on"
    | 13 -> "AFP short name"
    | 14 -> "AFP file, information, attributes and so on"
    | 15 -> "AFP directory ID"
    | _ -> "UNKNOWN"
  let printEntryDescriptor (id,ofs,len) =
    Util.msg "Entry at offset %Ld of length %Ld is %Ld (%s)\n" ofs len id
      (entryId2string id)

  (***************************** Parsing *****************************)
  let readEntryDescriptor inch =
    (* Each entry descriptor is three 32-bit numbers = 12 bytes *)
    let buf = String.create 12 in
    let len = input inch buf 0 12 in
    if len <> 12
    then raise(Failure "Malformed AppleDouble file (short entry descriptor)");
    (* return entry id, offset, length *)
    let getInt4 buf ofs =
      let get i = Int64.of_int (Char.code buf.[ofs + i]) in
      let combine x y = Int64.logor (Int64.shift_left x 8) y in
      combine (combine (combine (get 0) (get 1)) (get 2)) (get 3)
    in
    (getInt4 buf 0, getInt4 buf 4, getInt4 buf 8)

  (* Scan the head of an AppleDouble file, do some sanity checking, and
     return the offset and length of the resource fork within the file,
     if any *)
  let readHeader inch fLen =
    (* First part of header should be 26 bytes *)
    let buf = String.create 26 in
    let len = input inch buf 0 26 in
    if len <> 26
    then raise(Failure "Malformed AppleDouble file (too short)");
    (* The first four bytes of an AppleDouble file should be the magic
       number 0x00051607 stored in big endian (msb first) *)
    (* Note that '\022' is the hex character 0x16 *)
    if (buf.[0] <> '\000' or buf.[1] <> '\005'
          or buf.[2] <> '\022' or buf.[3] <> '\007')
    then raise(Failure "bad AppleDouble magic number");
    if (buf.[4] <> '\000' or buf.[5] <> '\002'
          or buf.[6] <> '\000' or buf.[7] <> '\000')
    then raise(Failure "bad AppleDouble file or unsupported AppleDouble file version");
    for i = 8 to 23 do
      if (buf.[i] <> '\000')
      then raise(Failure "bad filler in AppleDouble file header")
    done;
    let numEntries = (Char.code buf.[24]) * 256 + Char.code buf.[25] in
    let resourceForkInfo = ref None in
    let eds = ref [] in
    for i = 0 to (numEntries-1) do
      let entry = (readEntryDescriptor inch) in
      eds := entry::!eds;
      let (id,ofs,len) = entry in
      if id = Int64.of_int 2
      then resourceForkInfo := Some(ofs,len);
    done;
    eds := List.sort (fun (_,ofs,_) (_,ofs2,_) -> compare ofs ofs2) !eds;
    List.iter printEntryDescriptor !eds;
    begin (* Sanity check the entry descriptors *)
      (* Make sure the entries are contiguous, non-overlapping, fill up
         the file *)
      let z = ref !eds in
      let posn = ref (Int64.of_int (26 + numEntries * 12)) in
      (* offset for first entry *)
      while !z <> [] do
        let (_,ofs,len) = List.hd !z in
        if (ofs <> !posn)
        then
          raise(Failure "bad entry descriptor in AppleDouble file header");
        posn := Int64.add !posn len;
        z := List.tl !z;
      done;
      if !posn <> fLen
      then raise(Failure "bad AppleDouble file header (length mismatch)");
      (* FIX: perhaps should check that there are no duplicate entry ids *)
    end; (* sanity check *)
    !resourceForkInfo

  (************************ Digest calculation ************************)

  (* The digest of an AppleDouble file is simply the digest of the
     resource fork, if any.  Since an AppleDouble file need not have a
     resource fork, we return an option. *)
  let digest adFile =
    try
      let st = Unix.LargeFile.stat adFile in
                 (* will raise if file does not exist *)
      let adFileLen = st.Unix.LargeFile.st_size in
      let inch = open_in adFile in
      (try
        let resourceForkInfo = readHeader inch adFileLen in
        (match resourceForkInfo with
          None ->
            close_in inch;
            None
        | Some(ofs,len) ->
            LargeFile.seek_in inch ofs;
            (*FIX*)
            assert (Int64.shift_right_logical len 30 = Int64.zero);
            let fingerprint = Digest.channel inch (Int64.to_int len) in
            close_in inch;
            Some fingerprint)
      with exn -> close_in inch; raise exn)
    with Unix.Unix_error(_,"stat",_) -> None
    | exn -> raise exn


  (******************** Writing AppleDouble files ********************)

(*
  (* For a file with a resource fork, write the AppleDouble file
     containing just the resource fork *)
  let writeResourceFork rsrcFile outFd =
    let inFd = Unix.openfile rsrcFile [Unix.O_RDONLY] 0o444 in
    let len =
      let st = Unix.LargeFile.stat rsrcFile in
      st.Unix.LargeFile.st_size in
    try
      let header =
        ("\000\005\022\007"     (* magic number *)
        ^"\000\002\000\000"     (* version *)
        ^"\000\000\000\000"     (* 16 bytes of filler *)
        ^"\000\000\000\000"
        ^"\000\000\000\000"
        ^"\000\000\000\000"
        ^"\000\001"             (* number of entries = 1 *)  
        ^"\000\000\000\002"     (* entry id = resource fork *)
        ^"\000\000\000\038") in (* offset = 38 *)
      let headerLen = String.length header in
      if (headerLen <> Unix.write outFd header 0 headerLen)
      then raise(Failure "write failed in writeResourceFork");
      let (b0,b1,b2,b3) = (* length in big endian order (msb first) *)
        (len lsr 24,
         (len lsr 16) land 255,
         (len lsr 8) land 255,
         len land 255) in
      let buf = String.create 4 in
      buf.[0] <- Char.chr b0;
      buf.[1] <- Char.chr b1;
      buf.[2] <- Char.chr b2;
      buf.[3] <- Char.chr b3;
      if (4 <> Unix.write outFd buf 0 4)
      then raise(Failure "write failed in writeResourceFork");
      (* Copy the output *)
      (* FIX: This is inefficient *)
      let buf = String.create len in
      let charsRead = Unix.read inFd buf 0 len in
      if charsRead <> len then raise(Failure "error reading resource fork");
      if (len <> Unix.write outFd buf 0 len)
      then raise(Failure "write failed in writeResourceFork");
      Unix.close inFd
    with exn -> (Unix.close inFd; raise exn)
*)
end

(* If a file has a resource fork, return the name of the file which can
   access it.  This happens only on HFS file systems (OSX for now). *)
let resourceForkPath = Path.fromString "..namedfork/rsrc"
let hasResourceFork fspath =
  if not Util.isOSX then None else
  let resourceForkFspath = Fspath.concat fspath resourceForkPath in
  let rsrcFilename = Fspath.toString resourceForkFspath in
  try
    let rsrcLen =
      let st = Unix.LargeFile.stat rsrcFilename in
      st.Unix.LargeFile.st_size in
    if rsrcLen = Int64.zero then None  
    else Some resourceForkFspath
  with _ -> 
    (* handles the case where the call to Unix.LargeFile.stat fails.
       This can only happen if fspath refers to a non-existent or
       unreadable file. *)
    None

(* If a file has a corresponding AppleDouble file, return its name.
   This happens only on a non-HFS system syncing with an HFS system. *)
let hasAppleDouble fspath =
  if (someHfs() & not Util.isOSX) then
    let appleDoubleFspath = Fspath.appleDouble fspath in
    let f = Fspath.toString appleDoubleFspath in
    if (try ignore(Unix.LargeFile.stat f); true with _ -> false)
    then Some(appleDoubleFspath) else None
  else None

(* Calculate the digest (fingerprint) of a file, taking into account
   resource forks and AppleDouble files. *)
(* FIX: three digest calculations is expensive *)
let digest fspath =
  let f = Fspath.toString fspath in
  let d = Digest.file f in
  match hasResourceFork fspath with
    None -> 
      (match hasAppleDouble fspath with
        None -> d
      | Some r ->
          (match AppleDouble.digest (Fspath.toString r) with
            None -> d
          | Some x -> Digest.string(d ^ x)))
  | Some r ->
     debug (fun () -> Util.msg "Hfs.digest: %s with resource fork\n" f);
     Digest.string(d ^ Digest.file (Fspath.toString r))
    
