(* $I1: Unison file synchronizer: src/fileinfo.ml $ *)
(* $I2: Last modified by zheyang on Wed, 12 Dec 2001 02:26:21 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

let debug = Util.debug "fileinfo"

type typ = [ `ABSENT | `FILE | `DIRECTORY | `SYMLINK ]

let type2string = function
    `ABSENT -> "nonexistent"
  | `FILE -> "file"
  | `DIRECTORY -> "dir"
  | `SYMLINK -> "symlink"

type t = {typ:typ; inode:int; ctime:float; desc:Props.t}

(* Stat function that pays attention to pref for following links             *)
let statFn fromRoot fspath path =
  if fromRoot && Path.followLink path then
    Fspath.stat (Fspath.concat fspath path)
  else
    Fspath.lstat (Fspath.concat fspath path)

let get fromRoot fspath path =
  Util.convertUnixErrorsToTransient
  "querying file information"
    (fun () ->
       try
         let stats = statFn fromRoot fspath path in
         let typ =
           match stats.Unix.st_kind with
             Unix.S_REG -> `FILE
           | Unix.S_DIR -> `DIRECTORY
           | Unix.S_LNK -> `SYMLINK
           | _ ->
               raise (Util.Transient
                        ("path " ^
                         (Fspath.concatToString fspath path) ^
                         "has unknown file type"))
         in
         { typ = typ;
           inode    = stats.Unix.st_ino;
           ctime    = stats.Unix.st_ctime;
           desc     = Props.get stats }
       with
         Unix.Unix_error((Unix.ENOENT | Unix.ENOTDIR),_,_) ->
         {typ = `ABSENT;
          inode    = 0;
          ctime    = 0.0;
          desc     = Props.dummy})

let set fspath path action newDesc =
  let (kind, p) =
    match action with
      `Set defDesc ->
	(* Set the permissions and maybe the other properties                *)
        `Set, Props.override defDesc newDesc
    | `Copy oldPath ->
	(* Set the permissions (using the permissions of the file at         *)
	(* [oldPath] as a default) and maybe the other properties            *)
        `Set, Props.override (get false fspath oldPath).desc newDesc
    | `Update oldDesc ->
	(* Update the different properties (only if necessary)               *)
        `Update,
        Props.override
          (get false fspath path).desc (Props.diff oldDesc newDesc)
  in
  Props.set fspath path kind p

type stamp = 
    InodeStamp of int         (* inode number, for Unix systems *)
  | CtimeStamp of float       (* creation time, for windows systems *)

(* FIX: Nuke this when done testing *)
let pretendLocalOSIsWin32 =
  Prefs.createBool "pretendwin" false
    "*Pretend that we're running under win32 (for testing)"
    ""

let stamp info =
  (* FIX: Nuke this when done testing *)
  if Prefs.read pretendLocalOSIsWin32 then CtimeStamp info.ctime else
  match Util.osType with
    `Unix  -> InodeStamp info.inode
  | `Win32 -> CtimeStamp info.ctime
