(* $I1: Unison file synchronizer: src/files.ml $ *)
(* $I2: Last modified by zheyang on Tue, 09 Apr 2002 17:08:59 -0400 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

open Common
open Lwt

let debug = Trace.debug "files"

(* ------------------------------------------------------------ *)

let commitLogName = Util.fileInHomeDir "DANGER.README"

let writeCommitLog source target tempname =
  let sourcename = Fspath.toString source in
  let targetname = Fspath.toString target in
  debug (fun() -> Util.msg "Writing commit log: renaming %s to %s via %s\n"
    sourcename targetname tempname);
  let c =
    Util.convertUnixErrorsToFatal
      "writing commit log"
      (fun() ->
         open_out_gen [Open_wronly; Open_creat; Open_trunc; Open_excl]
           0o600 commitLogName) in
  Printf.fprintf c "Warning: the last run of %s terminated abnormally " Uutil.myName;
  Printf.fprintf c "while moving\n   %s\nto\n   %s\nvia\n   %s\n\n"
    sourcename targetname tempname;
  Printf.fprintf c "Please check the state of these files immediately\n";
  Printf.fprintf c "(and delete this notice when you've done so).\n";
  close_out c

let clearCommitLog () =
  debug (fun() -> (Util.msg "Deleting commit log\n"));
  try Unix.unlink commitLogName
  with Unix.Unix_error(_) -> ()

let processCommitLog () =
  if Sys.file_exists commitLogName then begin
    raise(Util.Fatal(
          Printf.sprintf
            "Warning: the previous run of %s terminated in a dangerous state.
             Please consult the file %s, delete it, and try again."
                 Uutil.myName
                 commitLogName))
  end else
    Lwt.return ()

let processCommitLogOnHost =
  Remote.registerHostCmd "processCommitLog" processCommitLog

let processCommitLogs() =
  Lwt_unix.run
    (Globals.allHostsIter (fun h -> processCommitLogOnHost h ()))

(* ------------------------------------------------------------ *)

let deleteLocal (fspath, (keepbackups, workingDirOpt, path)) =
  let (workingDir,realPath) =
    match workingDirOpt with
      Some p -> (p, path)
    | None -> Fspath.findWorkingDir fspath path in
  if keepbackups then begin
    let backPath = Os.backupPath workingDir realPath in
    Os.rename workingDir realPath workingDir backPath;
    Xferhint.renameEntry (workingDir, realPath) (workingDir, backPath)
  end
  else begin
    Os.delete workingDir realPath;
    Xferhint.deleteEntry (workingDir, realPath)
  end;
  Lwt.return ()

let performDelete = Remote.registerRootCmd "delete" deleteLocal

(* FIX: maybe we should rename the destination before making any check ? *)
let delete keepbackups rootFrom pathFrom rootTo pathTo ui =
  Update.transaction (fun id ->
    Update.replaceArchive
      rootFrom pathFrom (snd rootFrom) pathFrom Update.NoArchive id
      >>= (fun () ->
    (*Unison do the next line cause we want to keep a backup of the file
      FIX: We only need this when we are making backups*)
    Update.updateArchive rootTo pathTo ui true id >>= (fun _ ->
    Update.replaceArchive
      rootTo pathTo (snd rootTo) pathTo Update.NoArchive id >>= (fun () ->
    (* Make sure the target is unchanged *)
    (* There is an unavoidable race condition here *)
    Update.checkNoUpdates rootTo pathTo ui >>= (fun () ->
    performDelete rootTo (keepbackups, None, pathTo))))))

(* ------------------------------------------------------------ *)

let setPropRemote =
  Remote.registerRootCmd
    "setProp"
    (fun (fspath, (workingDir, path, kind, newDesc)) ->
       Fileinfo.set workingDir path kind newDesc;
       Lwt.return ())

let setPropRemote2 =
  Remote.registerRootCmd
    "setProp2"
    (fun (fspath, (path, kind, newDesc)) ->
       let (workingDir,realPath) = Fspath.findWorkingDir fspath path in
       Fileinfo.set workingDir realPath kind newDesc;
       Lwt.return ())

(* FIX: we should check there has been no update before performing the
   change *)
let setProp fromRoot toRoot path newDesc oldDesc uiFrom uiTo =
  debug (fun() ->
    Util.msg
      "setProp %s %s %s\n   %s %s %s\n"
      (root2string fromRoot) (Path.toString path)
      (Props.toString newDesc)
      (root2string toRoot) (Path.toString path)
      (Props.toString oldDesc));
  Update.transaction (fun id ->
    Update.updateProps fromRoot path None uiFrom id >>= (fun () ->
    (*
      [uiTo] provides the modtime while [desc] provides the other
      file properties
    *)
    Update.updateProps toRoot path (Some newDesc) uiTo id >>= (fun () ->
    setPropRemote2 toRoot (path, `Update oldDesc, newDesc))))

(* ------------------------------------------------------------ *)

let mkdirRemote =
  Remote.registerRootCmd
    "mkdir"
    (fun (fspath,(workingDir,path)) ->
       Os.createDir workingDir path Props.dirDefault;
       Lwt.return (Fileinfo.get false workingDir path).Fileinfo.desc)

let mkdir onRoot workingDir path = mkdirRemote onRoot (workingDir,path)

(* ------------------------------------------------------------ *)

(* Rename a file to a file.  Windows and Unix operate differently if
   target file already exists: in Windows an exception is raised, in
   Unix the file is clobbered.  In both Windows and Unix, if the target
   is an existing **directory**, an exception will be raised. *)
let renameLocal (_, (keepbackups, fspath, pathFrom, pathTo)) =
  let source = Fspath.concat fspath pathFrom in
  let target = Fspath.concat fspath pathTo in
  Util.convertUnixErrorsToTransient
    (Printf.sprintf "renaming %s to %s"
       (Fspath.toString source) (Fspath.toString target))
    (fun () ->
       let filetypeFrom =
         (Fileinfo.get false source Path.empty).Fileinfo.typ in
       let filetypeTo =
         (Fileinfo.get false target Path.empty).Fileinfo.typ in
       let moveFirst =
         match (filetypeFrom, filetypeTo) with
         | (_, `ABSENT)            -> false
         | (_, _) when keepbackups -> true
         | ((`FILE | `SYMLINK),
            (`FILE | `SYMLINK))    -> Util.osType <> `Unix
         | _                       -> true (* Safe default *)
       in
       let source' = Fspath.toString source in
       let target' = Fspath.toString target in
       if moveFirst then begin
         debug (fun() -> Util.msg "rename: moveFirst=true\n");
         let tmpPath =
           (if keepbackups then Os.backupPath else Os.tempPath)
             fspath pathTo in
         let temp = Fspath.concatToString fspath tmpPath in
         writeCommitLog source target temp;
         debug (fun() -> Util.msg "rename %s to %s\n" target' temp);
         Unix.rename target' temp;
         if keepbackups then
           Xferhint.renameEntry (fspath, pathTo) (fspath, tmpPath);
         debug (fun() -> Util.msg "rename %s to %s\n" source' target');
         Unix.rename source' target';
         Xferhint.renameEntry (fspath, pathFrom) (fspath, pathTo);
         if not keepbackups then
           Os.delete fspath tmpPath;
         clearCommitLog()
       end else begin
         debug (fun() -> Util.msg "rename: moveFirst=false\n");
         Unix.rename source' target';
         Xferhint.renameEntry (fspath, pathFrom) (fspath, pathTo)
       end;
       Lwt.return ())

let renameOnHost = Remote.registerRootCmd "rename" renameLocal

(* FIX: maybe we should rename the destination before making any check ? *)
let rename keepbackups root pathInArchive workingDir pathOld pathNew ui =
  debug (fun() ->
    Util.msg "rename(keepbackups=%b, root=%s, pathOld=%s, pathNew=%s)\n"
      keepbackups (root2string root)
      (Path.toString pathOld) (Path.toString pathNew));
 (* Make sure the target is unchanged *)
  (* There is an unavoidable race condition here *)
  Update.checkNoUpdates root pathInArchive ui >>= (fun () ->
  renameOnHost root (keepbackups, workingDir, pathOld, pathNew))

(* ------------------------------------------------------------ *)

(* FIX: Maybe we should rather try to do as much as possible of the
   copy rather than completely fail ? *)
let checkContentsChangeLocal currfspath path archDesc archDig archStamp =
  let info = Fileinfo.get true currfspath path in
  match archStamp with
    Fileinfo.InodeStamp inode
        when info.Fileinfo.inode = inode
          && Props.same_time info.Fileinfo.desc archDesc ->
      if Props.length archDesc <> Props.length info.Fileinfo.desc then
        raise (Util.Transient (Printf.sprintf
          "The file %s\nhas been modified during synchronization: \
           transfer aborted.%s"
           (Fspath.concatToString currfspath path)
           (if Util.osType = `Win32 && (Prefs.read Update.fastcheck)="yes" then
             "If this happens repeatedly, try running once with the \
             fastcheck option set to 'no'."
            else "")))
  | _ ->
      (* Note that we fall back to the paranoid check (using a fingerprint)
         even if a CtimeStamp was provided, since we do not trust them
         completely. *)
      let newDigest = Os.fingerprint currfspath path in
      if archDig <> newDigest then
        raise (Util.Transient
                 (Printf.sprintf
                    "The file %s\nhas been modified during synchronization: \
                     transfer aborted"
                    (Fspath.concatToString currfspath path)))

let checkContentsChangeOnHost =
  Remote.registerRootCmd
    "checkContentsChange"
    (fun (currfspath, (path, archDesc, archDig, archStamp)) ->
       checkContentsChangeLocal currfspath path archDesc archDig archStamp;
       Lwt.return ())

let checkContentsChange root path archDesc archDig archStamp =
  checkContentsChangeOnHost root (path, archDesc, archDig, archStamp)

(* ------------------------------------------------------------ *)

(* Calculate the target working directory and paths for the copy.
      workingDir  is an fspath naming the directory on the target
                  host where the copied file will actually live.
                  (In the case where pathTo names a symbolic link, this
                  will be the parent directory of the file that the
                  symlink points to, not the symlink itself.  Note that
                  this fspath may be outside of the replica, or even
                  on a different volume.)
      realPathTo  is the name of the target file relative to workingDir.
                  (If pathTo names a symlink, this will be the name of
                  the file pointed to by the symlink, not the name of the
                  link itself.)
      tempPathTo  is a temporary file name in the workingDir.  The file (or
                  directory structure) will first be copied here, then
                  "almost atomically" moved onto realPathTo. *)

let setupTargetPathsLocal (fspath, toPath) =
  let (workingDir,realPathTo) = Fspath.findWorkingDir fspath toPath in
  let tempPathTo = Os.tempPath workingDir realPathTo in
  Lwt.return (workingDir, realPathTo, tempPathTo)

let setupTargetPaths =
  Remote.registerRootCmd "setupTargetPaths" setupTargetPathsLocal

(* ------------------------------------------------------------ *)

let makeSymlink =
  Remote.registerRootCmd
    "makeSymlink"
    (fun (fspath, (workingDir, path, l)) ->
       Os.symlink workingDir path l;
       Lwt.return ())

let copyLocal
    update fspathFrom pathFrom fspathTo pathTo realPathTo newDesc id =
  Util.convertUnixErrorsToTransient
    "copying locally"
    (fun () ->
       Uutil.showProgress id Uutil.Filesize.zero "l";
       let source = Fspath.concatToString fspathFrom pathFrom in
       let outFd =
         Unix.openfile (Fspath.concatToString fspathTo pathTo)
             [Unix.O_RDWR;Unix.O_CREAT;Unix.O_EXCL] 0o600
       in
       let inFd = Unix.openfile source [Unix.O_RDONLY] 0o444 in
       Uutil.readWrite inFd outFd
         (fun l -> Uutil.showProgress id (Uutil.Filesize.ofInt l) "l");
       Unix.close inFd;
       Unix.close outFd;
       match update with
         `Update _ ->
           Fileinfo.set fspathTo pathTo (`Copy realPathTo) newDesc
       | `Copy ->
           Fileinfo.set fspathTo pathTo (`Set Props.fileDefault) newDesc)

