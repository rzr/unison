(* $I1: Unison file synchronizer: src/uicommon.ml $ *)
(* $I2: Last modified by zheyang on Tue, 09 Apr 2002 17:08:59 -0400 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

open Common
open Lwt

(**********************************************************************
                             UI selection
 **********************************************************************)

type interface =
   Text
 | Graphic

module type UI =
sig
 val start : interface -> unit
end


(**********************************************************************
                             Preferences
 **********************************************************************)

let auto =
  Prefs.createBool "auto" false "automatically accept default actions"
    ("When set to {\\tt true}, this flag causes the user "
     ^ "interface to skip asking for confirmations except for "
     ^ "non-conflicting changes.  (More precisely, when the user interface "
     ^ "is done setting the propagation direction for one entry and is about "
     ^ "to move to the next, it will skip over all non-conflicting entries "
     ^ "and go directly to the next conflict.)" )

let batch =
  Prefs.createBool "batch" false "batch mode: ask no questions at all"
    ("When this is set to {\\tt true}, the user "
     ^ "interface will ask no questions at all.  Non-conflicting changes "
     ^ "will be propagated; conflicts will be skipped.")

(* This has to be here rather than in uigtk.ml, because it is part of what
   gets sent to the server at startup *)
let mainWindowHeight =
  Prefs.createInt "height" 20
    "height (in lines) of main window in graphical interface"
    ("Used to set the height (in lines) of the main window in the graphical "
     ^ "user interface.")

let reuseToplevelWindows =
  Prefs.createBool "reusewindows" false
    "*reuse top-level windows instead of making new ones" ""
(* Not sure if this should actually be made available to users...
    ("When true, causes the graphical interface to re-use top-level windows "
     ^ "(e.g., the small window that says ``Connecting...'') rather than "
     ^ "destroying them and creating fresh ones.  ") 
*)
(* For convenience: *)
let _ = Prefs.alias "reusewindows" "rw"


let expert =
  Prefs.createBool "expert" false
    "*Enable some developers-only functionality in the UI" ""

let profileLabel =
  Prefs.createString "label" ""
    "provide a descriptive string label for this profile"
    ("Used in a profile to provide a descriptive string documenting its "
     ^ "settings.  (This is useful for users that switch between several "
     ^ "profiles, especially using the `fast switch' feature of the "
     ^ "graphical user interface.)")

let profileKey =
  Prefs.createString "key" ""
    "define a keyboard shortcut for this profile"
    ("Used in a profile to define a numeric key (0-9) that can be used in "
     ^ "the graphical user interface to switch immediately to this profile.")
(* This preference is not actually referred to in the code anywhere, since
   the keyboard shortcuts are constructed by a separate scan of the preference
   file in uigtk.ml, but it must be present to prevent the preferences module
   from complaining about 'key = n' lines in profiles. *)

let contactquietly =
  Prefs.createBool "contactquietly" false
    "Suppress the 'contacting server' message during startup"
    ("If this flag is set, Unison will skip displaying the "
     ^ "`Contacting server' window (which some users find annoying) "
     ^ "during startup.")

(**********************************************************************
                         Formatting functions
 **********************************************************************)

(* When no archives were found, we omit 'new' in status descriptions, since
   *all* files would be marked new and this won't make sense to the user. *)
let choose s1 s2 = if !Update.foundArchives then s1 else s2

let replicaContent2string rc sep = 
  let (typ, status, desc, _) = rc in
  let d s = s ^ sep ^ Props.toString desc in
  match typ, status with
    `ABSENT, `Unchanged ->
      "absent"
  | _, `Unchanged ->
      "unchanged "
     ^(Util.truncateString (Fileinfo.type2string typ) 7)
     ^ sep
     ^(Props.toString desc)
  | `ABSENT, `Deleted -> "deleted"
  | `FILE, `Created ->
     d (choose "new file         " "file             ")
  | `FILE, `Modified ->
     d "changed file     " 
  | `FILE, `PropsChanged ->
     d "changed props    " 
  | `SYMLINK, `Created ->
     d (choose "new symlink      " "symlink          ")
  | `SYMLINK, `Modified ->
     d "changed symlink  " 
  | `DIRECTORY, `Created ->
     d (choose "new dir          " "dir              ")
  | `DIRECTORY, `Modified ->
     d "changed dir      "
  | `DIRECTORY, `PropsChanged ->
     d "dir props changed" 
  (* Some cases that can't happen... *)
  | `ABSENT, (`Created | `Modified | `PropsChanged)
  | `SYMLINK, `PropsChanged
  | (`FILE|`SYMLINK|`DIRECTORY), `Deleted ->
      assert false
  
let replicaContent2shortString rc =
  let (typ, status, _, _) = rc in
  match typ, status with
    _, `Unchanged             -> "        "
  | `ABSENT, `Deleted         -> "deleted "
  | `FILE, `Created           -> choose "new file" "file    "
  | `FILE, `Modified          -> "changed "
  | `FILE, `PropsChanged      -> "props   "
  | `SYMLINK, `Created        -> choose "new link" "link    "
  | `SYMLINK, `Modified       -> "chgd lnk"
  | `DIRECTORY, `Created      -> choose "new dir " "dir     "
  | `DIRECTORY, `Modified     -> "chgd dir"
  | `DIRECTORY, `PropsChanged -> "props   "
  (* Cases that can't happen... *)
  | `ABSENT, (`Created | `Modified | `PropsChanged)
  | `SYMLINK, `PropsChanged
  | (`FILE|`SYMLINK|`DIRECTORY), `Deleted
                              -> assert false

let roots2niceStrings length = function
   (Local,fspath1), (Local,fspath2) ->
    let name1, name2 = Fspath.differentSuffix fspath1 fspath2 in
    (Util.truncateString name1 length, Util.truncateString name2 length)
 | (Local,fspath1), (Remote host, fspath2) ->
    (Util.truncateString "local" length, Util.truncateString host length)
 | (Remote host, fspath1), (Local,fspath2) ->
    (Util.truncateString host length, Util.truncateString "local" length)
 | _ -> assert false  (* BOGUS? *)

let details2string theRi sep =
  match theRi.replicas with
    Problem s ->
      Printf.sprintf "Problem occured while scanning filesystems:\n%s\n" s
  | Different(rc1, rc2, _, _) ->
      let root1str, root2str =
        roots2niceStrings 12 (Globals.roots()) in
      Printf.sprintf "%s : %s\n%s : %s"
        root1str (replicaContent2string rc1 sep)
        root2str (replicaContent2string rc2 sep)

let displayPath previousPath path =
  let previousNames = Path.toNames previousPath in
  let names = Path.toNames path in
  if names = [] then "/" else
  (* Strip the greatest common prefix of previousNames and names
     from names.  level is the number of names in the greatest
     common prefix. *)
  let rec loop level names1 names2 =
    match (names1,names2) with
      (hd1::tl1,hd2::tl2) ->
        if Name.compare hd1 hd2 = 0
        then loop (level+1) tl1 tl2
        else (level,names2)
    | _ -> (level,names2) in
  let (level,suffixNames) = loop 0 previousNames names in
  let suffixPath =
    Safelist.fold_left Path.child Path.empty suffixNames in
  let spaces = String.make (level*3) ' ' in 
  spaces ^ (Path.toString suffixPath)

let roots2string () =
  let replica1, replica2 = roots2niceStrings 12 (Globals.roots()) in
  (Printf.sprintf "%s   %s       " replica1 replica2) 

let direction2niceString = function
    Conflict           -> "<-?->"
  | Replica1ToReplica2 -> "---->"
  | Replica2ToReplica1 -> "<----"

let reconItem2string oldPath theRI status =
  let theLine =
    match theRI.replicas with
      Problem s ->
        "         error           " ^ status
    | Different(rc1, rc2, dir, _) ->
        let signs =
          Printf.sprintf "%s %s %s"
            (replicaContent2shortString rc1)
            (direction2niceString (!dir))
            (replicaContent2shortString rc2) in
        Printf.sprintf "%s  %s" signs status in
  Printf.sprintf "%s %s" theLine (displayPath oldPath theRI.path)

let exn2string = function
    Sys.Break      -> "Terminated!"
  | Util.Fatal(s)  -> Printf.sprintf "Fatal error: %s" s
  | Util.Transient(s) -> Printf.sprintf "Error: %s" s
  | other -> Printf.sprintf "Uncaught exception %s" (Printexc.to_string other)

(* precondition: uc = File (Updates(_, ..) on both sides *)
let showDiffs ri printer errprinter id =
  let p = ri.path in
  match ri.replicas with
    Problem _ ->
      errprinter
        "Can't diff files: there was a problem during update detection"
  | Different((`FILE, _, _, ui1), (`FILE, _, _, ui2), _, _) ->
      let (root1,root2) = Globals.roots() in
      Files.diff root1 root2 p (uiFingerprint ui1) (uiFingerprint ui2) printer id
  | Different _ ->
      errprinter "Can't diff: path doesn't refer to a file in both replicas"
	
	
exception Synch_props of Common.reconItem

let applyMerge ri printError printQuestion id backups =  (*+++*)
  match ri.replicas with
    Problem _ ->
      raise (Util.Transient "Can't merge these files: there was a problem during update detection")
  | Different((`FILE, _, _, ui1), (`FILE, _, _, ui2), _, _) ->
      let (root1,root2) = Globals.roots() in
      Files.mergeFct
        root1 root2 ri.path printError printQuestion id ui1 ui2 backups;
      Lwt_unix.run
        (Update.findOnRoot root1 [ri.path] >>= (fun newUi1 ->
         Update.findOnRoot root2 [ri.path] >>= (fun newUi2 ->
         let (newRi, _) =
           Recon.reconcileTwo ri.path (List.hd newUi1) (List.hd newUi2) in
         return
           (match newRi with 
              [] -> ()
            | rihd::tl -> raise (Synch_props rihd)))))
  | Different _ ->
      raise (Util.Transient "Can't merge: path doesn't refer to a file in both replicas")

(**********************************************************************
                  Useful patterns for ignoring paths
 **********************************************************************)

let quote s =
  let len = String.length s in
  let buf = String.create (2 * len) in
  let pos = ref 0 in
  for i = 0 to len - 1 do
    match s.[i] with
      '*' | '?' | '[' | '{' as c ->
        buf.[!pos] <- '\\'; buf.[!pos + 1] <- c; pos := !pos + 2
    | c ->
        buf.[!pos] <- c; pos := !pos + 1
  done;
  String.sub buf 0 !pos

let ignorePath path = "Path " ^ (quote (Path.toString path))

let ignoreName path =
  match Path.finalName path with
    Some name -> "Name " ^ (quote (Name.toString name))
  | None      -> assert false

let ignoreExt path =
  match Path.finalName path with
    Some name ->
      let str = Name.toString name in
      (try
        let pos = String.rindex str '.' + 1 in
        let ext = String.sub str pos (String.length str - pos) in
        "Name *." ^ (quote ext)
      with Not_found -> (* str does not contain '.' *)
        "Name "^(quote str))
  | None      -> assert false

let addIgnorePattern theRegExp =
  if theRegExp = "Path " then
    raise (Util.Transient "Can't ignore the root path!");
  let theRegExps = theRegExp::(Pred.extern Globals.ignore) in
  Pred.intern Globals.ignore theRegExps;
  let r = Prefs.add "ignore" theRegExp in
  Trace.status r;
  (* Make sure the server has the same ignored paths (in case, for
     example, we do a "rescan") *)
  Lwt_unix.run (Globals.propagatePrefs ())

(**********************************************************************
                   Profile and command-line parsing
 **********************************************************************)

let coreUsageMsg =
   "Usage: " ^ Uutil.myName
 ^ " [options]\n"
 ^ "    or " ^ Uutil.myName
 ^ " root1 root2 [options]\n"
 ^ "    or " ^ Uutil.myName
 ^ " profilename [options]\n"

let shortUsageMsg =
     coreUsageMsg ^ "\n"
   ^ "For a list of options, type \"" ^ Uutil.myName ^ " -help\".\n"
   ^ "For a tutorial on basic usage, type \"" ^ Uutil.myName
   ^ " -doc tutorial\".\n"
   ^ "For other documentation, type \"" ^ Uutil.myName ^ " -doc topics\".\n"

let usageMsg = coreUsageMsg ^ "\nOptions: "

(* ---- *)

(* Determine the case sensitivity of a root (does filename FOO==foo?) *)
let architecture =
  Remote.registerRootCmd
    "caseInSensitive"
    (fun (_,()) -> return Util.osType)

(* During startup the client determines the case sensitivity of each root.
   If any root is case insensitive, all roots must know this -- it's
   propagated in a pref. *)
let checkCaseSensitivity () =
  Globals.allRootsMap (fun r -> architecture r ()) >>= (fun archs ->
  let someWindows =
    Safelist.exists (fun x -> x = `Win32) archs
  in
  Case.init someWindows;
  Props.init someWindows;
  return ())

(* ---- *)

let promptForRoots getFirstRoot getSecondRoot =    
  (* Ask the user for the roots *)
  let r1 = match getFirstRoot() with None -> exit 0 | Some r -> r in
  let r2 = match getSecondRoot() with None -> exit 0 | Some r -> r in
  (* Remember them for this run, ordering them so that the first
     will come out on the left in the UI *)
  Globals.setRawRoots [r2;r1];
  (* Save them in the current profile *)
  ignore (Prefs.add "root" r1);
  ignore (Prefs.add "root" r2)

(* ---- *)

(* The first time we load preferences, we also read the command line
   arguments; if we re-load prefs (because the user selected a new profile)
   we ignore the command line *)
let firstTime = ref(true)

let initPrefs ~profileName ~displayWaitMessage ~getFirstRoot ~getSecondRoot =
  (* Restore prefs to their default values, if necessary *)
  if not !firstTime then Prefs.resetToDefaults();

  (* Tell the preferences module the name of the profile *)
  Prefs.profileName := Some(profileName);
  
  (* If the profile does not exist, create an empty one (this should only
     happen if the profile is 'default', since otherwise we will already
     have checked that the named one exists). *)
   if not(Sys.file_exists (Prefs.profilePathname profileName)) then
     Prefs.addComment "Unison preferences file";

  (* Load the profile *)
  (Trace.debug "" (fun() -> Util.msg "about to load prefs");
  Prefs.loadTheFile());

  (* Parse the command line.  This will temporarily override
     settings from the profile. *)
  if !firstTime then begin
    Trace.debug "" (fun() -> Util.msg "about to parse command line");
    Prefs.parseCmdLine usageMsg;
  end;

  (* Print the preference settings *)
  Trace.debug "" (fun() -> Prefs.dumpPrefsToStderr() );

  (* If no roots are given either on the command line or in the profile,
     ask the user *)
  if Globals.rawRoots() = [] then begin
    promptForRoots getFirstRoot getSecondRoot;
  end;

  (* The following step contacts the server, so warn the user it could take
     some time *)
  if !firstTime && (not (Prefs.read contactquietly)) then 
    displayWaitMessage();

  (* Canonize the names of the roots, sort them (with local roots first),
     and install them in Globals. *)
  Lwt_unix.run (Globals.installRoots ());

  (* If both roots are local, disable the xferhint table to save time *)
  begin match Globals.roots() with
    ((Local,_),(Local,_)) -> Prefs.set Xferhint.xferbycopying false
  | _ -> ()
  end;

  (* FIX: This should be before Globals.installRoots *)
  (* Check to be sure that there is at most one remote root *)
  let numRemote =
    Safelist.fold_left
      (fun n (w,_) ->
        match w with Local -> n | Remote _ -> n+1)
      0
      (Globals.rootsList()) in
  if numRemote > 1 then
    raise(Util.Fatal "cannot synchronize more than one remote root");

  (* If no paths were specified, then synchronize the whole replicas *)
  if Prefs.read Globals.paths = [] then Prefs.set Globals.paths [Path.empty];

  (* Expand any "wildcard" paths [with final component *] *)
  Globals.expandWildcardPaths();

  Update.storeRootsName ();

  Trace.debug ""
    (fun() ->
       Printf.eprintf "Roots: \n";
       Safelist.iter (fun clr -> Printf.eprintf "        %s\n" clr)
         (Globals.rawRoots ());
       Printf.eprintf "  i.e. \n";
       Safelist.iter (fun clr -> Printf.eprintf "        %s\n"
                    (Uri.clroot2string (Uri.parseRoot clr)))
         (Globals.rawRoots ());
       Printf.eprintf "  i.e. (in canonical order)\n";
       Safelist.iter (fun r -> 
         Printf.eprintf "       %s\n" (root2string r))
         (Globals.rootsInCanonicalOrder());
       Printf.eprintf "\n"
    );

  Recon.checkThatPreferredRootIsValid();

  Lwt_unix.run
    (checkCaseSensitivity () >>=
     Globals.propagatePrefs);

  firstTime := false

(**********************************************************************
                       Common startup sequence
 **********************************************************************)

let anonymousArgs =
  Prefs.createStringList "rest"
    "*roots or profile name" ""

let testServer =
  Prefs.createBool "testserver" false
    "exit immediately after the connection to the server"
    ("Setting this flag on the command line causes Unison to attempt to "
     ^ "connect to the remote server and, if successful, print a message "
     ^ "and immediately exit.  Useful for debugging installation problems. "
     ^ "Should not be set in preference files.")

(* For backward compatibility *)
let _ = Prefs.alias "testserver" "testServer"

(* ---- *)

let uiInit
    ~(reportError : string -> unit)
    ~(tryAgainOrQuit : string -> bool)
    ~(displayWaitMessage : unit -> unit)
    ~(getProfile : unit -> string option)
    ~(getFirstRoot : unit -> string option)
    ~(getSecondRoot : unit -> string option) =

  (* Make sure we have a directory for archives and profiles *)
  Os.createUnisonDir();
 
  (* Extract any command line profile or roots *)
  let clprofile = ref None in
  begin
    try
      let args = Prefs.scanCmdLine usageMsg in
      match Util.StringMap.find "rest" args with
        [] -> ()
      | [profile] -> clprofile := Some profile
      | [root1;root2] -> Globals.setRawRoots [root1;root2]
      | [root1;root2;profile] ->
          Globals.setRawRoots [root1;root2];
          clprofile := Some profile
      | _ ->
          (reportError(Printf.sprintf
             "%s was invoked incorrectly (too many roots)" Uutil.myName);
           exit 1)
    with Not_found -> ()
  end;

  (* Print header for debugging output *)
  Trace.debug "" (fun() ->
    Printf.eprintf "%s, version %s\n\n" Uutil.myName Uutil.myVersion);
  Trace.debug "" (fun() -> Util.msg "initializing UI");

  Trace.debug "" (fun () ->
    (match !clprofile with
      None -> Util.msg "No profile given on command line"
    | Some s -> Printf.eprintf "Profile '%s' given on command line" s);
    (match Globals.rawRoots() with
      [] -> Util.msg "No roots given on command line"
    | [root1;root2] ->
        Printf.eprintf "Roots '%s' and '%s' given on command line"
          root1 root2
    | _ -> assert false));

  let profileName =
    begin match !clprofile with
      None ->
        let dirString = Fspath.toString Os.unisonDir in
        let profiles_exist = (Files.ls dirString "*.prf")<>[] in
        let clroots_given = (Globals.rawRoots() <> []) in
        let n =
          if profiles_exist && not(clroots_given) then begin
            (* Unison has been used before: at least one profile exists.
               Ask the user to choose a profile or create a new one. *)
            clprofile := getProfile();
            match !clprofile with
              None -> exit 0 (* None means the user wants to quit *)
            | Some x -> x 
          end else begin
            (* First time use, OR roots given on command line.
               In either case, the profile should be the default. *)
            clprofile := Some "default";
            "default"
          end in
        n
    | Some n ->
        let f = Prefs.profilePathname n in
        if not(Sys.file_exists f)
        then (reportError (Printf.sprintf "Profile %s does not exist" f);
              exit 1);
        n
    end in

  (* Load the profile and command-line arguments *)
  initPrefs profileName displayWaitMessage getFirstRoot getSecondRoot;

  (* Turn on GC messages, if the '-debug gc' flag was provided *)
  if Trace.enabled "gc" then Gc.set {(Gc.get ()) with Gc.verbose = 0x3F};

  if Prefs.read testServer then exit 0;
  (* BCPFIX: Should/can this be done earlier?? *)
  Files.processCommitLogs()

(* Exit codes *)
let perfectExit = 0   (* when everything's okay *)
let skippyExit  = 1   (* when some items were skipped, but no failure occurred *)
let failedExit  = 2   (* when there's some non-fatal failure *)
let fatalExit   = 3   (* when fatal failure occurred *)
let exitCode = function
    (false, false) -> 0
  | (true, false)  -> 1
  | _              -> 2
(* (anySkipped?, anyFailure?) -> exit code *)
