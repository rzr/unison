(* $I1: Unison file synchronizer: src/update.ml $ *)
(* $I2: Last modified by bcpierce on Thu, 04 Apr 2002 18:13:56 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

open Common
let (>>=)  = Lwt.(>>=)

let debug = Trace.debug "update"

(*****************************************************************************)
(*                             ARCHIVE DATATYPE                              *)
(*****************************************************************************)

(* Remember to increment archiveFormat each time the representation of the
   archive changes: old archives will then automatically be discarded.  (We
   do not use the unison version number for this because usually the archive
   representation does not change between unison versions.) *)
let archiveFormat = 17

type archive =
    ArchiveDir of Props.t * (Name.t * archive) list
  | ArchiveFile of Props.t * Os.fingerprint * Fileinfo.stamp
  | ArchiveSymlink of string
  | NoArchive
(* For directories, only the permissions part of the file description (desc)
   is used for synchronization at the moment. *)

let archive2string = function
    ArchiveDir(_) -> "ArchiveDir"
  | ArchiveFile(_) -> "ArchiveFile"
  | ArchiveSymlink(_) -> "ArchiveSymlink"
  | NoArchive -> "NoArchive"

(*****************************************************************************)
(*                             ARCHIVE NAMING                                *)
(*****************************************************************************)

(* DETERMINING THE ARCHIVE NAME                                              *)

(* The canonical name of a root consists of its canonical host name and
   canonical fspath.

   The canonical name of a set of roots consists of the canonical names of
   the roots in sorted order.

   There is one archive for each root to be synchronized.  The canonical
   name of the archive is the canonical name of the root plus the canonical
   name of the set of all roots to be synchronized.  Because this is a long
   string we store the archive in a file whose name is the hash of the
   canonical archive name.

   For example, suppose we are synchronizing roots A and B, with canonical
   names A' and B', where A' < B'.  Then the canonical archive name for root
   A is A' + A' + B', and the canonical archive name for root B is B' + A' +
   B'.

   Currently, we determine A' + B' in during startup and store this in the
   ref cell rootsName, below.  This rootsName is passed as an argument to
   functions that need to determine a canonical archive name.  Note, since
   we have a client/server architecture, there are TWO rootsName ref cells
   (one in the client's address space, one in the server's).  It is vital
   therefore that the rootsName be determined on the client and passed to
   the server.  This is not good and we should get rid of the ref cell in
   the future; we have implemented it this way at first for historical
   reasons. *)


let rootsName : string Prefs.t =
  Prefs.createString "rootsName" "" "*Canonical root names" ""

let foundArchives = ref true

(*****************************************************************************)
(*                           COMMON DEFINITIONS                              *)
(*****************************************************************************)

(* BCPFIX: should be documented and available to user *)
let rootAliases : string list Prefs.t =
  Prefs.createStringList "rootalias"
   "Register alias for canonical root names"
   ("When calculating the name of the archive files for a given pair of roots,"
   ^ " Unison replaces any roots matching the left-hand side of any rootalias"
   ^ " rule by the corresponding right-hand side.")

(* [root2stringOrAlias root] returns the string form of [root], taking into
   account the preference [rootAliases], whose items are of the form `<a> ->
   <b>' *)
let root2stringOrAlias (root: Common.root): string =
  let r = Common.root2string root in
  let aliases : (string * string) list =
    Safelist.map
      (fun s -> match Util.splitIntoWordsByString s " -> " with
        [n;n'] -> (Util.trimWhitespace n, Util.trimWhitespace n')
      | _ -> raise (Util.Fatal (Printf.sprintf
                                  "rootalias %s should be two strings separated by ' -> '" s)))
      (Prefs.read rootAliases) in
  let r' = try Safelist.assoc r aliases with Not_found -> r in
  debug (fun()->
    Util.msg "Canonical root name %s\n  " r;
    if r=r' then Util.msg "is not aliased\n"
    else Util.msg "is aliased to %s\n" r');
  r'

(* <PUBLIC> (Called from the UI startup sequence...) `normalize' root names,
   sort them, get their string form, and put into the preference [rootsname]
   as a comma-separated string *)
let storeRootsName () =
  let n =
    String.concat ", "
      (Safelist.map root2stringOrAlias
         (Common.sortRoots
            (Safelist.map
               (function
                   (Common.Local,f) ->
                     (Common.Remote Os.myCanonicalHostName,f)
                | r ->
                   r)
               (Globals.rootsInCanonicalOrder())))) in
  Prefs.set rootsName n

(* How many characters of the filename should be used for the unique id of
   the archive?  On Unix systems, we use the full fingerprint (32 bytes).
   On windows systems, filenames longer than 8 bytes can cause problems, so
   we chop off all but the first 6 from the fingerprint. *)
let significantDigits =
  match Util.osType with
    `Win32 -> 6
  | `Unix -> 32

let thisRootsGlobalName (fspath: Fspath.t): string =
  root2stringOrAlias (Common.Remote Os.myCanonicalHostName, fspath)

(* ----- *)

(* The status of an archive *)
type archiveVersion = MainArch | NewArch | ScratchArch | Lock

(* [archiveName fspath] returns a pair (arcName, thisRootsGlobalName) *)
let archiveName fspath (v: archiveVersion): string * string =
  (* Conjoin the canonical name of the current host and the canonical
     presentation of the current fspath with the list of names/fspaths of
     all the roots and the current archive format *)
  let thisRoot = thisRootsGlobalName fspath in
  let r = Prefs.read rootsName in
  let n = Printf.sprintf "%s;%s;%d" thisRoot r archiveFormat in
  let d = Os.fingerprint2string (Os.fingerprintString n) in
  debug (fun()-> Util.msg "Archive name is %s  i.e. %s\n" n d);
  let temp = match v with
    MainArch -> "ar" | NewArch -> "tm" | ScratchArch -> "sc" | Lock -> "lk"
  in
  (Printf.sprintf "%s%s" temp (String.sub d 0 significantDigits),
   thisRoot)



(*****************************************************************************)
(*                             SANITY CHECKS                                 *)
(*****************************************************************************)

(* Make sure that no two `children' (elements of [ch]) have the same name
-
   Precondition: [ch] is a sorted list
   Do nothing if okay, raise exception otherwise.
-*)
let rec checkDisjointChildren (path: Path.t) (ch: (Name.t * archive) list)
   : unit =
  match ch with
    [] | [_] -> ()
  | (n1, _)::(((n2, _)::_) as r) ->
      if Name.eq n1 n2 then
        raise
          (Util.Fatal (Printf.sprintf
            "Corrupted archive: the file %s occurs twice in path %s"
            (Name.toString n1) (Path.toString path)));
      checkDisjointChildren path r

(* [checkArchive] checks the sanity of an archive, and returns its
   hash-value. 'Sanity' means (1) no repeated name under any path, and (2)
   NoArchive appears only at root-level (indicated by [top]).  Property: Two
   archives of the same labeled-tree structure have the same hash-value.
   NB: [h] is the hash accumulator *)
let rec checkArchive (top: bool) (path: Path.t) (arch: archive) (h: int): int =
  match arch with
    ArchiveDir (desc, children) ->
      let children =
        Sort.list (fun (n, _) (n', _) -> Name.compare n n' <= 0) children in
      checkDisjointChildren path children;
      Safelist.fold_right
        (fun (n, a) h ->
           Uutil.hash2 (Name.hash n)
                      (checkArchive false (Path.child path n) a h))
        children (Props.hash desc h)
  | ArchiveFile (desc, dig, _) ->
      Uutil.hash2 (Hashtbl.hash dig) (Props.hash desc h)
  | ArchiveSymlink content ->
      Uutil.hash2 (Hashtbl.hash content) h
  | NoArchive ->
      if top then 135 else
      raise (Util.Fatal (Printf.sprintf
         "Corrupted archive: empty archive in path %s" (Path.toString path)))

(* [archivesIdentical l] returns true if all elements in [l] are the same *)
let archivesIdentical l =
  match l with
    h::r -> Safelist.for_all (fun h' -> h = h') r
  | _    -> true

(*****************************************************************************)
(*                      LOADING AND SAVING ARCHIVES                          *)
(*****************************************************************************)

(* [formatString] and [verboseArchiveName thisRoot] are the verbose forms of
   archiveFormat and root names.  They appear in the header of the archive
   files *)
let formatString = Printf.sprintf "Unison archive format %d" archiveFormat

let verboseArchiveName thisRoot =
  Printf.sprintf "Archive for root %s synchronizing roots %s"
    thisRoot (Prefs.read rootsName)

(* Load in the archive in [fspath]; check that archiveFormat (first line)
   and roots (second line) match skip the third line (time stamp), and read
   in the archive *)
let loadArchiveLocal (fspath: Fspath.t) (thisRoot: string): archive =
  let f = Fspath.toString fspath in
  debug (fun() -> Util.msg "Loading archive from %s\n" f);
  Util.convertUnixErrorsToFatal "loading archive" (fun () ->
    if Sys.file_exists f then
      let c = open_in_bin f in
      let header = input_line c in
      (* Sanity check on archive format *)
      if header<>formatString then begin
        Util.warn
          (Printf.sprintf
             "Archive format mismatch: found\n '%s'\n\
              but expected\n '%s'.\n\
              I will delete the old archive and start from scratch.\n"
             header formatString);
        NoArchive
      end else
      let roots = input_line c in
      (* Sanity check on roots. *)
      if roots <> verboseArchiveName thisRoot then begin
        Util.warn
          (Printf.sprintf
             "Archive mismatch: found\n '%s'\n\
              but expected\n '%s'.\n\
              I will delete the old archive and start from scratch.\n"
             roots (verboseArchiveName thisRoot));
        NoArchive
      end else
        (* Throw away the timestamp line *)
        let _ = input_line c in
        (* Load the datastructure *)
        try
          let ((archive, hash) : archive * int) = Marshal.from_channel c in
          close_in c;
          archive
        with Failure s -> raise (Util.Fatal (Printf.sprintf
           "Archive file seems damaged (%s): throw away archives on both machines and try again" s))
    else
      (debug (fun() -> Util.msg "Archive %s not found\n" f);
      NoArchive))

(* Inverse to loadArchiveLocal *)
let storeArchiveLocal fspath thisRoot archive hash =
 let f = Fspath.toString fspath in
 debug (fun() -> Util.msg "Saving archive in %s\n" f);
 Util.convertUnixErrorsToFatal "saving archive" (fun () ->
   let c =
     open_out_gen [Open_wronly; Open_creat; Open_trunc; Open_binary] 0o600 f
   in
   output_string c formatString;
   output_string c "\n";
   output_string c (verboseArchiveName thisRoot);
   output_string c "\n";
   output_string c (Printf.sprintf "Written at %s\n"
                      (Util.time2string (Unix.time())));
   Marshal.to_channel c (archive, hash) [Marshal.No_sharing];
   close_out c)

(* Remove the archieve under the root path [fspath] with archiveVersion [v] *)
let removeArchiveLocal ((fspath: Fspath.t), (v: archiveVersion)): unit Lwt.t =
  Lwt.return
    (let (name,_) = archiveName fspath v in
     let f = Fspath.toString (Os.fileInUnisonDir name) in
     debug (fun() -> Util.msg "Removing archive %s\n" f);
     Util.convertUnixErrorsToFatal "removing archive" (fun () ->
       if Sys.file_exists f then Sys.remove f))

(* [removeArchiveOnRoot root v] invokes [removeArchive fspath v] on the
   server, where [fspath] is the path to root on the server *)
let removeArchiveOnRoot: Common.root -> archiveVersion -> unit Lwt.t =
  Remote.registerRootCmd "removeArchive" removeArchiveLocal

(* [commitArchive (fspath, ())] commits the archive for [fspath] by changing
   the filenames from ScartchArch-ones to a NewArch-ones *)
let commitArchiveLocal ((fspath: Fspath.t), ())
    : unit Lwt.t =
  Lwt.return
    (let (fromname,_) = archiveName fspath ScratchArch in
     let (toname,_) = archiveName fspath NewArch in
     let ffrom = Fspath.toString (Os.fileInUnisonDir fromname) in
     let fto = Fspath.toString (Os.fileInUnisonDir toname) in
     Util.convertUnixErrorsToFatal
       "committing"
         (fun () -> Unix.rename ffrom fto))

(* [commitArchiveOnRoot root v] invokes [commitArchive fspath v] on the
   server, where [fspath] is the path to root on the server *)
let commitArchiveOnRoot: Common.root -> unit -> unit Lwt.t =
  Remote.registerRootCmd "commitArchive" commitArchiveLocal

(* [postCommitArchive (fspath, v)] finishes the committing protocol by
   copying files from NewArch-files to MainArch-files *)
let postCommitArchiveLocal (fspath,())
    : unit Lwt.t =
  Lwt.return
    (let (fromname,_) = archiveName fspath NewArch in
     let (toname,_) = archiveName fspath MainArch in
     let ffrom = Fspath.toString (Os.fileInUnisonDir fromname) in
     let fto = Fspath.toString (Os.fileInUnisonDir toname) in
     debug (fun() -> Util.msg "Copying archive %s to %s\n" ffrom fto);
     Util.convertUnixErrorsToFatal "copying archive" (fun () ->
       let outFd = Unix.openfile fto
         [Unix.O_RDWR;Unix.O_CREAT;Unix.O_TRUNC] 0o600 in
       Unix.chmod fto 0o600; (* In case the file already existed *)
       let inFd = Unix.openfile ffrom [Unix.O_RDONLY] 0o444 in
       Uutil.readWrite inFd outFd (fun _ -> ());
       Unix.close inFd;
       Unix.close outFd))

(* [postCommitArchiveOnRoot root v] invokes [postCommitArchive fspath v] on
   the server, where [fspath] is the path to root on the server *)
let postCommitArchiveOnRoot: Common.root -> unit -> unit Lwt.t =
  Remote.registerRootCmd "postCommitArchive" postCommitArchiveLocal


(*************************************************************************)
(*                           Archive cache                               *)
(*************************************************************************)

(* archiveCache: map(rootGlobalName, archive) *)
let archiveCache = Hashtbl.create 7
(*  commitAction: map(rootGlobalName * transactionId, action: unit -> unit) *)
let commitActions = Hashtbl.create 7

(* Retrieve an archive from the cache *)
let findArchive (thisRoot: string): archive =
  Hashtbl.find archiveCache thisRoot

(* FIX: This is just for testing -- can be deleted later: *)
let tbl = Weak.create 10
let s = ref (-1)
let insert a =
  (*
  Gc.full_major ();
  Gc.full_major ();
  Gc.full_major ();
  *)
  Format.eprintf "GC: %d " (Gc.stat ()).Gc.live_words;
  for i = 0 to !s do
    Format.eprintf "%b " (Weak.check tbl i)
  done;
  Format.eprintf "@.";
  if !s < 9 then begin
    incr s;
    Weak.set tbl !s (Some a)
  end

(* Update the cache. *)
let setArchiveLocal (thisRoot: string) (archive: archive) =
  (* Also this: *)
  debug (fun () -> Printf.eprintf "Setting archive for %s\n" thisRoot);
  if Trace.enabled "gc" then insert archive;
  Hashtbl.remove archiveCache thisRoot;
  Hashtbl.add archiveCache thisRoot archive

(* Load (main) root archive and cache it on the given server *)
let loadArchiveOnRoot: Common.root -> unit -> unit Lwt.t =
  Remote.registerRootCmd
    "loadArchive"
    (fun (fspath, ()) ->
       let (arcName,thisRoot) = archiveName fspath MainArch in
       let arcFspath = Os.fileInUnisonDir arcName in
       let arch = loadArchiveLocal arcFspath thisRoot in
       Lwt.return (setArchiveLocal thisRoot arch))

(* For all roots (local or remote), load the archive and cache *)
let loadArchives (): unit Lwt.t =
  Globals.allRootsIter (fun r -> loadArchiveOnRoot r ())

(* commitActions(thisRoot, id) <- action *)
let setCommitAction (thisRoot: string) (id: int) (action: unit -> unit): unit =
  let key = (thisRoot, id) in
  Hashtbl.add commitActions key action

(* perform and remove the action associated with (thisRoot, id) *)
let softCommitLocal (thisRoot: string) (id: int) =
  debug (fun () ->
    Util.msg "Committing %d\n" id);
  let key = (thisRoot, id) in
  Hashtbl.find commitActions key ();
  Hashtbl.remove commitActions key

(* invoke softCommitLocal on a given root (which is possibly remote) *)
let softCommitOnRoot: Common.root -> int -> unit Lwt.t =
  Remote.registerRootCmd
    "softCommit"
    (fun (fspath, id) ->
       Lwt.return (softCommitLocal (thisRootsGlobalName fspath) id))

(* Commit the archive on all roots. The archive must have been updated on
   all roots before that.  I.e., carry out the action corresponding to [id]
   on all the roots *)
let softCommit (id: int): unit Lwt.t =
  Util.convertUnixErrorsToFatal "softCommit" (*XXX*)
    (fun () ->
       Globals.allRootsIter
         (fun r -> softCommitOnRoot r id))

(* [rollBackLocal thisRoot id] removes the action associated with (thisRoot,
   id) *)
let rollBackLocal thisRoot id =
  let key = (thisRoot, id) in
  try Hashtbl.remove commitActions key with Not_found -> ()

let rollBackOnRoot: Common.root -> int -> unit Lwt.t =
  Remote.registerRootCmd
    "rollBack"
    (fun (fspath, id) ->
       Lwt.return (rollBackLocal (thisRootsGlobalName fspath) id))

(* Rollback the archive on all roots. *)
(* I.e., remove the action associated with [id] on all roots *)
let rollBack id =
  Util.convertUnixErrorsToFatal "rollBack" (*XXX*)
    (fun () ->
       Globals.allRootsIter
         (fun r -> rollBackOnRoot r id))

let ids = ref 0
let new_id () = incr ids; !ids

type transaction = int

(* [transaction f]: transactional execution
 * [f] should take in a unique id, which it can use to `setCommitAction',
 * and returns a thread.
 * When the thread finishes execution, the committing action associated with
 * [id] is invoked.
 *)
let transaction (f: int -> unit Lwt.t): unit Lwt.t =
  let id = new_id () in
  Lwt.catch
    (fun () ->
       f id >>= (fun () ->
       softCommit id))
    (fun exn ->
       match exn with
         Util.Transient _ ->
           rollBack id >>= (fun () ->
           Lwt.fail exn)
       | _ ->
           Lwt.fail exn)

(*************************************************************************
                           DUMPING ARCHIVES
 *************************************************************************)

let rec showArchive = function
    ArchiveDir (props, children) ->
      Format.printf "Directory, %s@\n @[" (Props.syncedPartsToString props);
      let children =
        Sort.list (fun (n, _) (n', _) -> Name.compare n n' <= 0) children in
      Safelist.iter (fun (n,c) ->
        Format.printf "%s -> @\n " (Name.toString n);
        showArchive c)
        children;
      Format.printf "@]@\n"
  | ArchiveFile (props, fingerprint, stamp) ->
      Format.printf "File, %s   %s@\n"
        (Props.syncedPartsToString props)
        (Os.fingerprint2string fingerprint)
  | ArchiveSymlink(s) ->
      Format.printf "Symbolic link: %s@\n" s
  | NoArchive ->
      Format.printf "No archive@\n"

let dumpArchiveLocal (fspath,()) =
  Lwt.return
    (let (name, root) = archiveName fspath MainArch in
    let archive = findArchive root in
    let f = Util.fileInHomeDir "unison.dump" in
    debug (fun () -> Printf.eprintf "Dumping archive into `%s'\n" f);
    let ch = open_out_gen [Open_wronly; Open_trunc; Open_creat] 0o600 f in
    let (outfn,flushfn) = Format.get_formatter_output_functions () in
    Format.set_formatter_out_channel ch;
    Format.printf "Contents of archive for %s\n" root;
    Format.printf "Written at %s\n\n" (Util.time2string (Unix.time()));
    showArchive archive;
    Format.print_flush();
    Format.set_formatter_output_functions outfn flushfn;
    flush ch;
    close_out ch)

let dumpArchiveOnRoot : Common.root -> unit -> unit Lwt.t =
  Remote.registerRootCmd "dumpArchive" dumpArchiveLocal

(*****************************************************************************)
(*                               Archive locking                             *)
(*****************************************************************************)

let lockArchiveLocal fspath =
  let (lockFilename, _) = archiveName fspath Lock in
  let lockFile = Fspath.toString (Os.fileInUnisonDir lockFilename) in
  if Lock.acquire lockFile then
    None
  else
    Some (Printf.sprintf "The file %s on host %s should be deleted"
            lockFile Os.myCanonicalHostName)

let lockArchiveOnRoot: Common.root -> unit -> string option Lwt.t =
  Remote.registerRootCmd
    "lockArchive" (fun (fspath, ()) -> Lwt.return (lockArchiveLocal fspath))

let unlockArchiveLocal fspath =
  Lock.release
    (Fspath.toString (Os.fileInUnisonDir (fst (archiveName fspath Lock))))

let unlockArchiveOnRoot: Common.root -> unit -> unit Lwt.t =
  Remote.registerRootCmd
    "unlockArchive" (fun (fspath, ()) -> Lwt.return (unlockArchiveLocal fspath))

let locked = ref false

let lockArchives () =
  assert (!locked = false);
  Globals.allRootsMap
    (fun r -> lockArchiveOnRoot r ()) >>= (fun result ->
  if List.exists (fun x -> x <> None) result then begin
    Globals.allRootsIter2
      (fun r st ->
         match st with
           None   -> unlockArchiveOnRoot r ()
         | Some _ -> Lwt.return ())
      result >>= (fun () ->
    let whatToDo = Safelist.filterMap (fun st -> st) result in
    raise
      (Util.Fatal
         (String.concat "\n"
            (["Warning: the archives are locked.  ";
              "If no other instance of " ^ Uutil.myName ^ " is running, \
               the locks should be removed."]
             @ whatToDo @
             ["Please delete lock files as appropriate and try again."]))))
  end else begin
    locked := true;
    Lwt.return ()
  end)

let unlockArchives () =
  if !locked then begin
    Lwt_unix.run (Globals.allRootsIter (fun r -> unlockArchiveOnRoot r ()));
    locked := false
  end

(*************************************************************************)
(*                          CRASH RECOVERY                               *)
(*************************************************************************)

(* We avoid getting into an unsafe situation if the synchronizer is
   interrupted during the writing of the archive files by adopting a
   simple joint commit protocol.

   The invariant that we maintain at all times is:
      if all hosts have a temp archive,
        then these temp archives contain coherent information
      if NOT all hosts have a temp archive,
        then the regular archives contain coherent information

   When we WRITE archives (markUpdated), we maintain this invariant
   as follows:
     - first, write all archives to a temporary filename
     - then copy all the temp files to the corresponding regular archive
       files
     - finally, delete all the temp files

   Before we LOAD archives (findUpdates), we perform a crash recovery
   procedure, in case there was a crash during any of the above operations.
     - if all hosts have a temporary archive, we copy these to the
       regular archive names
     - otherwise, if some hosts have temporary archives, we delete them
*)

let archivesExistOnRoot: Common.root -> unit -> (bool * bool) Lwt.t =
  Remote.registerRootCmd
    "archivesExist"
    (fun (fspath,rootsName) ->
       let (oldname,_) = archiveName fspath MainArch in
       let oldexists =
         Sys.file_exists (Fspath.toString (Os.fileInUnisonDir oldname)) in
       let (newname,_) = archiveName fspath NewArch in
       let newexists =
         Sys.file_exists (Fspath.toString (Os.fileInUnisonDir newname)) in
       Lwt.return (oldexists, newexists))

let (archiveNameOnRoot
       : Common.root ->  archiveVersion -> (string * string * bool) Lwt.t)
    =
  Remote.registerRootCmd
    "archiveName"
      (fun (fspath, v) ->
       let (name,_) = archiveName fspath v in
       Lwt.return
         (name,
          Os.myCanonicalHostName,
          Sys.file_exists (Fspath.toString (Os.fileInUnisonDir name))))

let forall = Safelist.for_all (fun x -> x)
let exists = Safelist.exists (fun x -> x)

let doArchiveCrashRecovery () =
  (* Check which hosts have copies of the old/new archive *)
  Globals.allRootsMap (fun r -> archivesExistOnRoot r ()) >>= (fun exl ->
  let oldnamesExist,newnamesExist =
    Safelist.split exl
  in

  (* Do something with the new archives, if there are any *)
  begin if forall newnamesExist then begin
    (* All new versions were written: use them *)
    Util.warn
      (Printf.sprintf
         "Warning: %s may have terminated abnormally last time.\n\
          A new archive exists on all hosts: I'll use them.\n"
         Uutil.myName);
    Globals.allRootsIter (fun r -> postCommitArchiveOnRoot r ()) >>= (fun () ->
    Globals.allRootsIter (fun r -> removeArchiveOnRoot r NewArch))
  end else if exists newnamesExist then begin
    Util.warn
      (Printf.sprintf
         "Warning: %s may have terminated abnormally last time.\n\
          A new archive exists on some hosts only; it will be ignored.\n"
         Uutil.myName);
    Globals.allRootsIter (fun r -> removeArchiveOnRoot r NewArch)
  end else
    Lwt.return ()
  end >>= (fun () ->

  (* Now verify that there are old archives on all hosts *)
  if forall oldnamesExist then begin
    (* We're happy *)
    foundArchives := true;
    Lwt.return ()
  end else if exists oldnamesExist then
    Globals.allRootsMap
      (fun r -> archiveNameOnRoot r MainArch) >>= (fun names ->
    let whatToDo =
      Safelist.map
        (fun (name,host,exists) ->
          Printf.sprintf "  Archive %s on host %s %s"
            name
            host
            (if exists then "should be DELETED" else "is MISSING"))
        names in
    raise
      (Util.Fatal
         (String.concat "\n"
            (["Warning: inconsistent state.  ";
              "The archive file is missing on some hosts.";
              "For safety, the remaining copies should be deleted."]
             @ whatToDo @
             ["Please delete archive files as appropriate and try again."]))))
  else begin
    foundArchives := false;
    (* This can be nuked if we don't end up needing it pretty soon:
    let expectedNames =
      String.concat ""
        (Safelist.map
           (fun (name,host,_) ->
              Printf.sprintf "    %s    on host %s\n" name host)
           (Globals.allRootsMap (fun r -> archiveNameOnRoot r MainArch))) in *)
    Util.warn
    ("No archive files were found for these roots.  This can happen either\n"
   ^ "because this is the first time you have synchronized these roots, \n"
   ^ "or because you have upgraded Unison to a new version with a different\n"
   ^ "archive format.  \n\n"
   ^ "Update detection may take a while on this run if the replicas are \n"
   ^ "large.\n\n"
   ^ "Unison will assume that the 'last synchronized state' of both replicas\n"
   ^ "was completely empty.  This means that any files that are different\n"
   ^ "will be reported as conflicts, and any files that exist only on one\n"
   ^ "replica will be judged as new and propagated to the other replica.\n"
   ^ "If the two replicas are identical, then no changes will be reported.\n"
     (* ^ "\nThe expected archive names were:\n" ^ expectedNames *) );
    Lwt.return ()
  end))

(*************************************************************************
                       Update a part of an archive
 *************************************************************************)

let lookup n ac =
  (* Careful: don't use Safelist.assoc, we may need a case insensitive
     compare, and eqName takes care of this. *)
  snd(Safelist.find (fun (n',a) -> Name.eq n n') ac)

let remove n ac =
  (* Careful: don't use Safelist.remove_assoc, we may need a case
     insensitive compare, and eqName takes care of this. *)
  Safelist.filter (fun (n',a) -> not(Name.eq n n')) ac

(* perform [action] on the relative path [rest] in the archive.  If it
   returns [(ar, result)], then update archive with [ar] at [rest] and
   return [result].  The argument [here] (the accumulator) and [fspath] is
   only for debugging purpose *)
let rec updatePathInArchive archive fspath
    (here: Path.t) (rest: Path.t)
    (action: archive -> Fspath.t -> Path.t -> archive * 'a):
    archive * 'a
    =
  debug
    (fun() ->
      Printf.eprintf "updatePathInArchive %s %s [%s] [%s]\n"
        (archive2string archive) (Fspath.toString fspath)
        (Path.toString here) (Path.toString rest));
  match Path.deconstruct rest with
    None ->
      action archive fspath here
  | Some(name,rest') ->
      let (desc, child, otherChildren) =
        match archive with
          ArchiveDir (desc, children) ->
            desc,
            (try lookup name children with Not_found -> NoArchive),
            remove name children
        | _ ->
            (Props.dummy, NoArchive, [])
      in
      match
        updatePathInArchive child fspath (Path.child here name) rest' action
      with
        NoArchive, res ->
          if otherChildren = [] && desc == Props.dummy then
            NoArchive, res
          else
            ArchiveDir (desc, otherChildren), res
      | child, res ->
          ArchiveDir (desc, (name, child) :: otherChildren), res

(*************************************************************************)
(*                  Extract of a part of a archive                       *)
(*************************************************************************)

(* Get the archive found at [rest] of [archive] *)
let rec getPathInArchive archive fspath here rest =
  debug
    (fun() ->
      Printf.eprintf "getPathInArchive %s %s [%s] [%s]\n"
        (archive2string archive) (Fspath.toString fspath)
        (Path.toString here) (Path.toString rest));
  match Path.deconstruct rest with
    None ->
      archive
  | Some (name, rest') ->
      match archive with
        ArchiveDir (desc, children) ->
          begin try
            getPathInArchive
              (lookup name children) fspath (Path.child here name) rest'
          with Not_found ->
            NoArchive
          end
      | _ ->
          NoArchive

(* The problem seems to be linked to some dotfile directories I have linked
   to from a "shared" directory that contains symbolic links to all the
   directories I want to synchronize. *)


(***********************************************************************
                 MIRRORING OF PREVIOUS FILE CONTENTS
************************************************************************)

let debugmirrors = Trace.debug "mirror"

(*** Low-level functions ***)

(* All the directory items under [fspath]/[path] *)
let childrenOf fspath path
   : string list
   =
  let rec loop children directory =
    try
      let newFile = Unix.readdir directory in
      let newChildren =
        if newFile = "." || newFile = ".." then
          children
        else
          newFile :: children in
      loop newChildren directory
    with End_of_file -> children
  in
  let absolutePath = Fspath.concat fspath path in
  try
    let directory = Fspath.opendir absolutePath in
    let result =
      Util.convertUnixErrorsToTransient
        "scanning directory"
        (fun () -> loop [] directory) in
    Unix.closedir directory;
    result
  with Unix.Unix_error _ -> []

let isDir fspath =
  try
    (Fspath.stat fspath).Unix.st_kind = Unix.S_DIR
  with Unix.Unix_error _ -> false

let isFile fullFspath =
  try
    (Fspath.lstat (fullFspath)).Unix.st_kind = Unix.S_REG
  with Unix.Unix_error _ -> false

(* Open a file and run a piece of code that uses it, making sure to close
   the file if the code aborts.  If the code does *not* abort, it is
   expected to close the file itself. (Perhaps this belongs in a
   utility module someplace, rather than here.) *)
let withOpenFile fspath path kind body =
  Util.convertUnixErrorsToTransient
    "preprocess"
    (fun () ->
       let name = Fspath.concatToString fspath path in
       let fd =
         match kind with
           `Read ->
             Unix.openfile name [Unix.O_RDONLY] 0o600
         | `Write ->
             Unix.openfile
               name [Unix.O_RDWR;Unix.O_CREAT;Unix.O_EXCL]  0o600
       in
       Util.unwindProtect
         (fun() -> body fd)
         (fun _ -> Unix.close fd))

(*** Preferences for mirrors ***)

(* FIX: Check the comments *)
(* BCPFIX: The variable (and all related functions, etc.) should be
   renamed 'backup' *)
let mirror =
   Pred.create "backup"
   ("Including the preference \\texttt{-backup \\ARG{pathspec}} "
   ^ "causes Unison to make back up for each path that matches "
   ^ "\\ARG{pathspec}.  More precisely, for each path that "
   ^ "matches this \\ARG{pathspec}, "
   ^ "Unison will keep several old versions of a file as a backup whenever "
   ^ "a change is propagated.  These backup files are left in the "
   ^ "directory specified by the environment variable {\\tt UNISONBACKUPDIR}"
   ^ " (\\verb|.unison/backup/| by default).  The newest backed up copy will"
   ^ "have the same name as the original; older versions will be named "
   ^ "with extensions \\verb|.n.unibck|."
   ^ " The number of versions that are kept is determined by the "
   ^ "\\verb|maxbackups| preference."
   ^ "\n\n The syntax of \\ARG{pathspec} is described in \sectionref{pathspec}{Path Specification}.")

let _ = Prefs.alias "backup" "mirror"

(* BCPFIX: Change name to maxbackups *)
let mirrorversions =
  Prefs.createInt "maxbackups" 2
    "number of backed up versions of a file"
    ("This preference specifies the number of backup versions that will "
     ^ "be kept by unison, for each path that matches the predicate "
     ^ "\\verb|backup|.  The default is 2.")

let _ = Prefs.alias "maxbackups" "mirrorversions"

let mirrorDirectory =
  try Fspath.canonize (Some (Unix.getenv "UNISONBACKUPDIR"))
  with Not_found ->
  try Fspath.canonize (Some (Unix.getenv "UNISONMIRRORDIR"))
  with Not_found ->
  Os.fileInUnisonDir "backup"

(*** Functions for manipulating names of mirror files ***)

let mirrorRe = Str.regexp "\(.*\)\.\([0-9]+\)\.unibck$"
let suffixRe = Str.regexp "\.[0-9]+\.unibck$"

let chopSuffix name =
  String.sub name 0 (Str.search_forward suffixRe name 0)

let fileNameOfMirror name =
  if Str.string_match mirrorRe name 0 then
    chopSuffix name
  else
    name

(* incrNameOfMirror("<name>.<i>.unibck") = "<name>.<i+1>.unibck" *)
let incrNameOfMirror name =
  if Str.string_match mirrorRe name 0 then
    let version = int_of_string (Str.matched_group 2 name) in
    let newVersion = string_of_int (1 + version) in
    let newName = chopSuffix name in
    version, newName ^ "." ^ newVersion ^ ".unibck"
  else
    0, (name ^ ".1.unibck")  (*version number, new_name*)

(* Return a sorted list of (version, current name, new name) for the file
   [filePath] *)
let findAllMirrors filePath =
  (* Is there a way to avoid all these uses of Path.toString? *)
  let parentPath = Path.parent filePath in
  let path = Path.toString filePath in
  let files =
    List.map
      (fun a -> Path.toString (Path.child parentPath (Name.fromString a)))
      (childrenOf mirrorDirectory parentPath)
  in
  let mirrors = List.filter (fun p -> fileNameOfMirror p = path) files in
  let newL =
    List.map
      (fun a -> let (x,y) = incrNameOfMirror a in (x, a, y))
      mirrors
  in
  List.sort (fun (a, _, _) (b, _, _) -> - (compare a b)) newL


(*** Main mirror functions ***)

let incrVersionsOfMirrors filePath =
  let oldMirrors = findAllMirrors filePath in
  debugmirrors (fun () ->
           (Util.msg "incrVersionOfMirrors for %s...\n"
              (Fspath.concatToString mirrorDirectory filePath)));
  List.iter
    (fun (curVersion, curPath, newPath) ->
       if curVersion + 1 < Prefs.read mirrorversions then begin
         debugmirrors (fun () ->
           Util.msg "  rename %s to %s\n" curPath newPath);
         Os.rename
           mirrorDirectory (Path.fromString curPath)
           mirrorDirectory (Path.fromString newPath)
       end else begin
         debugmirrors (fun () -> Util.msg "  delete %s\n" curPath);
         Os.delete mirrorDirectory (Path.fromString curPath)
       end)
    oldMirrors

(* <PUBLIC> Find the fspath for the mirror file corresponding to a given
   path in the local replica *)
let findMirror mirrorPath =
  debugmirrors (fun () -> Util.msg
             "findMirror :  %s\n"  (Path.toString mirrorPath));
  if Pred.test mirror (Path.toString mirrorPath) then begin
    let fullFspath = Fspath.concat mirrorDirectory mirrorPath in
    if isFile fullFspath then
      Some fullFspath
    else
      None
  end else
    None

let rec testAndCreateMirrorTree path =
  debugmirrors (fun _ ->
    Util.msg "testAndCreateMirrorTree for path %s\n" (Path.toString path));
  match (Path.deconstructRev path) with
    Some (_, parentPath) ->
      makeMirrorDirLocal parentPath
  | None ->
      ()   (* We've reached the empty path, which means that the whole
              mirror directory is missing; it will be created by our caller *)

and makeMirrorDirLocal path =
  debugmirrors (fun () -> Util.msg
      "makeMirrorDir: creating directory %s in %s\n"
      (Path.toString path) (Fspath.toString mirrorDirectory));
  let fullFspath = Fspath.concat mirrorDirectory path in
  let (isThereSomething, isDir) =
    try
      (true, (Fspath.lstat (fullFspath)).Unix.st_kind = Unix.S_DIR)
    with Unix.Unix_error _ -> (false, false)
  in
  match (isThereSomething, isDir) with
    (false, _) ->
      testAndCreateMirrorTree path;
      Os.createDir mirrorDirectory path Props.dirDefault
  | (_, false) ->
      incrVersionsOfMirrors path;
      Os.createDir mirrorDirectory path Props.dirDefault
  | _ -> ()

let makeMirrorFileLocal fspathFrom pathFrom pathTo =
  debugmirrors (fun () -> Util.msg
    "makeMirrorFile2: %s in %s   to   %s in %s\n"
    (Path.toString pathFrom) (Fspath.toString fspathFrom)
    (Path.toString pathTo) (Fspath.toString mirrorDirectory));
  (* The goal of this fingerprinting is to make sure that all mirrors of
     a file are different, not to ensure that the mirrors really correspond
     to something in the archive *)
  let fing =
    try Some (Os.fingerprint fspathFrom pathFrom)
    with Util.Transient _ -> None
  in
  let fingBck =
    try Some (Os.fingerprint mirrorDirectory pathTo)
    with Util.Transient _ -> None in
  if (fing <> fingBck) && isFile (Fspath.concat fspathFrom pathFrom) then begin
    testAndCreateMirrorTree pathTo;
    incrVersionsOfMirrors pathTo;
    Util.convertUnixErrorsToTransient
      "copying mirror locally"
      (fun () ->
         let source = Fspath.concatToString fspathFrom pathFrom in
         withOpenFile fspathFrom pathFrom `Read (fun inFd ->
         withOpenFile mirrorDirectory pathTo `Write (fun outFd ->
           Uutil.readWrite inFd outFd (fun _ -> ());
           Unix.close inFd;
           Unix.close outFd;
           match fing with
             Some fp -> Xferhint.insertEntry (mirrorDirectory, pathTo) fp
           | None -> ())))
  end

let makeMirrorFileOnRoot
    : Common.root -> Path.t * Path.t -> unit Lwt.t
    =
  Remote.registerRootCmd "makeMirrorFileInter"
    (fun (fspathFrom, (pathFrom, pathTo)) ->
       Lwt.return (makeMirrorFileLocal fspathFrom pathFrom pathTo))

(* <PUBLIC> Mirror a file that is about to be overwritten *)
let makeMirrorFile root pathFrom pathTo =
  if Pred.test mirror (Path.toString pathFrom) then
    makeMirrorFileOnRoot root (pathFrom, pathTo)
  else
    Lwt.return ()

let makeMirrorSymlinkLocal path strlink =
  debugmirrors (fun () -> Util.msg
             "makeMirrorSymlinkLocal : \n symlink : %s pointed on %s\n"
             (Path.toString path) (strlink));
  testAndCreateMirrorTree path;
  incrVersionsOfMirrors path;
  Os.symlink mirrorDirectory path strlink

let rec makeMirrorRec recursive fspathFrom pathFrom pathTo archive =
  debugmirrors (fun () -> Util.msg "makeMirrorRec: %s %s %s\n"
             (Fspath.toString fspathFrom) (Path.toString pathFrom)
             (Path.toString pathTo));
  match archive with
    ArchiveDir (desc, children) ->
      makeMirrorDirLocal pathTo;
      begin match recursive with
        `Rec ->
          Safelist.iter
            (fun (nm, a) ->
               makeMirrorRec `Rec
                 fspathFrom (Path.child pathFrom nm) (Path.child pathTo nm) a)
            children
      | `NonRec ->
          ()
      end
  | ArchiveFile (desc, dig, _) ->
      makeMirrorFileLocal fspathFrom pathFrom pathTo
  | ArchiveSymlink l ->
      makeMirrorSymlinkLocal pathTo l
  | NoArchive ->
        incrVersionsOfMirrors pathTo

(* recursively make the backup accoring to the path specification. [archive]
   used for making sure no repetition in the backup *)
let makeMirror recursive fspath path realPath archive =
  if Pred.test mirror (Path.toString realPath) then
    makeMirrorRec recursive fspath path realPath archive


(***********************************************************************
                           UPDATE DETECTION
************************************************************************)

(* Generate a tree of changes. Also, update the archive in case some
   timestamps have been changed without the files being actually updated. *)

let fastcheck =
  Prefs.createString "fastcheck" "default"
    "do fast update detection (`true', `false', or `default')"
    ( "When this preference is set to \\verb|true|, 
       Unison will use file creation times as `pseudo inode numbers' 
       when scanning replicas for updates, \
       instead of reading the full contents of every file.  Under \
       Windows, this may cause Unison to miss propagating an update \
       if the create time, modification time, and length of the \
       file are all unchanged by the update (this is not easy to \
       achieve, but it can be done).  However, Unison will never \
       {\\em overwrite} such an update with a change from the other \
       replica, since it always does a safe check for updates just \
       before propagating a change.  Thus, it is reasonable to use \
       this switch under Windows most of the time and occasionally \
       run Unison once with {\\tt fastcheck} set to 
       \\verb|false|, if you are \
       worried that Unison may have overlooked an update.  The default \
       value of the preference is \\verb|auto|, which causes Unison to \
       use fast checking on Unix replicas (where it is safe) and slow \
       checking on  Windows replicas.  For backward compatibility, \
       \\verb|yes|, \\verb|no|, and \\verb|default| can be used in place \
       of \\verb|true|, \\verb|false|, and \\verb|auto|.  See \
       \\sectionref{fastcheck}{Fast Checking} for more information.")

let useFastChecking () =
      (Prefs.read fastcheck = "yes")
   || (Prefs.read fastcheck = "true")
   || (Prefs.read fastcheck = "default" && Util.osType = `Unix)
   || (Prefs.read fastcheck = "auto" && Util.osType = `Unix)

let dummy_dig = Os.fingerprintString ""
let symlink_info = Common.Previous (`SYMLINK, Props.dummy, dummy_dig)
let absent_info = Common.New
let oldInfoOf archive =
  match archive with
    ArchiveDir  (oldDesc, _) ->
      Common.Previous (`DIRECTORY, oldDesc, dummy_dig)
  | ArchiveFile (oldDesc, dig, _) ->
      Common.Previous (`FILE, oldDesc, dig)
  | ArchiveSymlink _ ->
      symlink_info
  | NoArchive ->
      absent_info

(* Check whether a file's permissions have not changed *)
let isPropUnchanged info archiveDesc =
  Props.similar info.Fileinfo.desc archiveDesc

(* Handle file permission change *)
let checkPropChange info archive archDesc =
  if
    isPropUnchanged info archDesc
  then begin
    debug (fun() -> Util.msg "  Unchanged file\n");
    NoUpdates
  end else begin
    debug (fun() -> Util.msg "  File permissions updated\n");
    Updates (File (info.Fileinfo.desc, ContentsSame),
             oldInfoOf archive)
  end

(* Check whether a file has changed has changed, by comparing its digest and
   properties against [archDesc], [archDig], and [archStamp].

   Returns a pair (optArch, ui): [optArch] is not None when the file remains
   unchanged but time might be changed.  [optArch] is used by [buildUpdate]
   series functions to compute the _old_ archive with updated time stamp---
   Zhe's question: is this just to reduce the number of such false update
   checks in the future? *)
let checkContentsChange
    currfspath path info archive archDesc archDig archStamp fastCheck
   : archive option * Common.updateItem
   =
  debug (fun () ->
    let aS =  archStamp and aR = archive in
    Util.msg "checkContentsChange :\n";
    begin match aR with
      ArchiveFile (_, _, (Fileinfo.InodeStamp inode)) ->
        Util.msg "  archive : stamp is inode (%d)\n" inode
    | ArchiveFile (_, _, (Fileinfo.CtimeStamp date)) ->
        Util.msg "  archive : stamp is ctime (%f)\n" date
    | _ -> Util.msg "  archive : not a file\n"
    end;
    begin
      match aS with
        Fileinfo.InodeStamp inode ->
          (Util.msg "  archStamp is inode (%d)\n" inode;
           Util.msg "  info.inode         (%d)\n" info.Fileinfo.inode)
      | Fileinfo.CtimeStamp stamp ->
          (Util.msg "  archStamp is ctime (%f)\n" stamp;
           Util.msg "  info.ctime         (%f)\n" info.Fileinfo.ctime)
    end);
  match archStamp with
    Fileinfo.InodeStamp inode
    when info.Fileinfo.inode = inode
        && Props.same_time info.Fileinfo.desc archDesc
        && Props.length info.Fileinfo.desc = Props.length archDesc
        && fastCheck ->
          Xferhint.insertEntry (currfspath, path) archDig;
          None, checkPropChange info archive archDesc
  | Fileinfo.CtimeStamp ctime
    when info.Fileinfo.ctime = ctime
        && Props.same_time info.Fileinfo.desc archDesc
        && Props.length info.Fileinfo.desc = Props.length archDesc
        && fastCheck ->
          Xferhint.insertEntry (currfspath, path) archDig;
          None, checkPropChange info archive archDesc
  | _ ->
      debug (fun() -> Util.msg "  Possibly updated file\n");
      let (info, newDigest) =
        Os.safeFingerprint currfspath path info None in
      Xferhint.insertEntry (currfspath, path) newDigest;
      if archDig = newDigest then
        Some (ArchiveFile
                (Props.setTime archDesc (Props.time info.Fileinfo.desc),
                 archDig, Fileinfo.stamp info)),
        checkPropChange info archive archDesc
      else begin
        debug (fun() -> Util.msg "  Updated file\n");
        None,
        Updates (File (info.Fileinfo.desc,
                       ContentsUpdated (newDigest, Fileinfo.stamp info)),
                 oldInfoOf archive)
      end

(* getChildren = childrenOf + repetition check

   Find the children of fspath+path, and return them, partitioned into those
   with case conflicts, those with illegal cross platform filenames, and
   those without problems.

   Note that case conflicts and illegal filenames can only occur under Unix,
   when syncing with a Windows file system. *)
let badWindowsFilenameRx =
  (* FIX: This should catch all device names (like aux, con, ...).  I don't
     know what all the possible device names are. *)
  Rx.rx "aux|con|lpt1|prn|(.*[\000-\031\\/<>:\"|].*)"
let getChildren fspath path =
  let sl =
    (* A list of strings, not names, because case is important here *)
    Os.childrenOf fspath path in
  if Util.osType=`Unix && Case.insensitive () then
    (* Case conflicts are possible *)
    let rec sameNamePartition s x =
      (* returns (same,diff) where same is the sublist of x that's
         nocase_eq to s, and diff is the rest.  Assumes x nocase sorted. *)
      match x with
        [] -> ([],[])
      | hd::tl ->
          if not(Util.nocase_eq s hd)
          then ([],x)
          else let (same,diff) = sameNamePartition s tl in (hd::same,diff) in
    let badWindowsFilename s =
      (* FIX: should also check for a max filename length, not sure how much *)
      Rx.match_string badWindowsFilenameRx s in
    let rec loop x =
      match x with
        [] -> ([],[],[])
      | hd::tl ->
          let n = Name.fromString hd in
          (* We rely on ignore being case insensitive here, else we
             might miss a case conflict *)
          if Globals.shouldIgnore (Path.child path n)
          then loop tl
          else if badWindowsFilename hd then
            let (prob1,prob2,noprob) = loop tl in
            (prob1,n::prob2,noprob)
          else
            let (same,diff) = sameNamePartition hd x in
            let (prob1,prob2,noprob) = loop diff in
            match same with
              [] -> assert false
            | _::_::_ -> (n::prob1,prob2,noprob) (* Case conflict *)
            | [hd] -> (prob1,prob2,n::noprob) in (* No case conflict *)
    loop (Safelist.stable_sort Util.nocase_cmp sl)
  else
    (* No case conflicts or bad filenames are possible, just do ignore *)
    let notignored n = not(Globals.shouldIgnore (Path.child path n)) in
    ([],[],
     Safelist.filter notignored (Safelist.map Name.fromString sl))

let statusDepth =
  Prefs.createInt "statusdepth" 2 "status display depth for local files"
    "This preference suppresses the display of status messages
     during update detection on the local machine for paths deeper than
     the specified cutoff.
     (Displaying too many local status messages can slow down update
     detection somewhat.)"

(* Note that we do *not* want to do any status displays from the server
   side, since this will cause the server to block until the client has
   finished its own update detection and can receive and acknowledge
   the status display message -- effectively serializing the client and
   server. *)
let showStatus path =
  if not !Trace.runningasserver then begin
    let depth = Prefs.read statusDepth in
    if not (Path.isEmpty path) && Path.length path <= depth then
      Trace.statusDetail (Path.toString path)
  end

(* from a list of (name, archive) pairs {usually the items in the same
   directory}, build two lists: the first a named list of the _old_
   archives, with their timestamps updated for the files whose contents
   remain unchanged, the second a named list of updates *)
let rec buildUpdateChildren
    fspath path (arcChi: (Name.t * archive) list) fastCheck
    :(Name.t * archive) list * (Name.t * Common.updateItem) list
    =
  showStatus path;
  let (caseChi,illegalChi,okChi) =
    (* Children with case conflicts, illegal filenames, and no problems *)
    getChildren fspath path in
  let prevChi =
    Safelist.filter
      (fun n -> not (Globals.shouldIgnore (Path.child path n)))
      (fst (Safelist.split arcChi))
  in
  let prevChi =
    (* If a file is in the archive but now there is a case conflict,
       we'll handle the conflict by processing caseChi.  So, we
       remove the file from prevChi now. *)
    Safelist.filter
      (fun n -> not(Safelist.exists (Name.eq n) caseChi))
      prevChi in
  (* In caseInsensitive mode, we maintain the invariant that the
     archive never contains case conflicts, so that prevChi has no
     case conflicts.  However, there may be case conflicts between
     okChi and prevChi; we have to be careful in combining
     them. *)
  let allChildren =
    Safelist.fold_right
      (fun n nl ->
        if Safelist.exists (Name.eq n) nl
        then nl (* don't add a case conflict *)
        else n::nl)
      prevChi
      okChi in
  let caseChi =
    let err =
      "Two or more files on a Unix system have names identical except "^
      "for case.  They cannot be synchronized to a Windows file system." in
    let uiErr = Error err in
    Safelist.map (fun n -> (n,uiErr)) caseChi in
  let illegalChi =
    let uiErr = Error "The name of this Unix file is not allowed in Windows" in
    Safelist.map (fun n -> (n,uiErr)) illegalChi in
  let updateChildren =
    Safelist.filterMap2
      (fun childName ->
         let newPath = Path.child path childName in
         let archive = try lookup childName arcChi
                       with Not_found -> NoArchive in
         let arch, uiChild =
           buildUpdateRec archive fspath newPath fastCheck in
         (begin match arch with
            None      -> None
          | Some arch -> Some (childName, arch)
          end,
          begin match uiChild with
            NoUpdates -> None
          | _         -> Some(childName, uiChild)
          end))
      allChildren in
  (* Still todo: archive updates for the caseChi, illegalChi ?? *)
  let archiveupdates = fst updateChildren in
  let childupdates = caseChi@illegalChi@(snd updateChildren) in
  let childupdates =
    (* It's important to sort here, recon relies on it *)
    Safelist.stable_sort
      (fun (n,ui) (n',ui') -> Name.compare n n')
      childupdates in
  (archiveupdates,childupdates)

and buildUpdateRec archive currfspath path fastCheck =
  try
    debug (fun() ->
      Util.msg "buildUpdate: %s\n"
        (Fspath.concatToString currfspath path));
    let info = Fileinfo.get true currfspath path in
    match (info.Fileinfo.typ, archive) with
      (`ABSENT, NoArchive) ->
        debug (fun() -> Util.msg "  Absent and no archive\n");
        None, NoUpdates
    | (`ABSENT, _) ->
        debug (fun() -> Util.msg "  Deleted\n");
        None, Updates (Absent, oldInfoOf archive)
    (* --- *)
    | (`FILE, ArchiveFile (archDesc, archDig, archStamp)) ->
        checkContentsChange
          currfspath path info archive archDesc archDig archStamp fastCheck
    | (`FILE, _) ->
        debug (fun() -> Util.msg "  Updated file\n");
        None,
        let (info, dig) = Os.safeFingerprint currfspath path info None in
        Xferhint.insertEntry (currfspath, path) dig;
        Updates (File (info.Fileinfo.desc,
                       ContentsUpdated(dig, Fileinfo.stamp info)),
                 oldInfoOf archive)
    (* --- *)
    | (`SYMLINK, ArchiveSymlink prevl) ->
        let l = Os.readLink currfspath path in
        debug (fun() ->
          if l = prevl then
            Util.msg "  Symlink %s (unchanged)\n" l
          else
            Util.msg "  Symlink %s (previously: %s)\n" l prevl);
        (None,
         if l = prevl then NoUpdates else
         Updates (Symlink l, oldInfoOf archive))
    | (`SYMLINK, _) ->
        let l = Os.readLink currfspath path in
        debug (fun() -> Util.msg "  New symlink %s\n" l);
        None, Updates (Symlink l, oldInfoOf archive)
    (* --- *)
    | (`DIRECTORY, ArchiveDir (archDesc, prevChildren)) ->
        debug (fun() -> Util.msg "  Directory\n");
        let (archUpdates, childUpdates) =
          buildUpdateChildren currfspath path prevChildren fastCheck
        in
        let (permchange, desc) =
          if isPropUnchanged info archDesc then (PropsSame, archDesc)
                                           else (PropsUpdated, info.Fileinfo.desc)
        in
        (begin if archUpdates <> [] then
           let children =
             Safelist.fold_right
               (fun (nm, a) l -> (nm, a) :: remove nm l)
               archUpdates prevChildren
           in
           Some (ArchiveDir (archDesc, children))
         else
           None
         end,
         if childUpdates <> [] or permchange = PropsUpdated then
           Updates (Dir (desc, childUpdates, permchange),
                    oldInfoOf archive)
         else
           NoUpdates)
    | (`DIRECTORY, _) ->
        debug (fun() -> Util.msg "  New directory\n");
        let (_, childUpdates) =
          buildUpdateChildren currfspath path [] fastCheck in
        (* BCPFIX: This is a bit of a hack and does not really work, since
           it means that we calculate the size of a directory just once and
           then never update our idea of how big it is.  The size should
           really be recalculated when things change. *)
        let newdesc =
           Props.setLength info.Fileinfo.desc
             (List.fold_left
               (fun s (_,ui) -> Uutil.addfilesizes s (uiLength ui))
               Uutil.zerofilesize childUpdates) in
        (None,
         Updates (Dir (newdesc, childUpdates, PropsUpdated),
                  oldInfoOf archive))
  with
    Util.Transient(s) -> None, Error(s)

(* compute the udpates for [path] against archive.  Also returns an archive,
   which is the old archive with time stamps updated appropriately (i.e.,
   for those files whose contents remain unchanged). *)
let buildUpdate archive fspath path
    : archive * Common.updateItem
    =
  if Globals.shouldIgnore path then
    (NoArchive, NoUpdates)
  else
    let (arch, ui) =
      buildUpdateRec archive fspath path (useFastChecking()) in
    (begin match arch with
       None      -> archive
     | Some arch -> arch
     end,
     ui)

(* for the given path, find the archive and compute the list of update
   items; as a side effect, update the local archive w.r.t. time-stamps for
   unchanged files *)
let findLocal fspath pathList: Common.updateItem list =
  debug (fun() -> Util.msg "findLocal %s\n" (Fspath.toString fspath));
  let (arcName,thisRoot) = archiveName fspath MainArch in
  List.iter (fun p -> Os.checkThatParentPathIsADir fspath p) pathList;
  (*
  Xferhint.init ();                ready the fingerprint->path map
  *)
  let archive = findArchive thisRoot in
  let (archive, updates) =
    Safelist.fold_right
      (fun path (arch, upd) ->
        let (arch', ui) =
          updatePathInArchive arch fspath Path.empty path buildUpdate
        in
        arch', ui::upd)
      pathList (archive, [])
  in
  setArchiveLocal thisRoot archive;
  updates

(* <PUBLIC> ___ HERE *)
let findOnRoot =
  Remote.registerRootCmd
    "find"
    (fun (fspath, pathList) ->
       Lwt.return (findLocal fspath pathList))

(* [findUpdates ()] computes the updateItems of the (root, path) of *)
(* synchronization.  It uses suspensions to achieve some useful     *)
(* parallelism between activities on different hosts.               *)
let findUpdates (): Common.updateItem list Common.oneperpath =
  Lwt_unix.run
    (let pathList = Prefs.read Globals.paths in
     lockArchives () >>= (fun () ->
     Remote.Thread.unwindProtect
       (fun () ->
          doArchiveCrashRecovery () >>=
          loadArchives)
       (fun _ ->
          unlockArchives ();
          Lwt.return ()) >>= (fun () ->
     unlockArchives ();
     let t = Trace.startTimer "Collecting changes" in
     Globals.allRootsMapWithWaitingAction (fun r ->
       debug (fun() -> Util.msg "findOnRoot %s\n" (root2string r));
       findOnRoot r pathList)
       (fun (host, _) ->
         begin match host with
           Remote(_) -> Trace.statusDetail "Waiting for changes from server"
         | _ -> ()
         end)
       >>= (fun updates ->
     Trace.showTimer t;
     let result = Safelist.transpose updates in
     Trace.status "";
     Lwt.return (ONEPERPATH(result))))))

(*****************************************************************************)
(*                          Committing updates to disk                       *)
(*****************************************************************************)

(* To prepare for committing, write to Scratch Archive *)
let prepareCommitLocal (fspath,()) =
  let (newName, root) = archiveName fspath ScratchArch in
  let archive = findArchive root in
  (**
     :ZheDebug:
     Format.set_formatter_out_channel stdout;
     Format.printf "prepareCommitLocal: %s\n" (thisRootsGlobalName fspath);
     showArchive archive;
     Format.print_flush();
   **)
  let archiveHash = checkArchive true Path.empty archive 0 in
  storeArchiveLocal (Os.fileInUnisonDir newName) root archive archiveHash;
  Lwt.return archiveHash

let prepareCommitOnRoot
   = Remote.registerRootCmd "prepareCommit" prepareCommitLocal

(* To really commit, first prepare (write to scratch arch.), then make sure
   the checksum on all archives are equal, finally flip scratch to main.  In
   the event of checksum mismatch, dump archives on all roots and fail *)
let commitUpdates () =
  Lwt_unix.run
    (debug (fun() -> Util.msg "Updating archives\n");
     lockArchives () >>= (fun () ->
     Remote.Thread.unwindProtect
       (fun () ->
          Globals.allRootsMap (fun r -> prepareCommitOnRoot r ())
            >>= (fun checksums ->
          (* BCPFIX: Nuke the next two lines (??) *)
          if archivesIdentical checksums then begin
            (* Move scratch archives to new *)
            Globals.allRootsIter (fun r -> commitArchiveOnRoot r ())
              >>= (fun () ->
            (* Copy new to main *)
            Globals.allRootsIter (fun r -> postCommitArchiveOnRoot r ())
              >>= (fun () ->
            (* Clean up *)
            Globals.allRootsIter
              (fun r -> removeArchiveOnRoot r NewArch)))
          end else begin
            unlockArchives ();
            Util.msg "Dumping archives to ~/unison.dump on both hosts\n";
            Globals.allRootsIter (fun r -> dumpArchiveOnRoot r ())
              >>= (fun () ->
            Util.msg "Finished dumping archives\n";
            raise (Util.Fatal (
                 "Internal error: New archives are not identical.\n"
               ^ "Retaining original archives.  "
               ^    "Please run Unison again to bring them up to date.\n\n"
               ^ "If you get this message repeatedly, please \n "
               ^ "  a) notify unison-help@cis.upenn.edu\n"
               ^ "  b) move the archive files (~/.unison/arNNNNN) on each "
               ^ "     machine to some other directory (in case they may be\n"
               ^ "     useful for debugging)\n"
               ^ "  c) run unison again to synchronize from scratch."
      )))
          end))
       (fun _ -> unlockArchives (); Lwt.return ()) >>= (fun () ->
     unlockArchives ();
     Lwt.return ())))

(*****************************************************************************)
(*                            MARKING UPDATES                                *)
(*****************************************************************************)

(* the result of patching [archive] using [ui] *)
let rec updateArchiveRec ui archive =
  match ui with
    NoUpdates | Error _ ->
      archive
  | Updates (uc, _) ->
      match uc with
        Absent ->
          NoArchive
      | File (desc, ContentsSame) ->
          begin match archive with
            ArchiveFile (_, dig, stamp) -> ArchiveFile (desc, dig, stamp)
          | _                           -> assert false
          end
      | File (desc, ContentsUpdated (dig, stamp)) ->
          ArchiveFile (desc, dig, stamp)
      | Symlink l ->
          ArchiveSymlink l
      | Dir (desc, children, _) ->
          begin match archive with
            ArchiveDir (_, arcCh) ->
              let ch =
                Safelist.fold_right
                  (fun (nm, uiChild) ch ->
                    let ch' = remove nm ch in
                    let child =
                      try lookup nm ch with Not_found -> NoArchive
                    in
                    match updateArchiveRec uiChild child with
                      NoArchive -> ch'
                    | arch      -> (nm, arch)::ch')
                  children arcCh
              in
              ArchiveDir (desc, ch)
          | _ ->
              ArchiveDir
                (desc,
                 Safelist.filterMap
                   (fun (nm, uiChild) ->
                      match updateArchiveRec uiChild NoArchive with
                        NoArchive -> None
                      | arch      -> Some (nm, arch))
                   children)
          end

(* Remove ignored files and properties that are not synchronized *)
let rec stripArchive path arch =
  if Globals.shouldIgnore path then NoArchive else
  match arch with
    ArchiveDir (desc, children) ->
      ArchiveDir
        (Props.strip desc,
         Safelist.filterMap
           (fun (nm, ar) ->
              match stripArchive (Path.child path nm) ar with
                NoArchive -> None
              | ar'       -> Some (nm, ar'))
           children)
  | ArchiveFile (desc, dig, stamp) ->
      ArchiveFile (Props.strip desc, dig, stamp)
  | ArchiveSymlink _ | NoArchive ->
      arch

let updateArchiveLocal fspath path ui superMirrors id =
  debug (fun() ->
    Util.msg "updateArchiveLocal %s\n"
      (Fspath.concatToString fspath path));
  let root = thisRootsGlobalName fspath in
  let archive = findArchive root in
  let subArch = getPathInArchive archive fspath Path.empty path in
  let newArch = updateArchiveRec ui (stripArchive path subArch) in
  makeMirror `Rec fspath path path newArch;
  let commit () =
    let archive = findArchive root in
    let archive, () =
      updatePathInArchive archive fspath Path.empty path
        (fun _ _ _ -> newArch, ())
    in
    setArchiveLocal root archive
  in
  setCommitAction root id commit;
  newArch

let updateArchiveOnRoot =
  Remote.registerRootCmd
    "updateArchive"
    (fun (fspath, (path, ui, superMirrors, id)) ->
       Lwt.return (updateArchiveLocal fspath path ui superMirrors id))

let updateArchive root path ui superMirrors id =
  updateArchiveOnRoot root (path, ui, superMirrors, id)

(* This function is called for files changed only in identical ways. *)
(* It only updates the archives.                                     *)
let markEqualLocal fspath path uc =
  debug (fun() ->
    Util.msg "markEqualLocal %s\n"
      (Fspath.concatToString fspath path));
  let root = thisRootsGlobalName fspath in
  let archive = findArchive root in
  let archive, subArch =
    updatePathInArchive archive fspath Path.empty path
      (fun archive _ _ ->
         let arch = updateArchiveRec (Updates (uc, New)) archive in
         arch, arch)
  in
  makeMirror `NonRec fspath path path subArch;
  setArchiveLocal root archive;
  subArch

let markEqualOnRoot =
  Remote.registerRootCmd
    "markEqual"
    (fun (fspath, paths) ->
       Lwt.return
         (Tree.iteri paths Path.empty Path.child
            (fun path uc ->
               ignore (markEqualLocal fspath path uc))))

let markEqual equals =
  debug (fun()-> Util.msg "Marking %d paths equal\n" (Tree.size equals));
  if not (Tree.is_empty equals) then begin
    Lwt_unix.run
      (Globals.allRootsIter2
         markEqualOnRoot
         [Tree.map (fun n -> n) (fun (uc1,uc2) -> uc1) equals;
          Tree.map (fun n -> n) (fun (uc1,uc2) -> uc2) equals])
  end

(* BCPFIX: Don't we do this anyway?? *)
let verifyTransfers =
  Prefs.createBool "verifyTransfers" false
    "*double-check file transfers using fingerprints" ""

let rec replaceArchiveRec fspath path arch =
  match arch with
    ArchiveDir (desc, children) ->
      ArchiveDir (desc,
                  Safelist.map
                    (fun (nm, a) ->
                       (nm, replaceArchiveRec fspath (Path.child path nm) a))
                    children)
  | ArchiveFile (desc, dig, _) ->
      let info = Fileinfo.get true fspath path in
      (* Paranoid check: recompute the file's digest to match it with
         the archive's *)
      if Prefs.read verifyTransfers
         (* FIX: when we're confident that rsync is working, the following
            clause should be removed for efficiency... *)
         || Prefs.read Remote.rsyncActivated
      then begin
        let (_, fp) = Os.safeFingerprint fspath path info (Some dig) in
        if fp <> dig then
          (* FIXME rsync??? *)
          raise (Util.Transient "rsyncfailure")
      end;
      ArchiveFile (Props.override info.Fileinfo.desc desc,
                   dig, Fileinfo.stamp info)
  | ArchiveSymlink l ->
      ArchiveSymlink l
  | NoArchive ->
      arch

let replaceArchiveLocal fspath pathTo workingDir tempPathTo arch id =
  debug (fun() ->
    Util.msg "replaceArchiveLocal %s\n"
      (Fspath.concatToString fspath tempPathTo));
  debug (fun() -> Util.msg
             "replaceArchiveLocal2 %s %s %s %s\n"
             (Fspath.toString fspath)
             (Path.toString pathTo)
             (Fspath.toString workingDir)
             (Path.toString tempPathTo)
        );

  let root = thisRootsGlobalName fspath in
  let newArch = replaceArchiveRec workingDir tempPathTo arch in
  makeMirror `Rec workingDir tempPathTo pathTo newArch;
  let commit () =
    let archive = findArchive root in
    let archive, () =
      updatePathInArchive archive fspath Path.empty pathTo
        (fun _ _ _ -> newArch, ())
    in
    setArchiveLocal root archive
  in
  setCommitAction root id commit

let replaceArchiveOnRoot =
  Remote.registerRootCmd
    "replaceArchive"
    (fun (fspath, (pathTo, workingDir, tempPathTo, arch, id)) ->
       replaceArchiveLocal fspath pathTo workingDir tempPathTo arch id;
       Lwt.return ())

let replaceArchive root pathTo workingDir tempPathTo archive id =
  replaceArchiveOnRoot root (pathTo, workingDir, tempPathTo, archive, id)

(* Update the archive to reflect
      - the last observed state of the file on disk (ui)
      - the permission bits that have been propagated from the other
        replica, if any (permOpt) *)
let doUpdateProps arch propOpt ui =
  let newArch =
    match ui with
      Updates(File(desc,ContentsSame),_) ->
        begin match arch with
          ArchiveFile(_, dig, stamp) -> ArchiveFile(desc, dig, stamp)
        | _ -> assert false
        end
    | Updates(File(desc,ContentsUpdated(dig,stamp)),_) ->
        ArchiveFile(desc, dig, stamp)
    | Updates(Dir(desc,_,_),_) ->
        begin match arch with
          ArchiveDir(_, children) -> ArchiveDir(desc, children)
        | _ -> ArchiveDir(desc, [])
        end
    | NoUpdates -> arch
    | Updates(_,_) | Error _ -> assert false in
  match propOpt with
    Some desc' ->
      begin match newArch with
        ArchiveFile (desc, dig, stamp) ->
          ArchiveFile (Props.override desc desc', dig, stamp)
      | ArchiveDir (desc, children) ->
          ArchiveDir (Props.override desc desc', children)
      | _ ->
          assert false
      end
  | None -> newArch

let updatePropsLocal fspath path propOpt ui id =
  debug (fun() ->
    Util.msg "updatePropsLocal %s\n"
     (Fspath.concatToString fspath path));
  let root = thisRootsGlobalName fspath in
  let commit () =
    let archive = findArchive root in
    let archive, () =
      updatePathInArchive archive fspath Path.empty path
        (fun arch _ _ -> doUpdateProps arch propOpt ui, ())
    in
    setArchiveLocal root archive
  in
  setCommitAction root id commit

let updatePropsOnRoot =
  Remote.registerRootCmd
   "updateProps"
     (fun (fspath, (path, propOpt, ui, id)) ->
        Lwt.return (updatePropsLocal fspath path propOpt ui id))

let updateProps root path propOpt ui id =
   updatePropsOnRoot root (path, propOpt, ui, id)

(*************************************************************************)
(*                       Make sure no change has happened                *)
(*************************************************************************)

let checkNoUpdatesLocal fspath pathInArchive ui =
  debug (fun() ->
    Util.msg "checkNoUpdatesLocal %s %s\n"
      (Fspath.toString fspath) (Path.toString pathInArchive));
  let archive = findArchive (thisRootsGlobalName fspath) in
  let archive = getPathInArchive archive fspath Path.empty pathInArchive in
  let archive = updateArchiveRec ui archive in
  let (_, uiNew) = buildUpdateRec archive fspath pathInArchive false in
  if uiNew <> NoUpdates then
    (* FIX: we should print one of the modified files... *)
    raise (Util.Transient "Destination updated during synchronization")

let checkNoUpdatesOnRoot =
  Remote.registerRootCmd
    "checkNoUpdates"
    (fun (fspath, (pathInArchive, ui)) ->
       Lwt.return (checkNoUpdatesLocal fspath pathInArchive ui))

let checkNoUpdates root pathInArchive ui =
  checkNoUpdatesOnRoot root (pathInArchive, ui)