let tryCopyMovedFile (fspath,
                      (fp, update, workingDir, pathTo, realPathTo, desc, id))
                   : bool Lwt.t =
  debug (fun () -> Util.msg "tryCopyMovedFile: -> %s /%s/\n"
      (Path.toString pathTo) (Os.fingerprint2string fp));
  match Xferhint.lookup fp with
    None ->
      Lwt.return false
  | Some (candidateFspath, candidatePath) ->
      debug (fun () ->
        Util.msg "tryCopyMovedFile: found match at %s,%s. Try local copying\n"
          (Fspath.toString (candidateFspath)) (Path.toString (candidatePath)));
      Lwt.catch
        (fun () ->
          copyLocal update candidateFspath candidatePath
            workingDir pathTo realPathTo desc id;
          if Os.fingerprint workingDir pathTo = fp then begin
            debug (fun () -> Util.msg "tryCopyMoveFile: success.\n");
            Xferhint.insertEntry (workingDir, pathTo) fp;
            Lwt.return true
          end else begin
            debug (fun () ->
              Util.msg "tryCopyMoveFile: candidate file modified!");
            Xferhint.deleteEntry (candidateFspath, candidatePath);
            Os.delete workingDir pathTo;
            Lwt.return false
          end)
        (fun e ->
          match e with
            Util.Transient s ->
              debug (fun () ->
                Util.msg "tryCopyMovedFile: failed local copy [%s]" s);
              Xferhint.deleteEntry
                (candidateFspath, candidatePath); (* banishing the evil *)
              Os.delete workingDir pathTo;
              Lwt.return false
          | _ ->
              Lwt.fail e)

