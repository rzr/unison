(* $I1: Unison file synchronizer: src/xferhint.ml $ *)
(* $I2: Last modified by zheyang on Fri, 22 Mar 2002 14:15:11 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

let debug = Trace.debug "xferhint"

let xferbycopying = 
  Prefs.createBool "xferbycopying" true
    "optimize transfers using local copies, if possible"
    ("When this preference is set, Unison will try to avoid transferring "
   ^ "file contents across the network by recognizing when a file with the "
   ^ "required contents already exists in the target replica.  This usually "
   ^ "allows file moves to be propagated very quickly.  The default value is"
   ^ "\texttt{true}.  ")

module PathMap = Map.Make(
  struct type t = Fspath.t * Path.t 
  let compare = compare end)
module FPMap = Map.Make(
  struct type t = Os.fingerprint
    let compare = compare
  end)
    
(* map(path, fingerprint) *)
let path2fingerprintMap: Os.fingerprint PathMap.t ref =  ref PathMap.empty
(* map(fingerprint, path) *)
let fingerprint2pathMap: (Fspath.t * Path.t) FPMap.t ref = ref FPMap.empty

(*  Now we don't clear it out anymore
let initLocal () = 
  debug (fun () -> Util.msg "initLocal\n");
  path2fingerprintMap := PathMap.empty;
  fingerprint2pathMap := FPMap.empty
*)

let lookup (fp: Os.fingerprint)
    : (Fspath.t * Path.t) option = 
  if (Prefs.read xferbycopying) then begin
    debug (fun () -> Util.msg "lookup: fp = %s\n" 
	(Os.fingerprint2string fp));
    try Some (FPMap.find fp !fingerprint2pathMap)
    with Not_found -> None
  end else
    raise (Util.Fatal ("Internal error: lookup when disabled"))

let insertEntry ((fspath, path) as p) fp =
  (* take care to remove the previous corresponding items for path and fp,
     for the 1-1-ness *)
  if (Prefs.read xferbycopying) then begin
    debug (fun () -> Util.msg "insertEntry: fspath=%s, path=%s, fp=%s\n"
	(Fspath.toString fspath)
	(Path.toString path) (Os.fingerprint2string fp));
    (try 
      path2fingerprintMap := PathMap.remove (FPMap.find fp !fingerprint2pathMap) !path2fingerprintMap;
      fingerprint2pathMap := FPMap.remove (PathMap.find p !path2fingerprintMap) !fingerprint2pathMap
    with Not_found -> ());
    path2fingerprintMap := PathMap.add p fp (!path2fingerprintMap);
    fingerprint2pathMap := FPMap.add fp p (!fingerprint2pathMap)
  end else ()

let deleteEntry ((fspath, path) as p) =
  if (Prefs.read xferbycopying) then begin
    debug (fun () -> Util.msg "deleteEntry: fspath=%s, path=%s\n"
	(Fspath.toString fspath) (Path.toString path));
    try 
      let fp = PathMap.find p (!path2fingerprintMap) in
      path2fingerprintMap := PathMap.remove p !path2fingerprintMap;
      fingerprint2pathMap := FPMap.remove fp !fingerprint2pathMap
    with Not_found -> ()
  end else ()

let renameEntry
    ((fspathOrig, pathOrig) as pOrig) 
    ((fspathNew, pathNew) as pNew)
    = 
  if (Prefs.read xferbycopying) then begin
    debug (fun () -> Util.msg "renameEntry: fsOrig=%s, pOrig=%s, fsNew=%s, pNew=%s\n"
	(Fspath.toString fspathOrig) (Path.toString pathOrig) 
	(Fspath.toString fspathNew) (Path.toString pathNew));
    try
      let fp = PathMap.find pOrig (!path2fingerprintMap) in
      fingerprint2pathMap := FPMap.add fp pNew !fingerprint2pathMap;
      path2fingerprintMap := 
	PathMap.add pNew fp (PathMap.remove pOrig !path2fingerprintMap);
    with 
      Not_found -> ()
  end else ()