let tryCopyMovedFileOnRoot =
  Remote.registerRootCmd "tryCopyMovedFile" tryCopyMovedFile

let tryCopyMovedFileOnRootWithFallback
       rootTo fpOpt update workingDir pathTo realPathTo desc id
       (fallBack: unit -> unit Lwt.t)
    : unit Lwt.t =
  match Prefs.read Xferhint.xferbycopying, fpOpt with
    false, _      -> fallBack ()
  | true, None    -> fallBack ()
  | true, Some fp ->
      tryCopyMovedFileOnRoot rootTo
        (fp, update, workingDir, pathTo, realPathTo, desc, id) >>=
      (fun success ->
        if success then
          Lwt.return ()
        else
          fallBack ())


(* the optional fingerprint [fpOpt], when not None, is used to find possible
   local copy of the remote file, thereby reducing remote copy to local copy *)
let copyRegFile
      update rootFrom pathFrom rootTo workingDir pathTo realPathTo desc id
      (fpOpt: Os.fingerprint option) =
  debug (fun() -> Util.msg "copyRegFile(%s,%s) -> (%s,%s,%s,%s) /%s/\n"
      (root2string rootFrom) (Path.toString pathFrom)
      (root2string rootTo) (Path.toString pathTo)
      (Path.toString realPathTo)
      (Props.toString desc)
      ((Util.option2string Os.fingerprint2string) fpOpt));
  let timer = Trace.startTimer "Transmitting file" in
  begin match rootFrom, rootTo with
    (Local, fspath1), (Local, fspath2) ->
      copyLocal update fspath1 pathFrom workingDir pathTo realPathTo desc id;
      Lwt.return ()
  | (Local, fspathFrom), (Remote host, fspathTo) ->
      tryCopyMovedFileOnRootWithFallback
        rootTo fpOpt update workingDir pathTo realPathTo desc id
        (fun () ->
          Remote.putFile host update
            fspathFrom pathFrom workingDir pathTo realPathTo desc id fpOpt)
  | (Remote host, fspathFrom), (Local, fspathTo) ->
      tryCopyMovedFileOnRootWithFallback
        rootTo fpOpt update workingDir pathTo realPathTo desc id
        (fun () ->
          Remote.getFile host update
            fspathFrom pathFrom workingDir pathTo realPathTo desc id fpOpt)
  | _ ->
      assert false
  end >>= (fun () ->
    Trace.showTimer timer;
    Lwt.return ())

let copyReg = Lwt_util.make_region 50

let copy
      keepbackups         (* true => keep old versions of files as backup *)
      update
      rootFrom pathFrom   (* copy from here... *)
      uiFrom              (* (and then check that this updateItem still
                             describes the current state of the src replica) *)
      rootTo pathTo       (* ...to here *)
      uiTo                (* (but, before committing the copy, check that
                             this updateItem still describes the current
                             state of the target replica) *)
      id =                (* for progress display *)
  debug (fun() ->
    Util.msg
      "copy %b \n   %s %s\n   %s %s\n" keepbackups
      (root2string rootFrom) (Path.toString pathFrom)
      (root2string rootTo) (Path.toString pathTo));
  (* Calculate target paths *)
  setupTargetPaths rootTo pathTo
     >>= (fun (workingDir, realPathTo, tempPathTo) ->
  (* Inner loop for recursive copy... *)
  let rec copyRec pFrom      (* Path to copy from *)
                  pTo        (* (Temp) path to copy to *)
                  realPTo    (* Path where this file will ultimately be placed
                                (needed by rsync, which uses the old contents
                                of this file to optimize transfer) *)
                  f =        (* Source archive subtree for this path *)
    debug (fun() ->
      Util.msg "copyRec %s %s  (%s)\n"
        (Path.toString pFrom) (Path.toString pTo) (Path.toString realPTo));
    if (Path.toString pFrom) <> (Path.toString pathFrom) then
      Trace.statusMinor(Path.toString pFrom);
    match f with
      Update.ArchiveFile (desc, dig, stamp) ->
        Lwt_util.run_in_region copyReg 1 (fun () ->
          copyRegFile update
            rootFrom pFrom rootTo workingDir pTo realPTo desc id (Some dig)
            >>= (fun () ->
          checkContentsChange rootFrom pFrom desc dig stamp))
    | Update.ArchiveSymlink l ->
        Lwt_util.run_in_region copyReg 1 (fun () ->
          debug (fun() -> Util.msg "Making symlink %s/%s -> %s\n"
                                   (root2string rootTo) (Path.toString pTo) l);
          makeSymlink rootTo (workingDir, pTo, l))
    | Update.ArchiveDir (desc, children) ->
        Lwt_util.run_in_region copyReg 1 (fun () ->
          debug (fun() -> Util.msg "Creating directory %s/%s\n"
            (root2string rootTo) (Path.toString pTo));
          mkdir rootTo workingDir pTo) >>= (fun initialDesc ->
        let actions = List.map
          (fun (name, child) ->
             copyRec (Path.child pFrom name)
                     (Path.child pTo name)
                     (Path.child realPTo name)
                     child)
          children
        in
        Lwt_util.join actions >>= (fun () ->
        Lwt_util.run_in_region copyReg 1 (fun () ->
          (* We use the actual file permissions so as to preserve
             inherited bits *)
          setPropRemote rootTo
            (workingDir, pTo, `Set initialDesc, desc))))
    | Update.NoArchive ->
        assert false
  in
  Remote.Thread.unwindProtect
    (fun () ->
       Update.transaction (fun id ->
         (* Update the archive on the source replica (but don't commit
            the changes yet) and return the part of the new archive
            corresponding to this path *)
         Update.updateArchive rootFrom pathFrom uiFrom true id
           >>= (fun archFrom ->
         let make_backup =
           (* Perform (asynchronously) a backup of the destination files *)
           Update.updateArchive rootTo pathTo uiTo true id
         in
         copyRec pathFrom tempPathTo realPathTo archFrom >>= (fun () ->
         make_backup >>= (fun _ ->
         let update_dest_archive =
           Update.replaceArchive
             rootTo pathTo workingDir tempPathTo archFrom id
         in
         rename keepbackups rootTo pathTo
           workingDir tempPathTo realPathTo uiTo >>= (fun () ->
         update_dest_archive))))))
    (fun _ ->
       performDelete rootTo (false, Some workingDir, tempPathTo)))

(* ------------------------------------------------------------ *)

let readChannelTillEof c =
  let rec loop lines =
    try let l = input_line c in
        loop (l::lines)
    with End_of_file -> lines in
  String.concat "\n" (Safelist.rev (loop []))

let diffCmd =
  Prefs.createString "diff" "diff"
    "*command for showing differences between files"
    ("This preference can be used to control the name (and command-line "
     ^ "arguments) of the system "
     ^ "utility used to generate displays of file differences.  The default "
     ^ "is `\\verb|diff|'.  The diff program should expect two file names "
     ^ "as arguments")

let quotes s = "'" ^ Util.replacesubstring s "'" "'\''" ^ "'"

let rec diff root1 root2 path optFp1 optFp2 showDiff id =
  debug (fun () ->
    Util.msg
      "diff %s %s %s ...\n"
      (root2string root1) (root2string root2) (Path.toString path));
  let displayDiff fspath1 fspath2 =
    let cmd = (Prefs.read diffCmd)
                 ^ " " ^ (quotes (Fspath.toString fspath1))
                 ^ " " ^ (quotes (Fspath.toString fspath2)) in
    let c = Unix.open_process_in cmd in
    showDiff cmd (readChannelTillEof c);
    ignore(Unix.close_process_in c) in
  match root1,root2 with
    (Local,fspath1),(Local,fspath2) ->
      Util.convertUnixErrorsToTransient
        "diffing files"
        (fun () ->
           displayDiff
             (Fspath.concat fspath1 path) (Fspath.concat fspath2 path))
  | (Local,fspath1),(Remote host2,fspath2) ->
      Util.convertUnixErrorsToTransient
        "diffing files"
        (fun () ->
           let (workingDir, realPath) = Fspath.findWorkingDir fspath1 path in
           let tmppath = Path.addSuffixToFinalName realPath "#unisondiff-" in
           Lwt_unix.run
             (copyRegFile `Copy root2 path root1 workingDir tmppath realPath
                Props.fileSafe id optFp2);
           displayDiff
	     (Fspath.concat workingDir realPath)
             (Fspath.concat workingDir tmppath);
           Os.delete workingDir tmppath)
  | (Remote host1,fspath1),(Local,fspath2) ->
      Util.convertUnixErrorsToTransient
        "diffing files"
        (fun () ->
           let (workingDir, realPath) = Fspath.findWorkingDir fspath2 path in
           let tmppath = Path.addSuffixToFinalName realPath "#unisondiff-" in
           Lwt_unix.run
             (copyRegFile `Copy root1 path root2 workingDir tmppath realPath
                Props.fileSafe id optFp1);
           displayDiff
             (Fspath.concat workingDir tmppath)
             (Fspath.concat workingDir realPath);
           Os.delete workingDir tmppath)

  | (Remote host1,fspath1),(Remote host2,fspath2) ->
      showDiff "Diff Error"
        "Diff operation not available when both roots are remote"


(**********************************************************************)

(* Taken from ocamltk/jpf/fileselect.ml *)
let get_files_in_directory dir =
  let dirh = Fspath.opendir (Fspath.canonize (Some dir)) in
  let rec get_them () =
    try
      (******************************************************************)
      (* This let is needed to prevent an infinite loop/stack overflow. *)
      (* The order of evaluation of the arguments to an application is  *)
      (* unspecified in ocaml, and if we instead used                   *)
      (*   (Unix.readdir dirh)::(get_them ())                           *)
      (* then get_them can be called before readdir.                    *)
      (******************************************************************)
      let x = Unix.readdir dirh in
      x::(get_them ())
    with
      End_of_file -> Unix.closedir dirh; []
  in
  Sort.list (<) (get_them ())

(* Convert a shell-style regular expression, using the special characters,
   ?*[], to a caml-style regular expression. *)
let convert_regexp s =
  let s = Str.global_replace (Str.regexp "\\+") "\\+" s in
  let s = Str.global_replace (Str.regexp "\\^") "\\^" s in
  let s = Str.global_replace (Str.regexp "\\$") "\\$" s in
  let s = Str.global_replace (Str.regexp "\\.") "\\." s in
  let s = Str.global_replace (Str.regexp "\\?") "." s in
  let s = Str.global_replace (Str.regexp "\\*") ".*" s in
  s ^ "$"

let ls dir pattern =
  Util.convertUnixErrorsToTransient
    "listing files"
    (fun () ->
       let files = get_files_in_directory dir in
       let re = Str.regexp (convert_regexp pattern) in
       let rec filter l =
         match l with
           [] -> []
         | hd::tl ->
             if Str.string_match re hd 0 then hd::(filter tl)
             else filter tl
       in filter files)


(***********************************************************************
                  CALL OUT TO EXTERNAL MERGE PROGRAM
************************************************************************)

let merge =
  Prefs.createString "merge" ""
    "command for merging conflicting files"
    ("This preference can be used to run a merge program which will create " ^
     " a new version of the file with the last backup and the both replicas" ^
     ". This new version will be used for the synchronization.  See " ^
     "\sectionref{merge}{Merging Conflicting Versions} for further detail.")

let merge2 =
  Prefs.createString "merge2" ""
    "command for merging files (when no common version exists)"
    ("This preference can be used to run a merge program which will create " ^
     " a new version of the file with the last backup and the both replicas" ^
     ". This new version will be used for the synchronization.  See " ^
     "\sectionref{merge}{Merging Conflicting Versions} for further detail.")


let editor =
  Prefs.createString "editor" "emacs"
    "command for displaying the output of the merge program"
    ("This preference is used when unison wants to display the output of " ^
     "the merge program when its return value is not 0. User changes " ^
     "the file as he wants and then save it, unison will take this " ^
     "version for the synchronisation. By default the value is `emacs'.")

let createMergeCmd fsp1 fsp2 bc out =
  let f1 = Fspath.toString fsp1 in
  let f2 = Fspath.toString fsp2 in
  let raw2 = Prefs.read merge2 in
  let raw3 = if Prefs.read merge <> "" then Prefs.read merge else raw2 in
  let raw = match bc with
      None -> if raw2="" then raise
                  (Util.Transient "Preference 'merge2' must be set")
              else raw2
    | Some _ -> if raw3="" then raise
                  (Util.Transient "Preference 'merge' or 'merge2' must be set")
                else raw3 in
  let cooked = Util.replacesubstring raw    "CURRENT1" f1  in
  let cooked = Util.replacesubstring cooked "CURRENT2" f2  in
  let cooked = Util.replacesubstring cooked "NEW"      out in
  let cooked =
    match bc with
      None -> cooked
    | Some(s) -> Util.replacesubstring cooked "OLD"      (Fspath.toString s) in
  cooked

let mergeFct root1 root2 path displayError displayQuestion id ui1 ui2 backups =
  debug (fun () -> Util.msg
    "mergeFct\n  %s\n  %s\n  %s\n"
      (root2string root1) (root2string root2) (Path.toString path));
  let s =
    (match Path.finalName path with
       None -> "#unisonmerged.tmp"
     | Some n -> Name.toString n) in
  let pathTmp = Path.fromString ("#unisonmerged-" ^ s) in
  Os.delete Os.unisonDir pathTmp;
  let mergeCopy rootMerge pathMerge rootTo pathTo uiTo id trans_id backups =
    setupTargetPaths rootTo pathTo
      >>= (fun (workingDir, realPathTo, tempPathTo) ->
    Update.updateArchive rootTo pathTo uiTo false trans_id
      >>= (fun archTo ->
    let props =
      match archTo with
          Update.ArchiveFile (d, _, _) -> d
        | _ -> assert false in
    Update.makeMirrorFile rootTo realPathTo realPathTo >>= (fun () ->
    copyRegFile (`Update (Props.length props))
      rootMerge pathMerge
      rootTo workingDir tempPathTo realPathTo
      (Props.setLength props Uutil.dummyfilesize) id None
        (* Possible improvement: Usually the result of merging will be a
           new file.  But sometimes its content could be the same as an
           existing file.  So I might want to optimized here by searching
           for a file with matching fingerprint. *)
        >>= (fun () ->
    Update.makeMirrorFile rootTo tempPathTo realPathTo >>= (fun () ->
    rename backups rootTo pathTo workingDir tempPathTo realPathTo uiTo)))))
  in
  let mergeFile fspath1 fspath2 =
    let out = Fspath.concatToString Os.unisonDir pathTmp in
    let backupFspath =
      match ui1 with
        Common.Updates (_, Common.Previous (`FILE, _, dig)) ->
          let backupFspath = Update.findMirror path in
          begin match backupFspath with
            None ->
              None
          | Some fspath ->
              let dig' = try Some (Os.fingerprint fspath Path.empty)
                         with Util.Transient _ -> None in
              if
                Some dig = dig'
                  ||
                displayQuestion
                  ("I have an old copy of this file, but it is not "
                  ^ "up to date.  Do you want to use it anyway? ")
              then
                backupFspath
              else
                None
          end
      | _ ->
          None in
    let cmd = createMergeCmd fspath1 fspath2 backupFspath out in
    debug (fun () -> Util.msg "merge : cmd made by merge :\n   %s\n" cmd);
    let returnValue = Lwt_unix.run (Lwt_unix.system cmd) in
    if Sys.file_exists out then begin
      if returnValue <> Unix.WEXITED 0 then
        let answer = displayQuestion
             ("Merge program exited with non-zero status.\n" ^
             "Do you want to open its output in an editor?") in
        if not answer then raise (Util.Transient "Aborted");
        let emacsCmd = (Prefs.read editor) ^ " " ^ (quotes out) in
        debug (fun () -> Util.msg "emacs cmd: %s\n" emacsCmd);
        let status = Lwt_unix.run (Lwt_unix.system emacsCmd) in
        if status <> Unix.WEXITED 0 then
          raise (Util.Transient "Editor exited with non-zero status: aborted")
        else
          let validation = displayQuestion
            "Use editor output as new file contents in both replicas?" in
          if not validation then raise (Util.Transient "Aborted")
    end else begin
      raise (Util.Transient "Merge program did not create an output file");
    end
  in
  Util.convertUnixErrorsToTransient
    "merging files"
    (fun () ->
       begin match root1,root2 with
         (Local,fspath1),(Local,fspath2) ->
           mergeFile (Fspath.concat fspath1 path) (Fspath.concat fspath2 path);
       | (Local,fspath1),(Remote host2,fspath2) ->
           let (workingDir, realPath) =
             Fspath.findWorkingDir fspath1 path in
           let tmppath =
             Path.addPrefixToFinalName realPath "#unisonclash-" in
           Util.finalize
             (fun () ->
               Lwt_unix.run
                 (copyRegFile `Copy root2 path
                    root1 workingDir tmppath realPath Props.fileSafe id
                    (uiFingerprint ui2));
	       mergeFile (Fspath.concat fspath1 path)
                 (Fspath.concat workingDir tmppath))
             (fun () ->
               Util.ignoreTransientErrors
                 (fun () -> Os.delete workingDir tmppath))
       | (Remote host1,fspath1),(Local,fspath2) ->
           let (workingDir, realPath) =
             Fspath.findWorkingDir fspath2 path in
           let tmppath = Path.addPrefixToFinalName realPath "#unisonclash-" in
           Util.finalize
             (fun () ->
               Lwt_unix.run
                 (copyRegFile `Copy root1 path
                    root2 workingDir tmppath realPath Props.fileSafe id
                    (uiFingerprint ui1));
	       mergeFile (Fspath.concat fspath2 path)
                 (Fspath.concat workingDir tmppath))
	     (fun () ->
               Util.ignoreTransientErrors
                 (fun () -> Os.delete workingDir tmppath))
       | (Remote host1,fspath1),(Remote host2,fspath2) ->
           assert false
       end;
(* FIX:
   This part is dangerous
   - We do not make sure that the new version was correctly copied on
     both sides (we should compute a fingerprint)
   - If there is an error during the transfer, we may remain in an
     inconsistent state
*)
       Lwt_unix.run
         (Update.transaction (fun trans_id ->
            mergeCopy (Local, Os.unisonDir) pathTmp
              root1 path ui1 id trans_id backups >>= (fun () ->
            mergeCopy (Local, Os.unisonDir) pathTmp
              root2 path ui2 id trans_id backups >>= (fun () ->
            Os.delete Os.unisonDir pathTmp;
            Lwt.return ())))))
