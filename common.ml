(* $I1: Unison file synchronizer: src/common.ml $ *)
(* $I2: Last modified by zheyang on Tue, 09 Apr 2002 17:08:59 -0400 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

type hostname = string

(* Canonized roots                                                           *)
type host =
    Local
  | Remote of hostname

type root = host * Fspath.t

type 'a oneperpath = ONEPERPATH of 'a list

(* ------------------------------------------------------------------------- *)
(*                       Printing                                            *)
(* ------------------------------------------------------------------------- *)

let root2hostname root =
  match root with
    (Local, _) -> "local"
  | (Remote host, _) -> host

let root2string root =
  match root with
    (Local, fspath) -> Fspath.toString fspath
  | (Remote host, fspath) -> "//"^host^"/"^(Fspath.toString fspath)

(* ------------------------------------------------------------------------- *)
(*                      Root comparison                                      *)
(* ------------------------------------------------------------------------- *)

let compareRoots x y =
  match x,y with
    (Local,fspath1), (Local,fspath2) ->
      (* FIX: This is a path comparison, should it take case
         sensitivity into account ? *)
      compare (Fspath.toString fspath1) (Fspath.toString fspath2)
  | (Local,_), (Remote _,_) -> -1
  | (Remote _,_), (Local,_) -> 1
  | (Remote host1, fspath1), (Remote host2, fspath2) ->
      let result =
        (* FIX: Should this ALWAYS be a case insensitive compare? *)
        compare host1 host2 in
      if result = 0 then
        (* FIX: This is a path comparison, should it take case
           sensitivity into account ? *)
        compare (Fspath.toString fspath1) (Fspath.toString fspath2)
      else
        result

let sortRoots rootList = List.sort compareRoots rootList

(* ---------------------------------------------------------------------- *)

type prevState = Previous of Fileinfo.typ * Props.t * Os.fingerprint | New

type contentschange =
    ContentsSame | ContentsUpdated of Os.fingerprint * Fileinfo.stamp
type permchange     = PropsSame    | PropsUpdated

type updateItem =
    NoUpdates                         (* Path not changed *)
  | Updates                           (* Path changed in this replica *)
      of updateContent                (*   - new state *)
       * prevState                    (*   - summary of old state *)
  | Error                             (* Error while detecting updates *)
      of string                       (*   - description of error *)

and updateContent =
    Absent                            (* Path refers to nothing *)
  | File                              (* Path refers to an ordinary file *)
      of Props.t                      (*   - summary of current state *)
       * contentschange               (*   - hint to transport agent *)
  | Dir                               (* Path refers to a directory *)
      of Props.t                      (*   - summary of current state *)
       * (Name.t * updateItem) list   (*   - children;
                                             MUST KEEP SORTED for recon *)
       * permchange                   (*   - did permissions change? *)
  | Symlink                           (* Path refers to a symbolic link *)
      of string                       (*   - link text *)

(* ------------------------------------------------------------------------- *)

type status =
  [ `Deleted
  | `Modified
  | `PropsChanged
  | `Created
  | `Unchanged ]

type replicaContent = Fileinfo.typ * status * Props.t * updateItem

type direction =
    Conflict
  | Replica1ToReplica2
  | Replica2ToReplica1

let direction2string = function
    Conflict -> "conflict"
  | Replica1ToReplica2 -> "replica1 to replica2"
  | Replica2ToReplica1 -> "replica2 to replica1"

type replicas =
    Problem of string    (* There was a problem during update detection *)
  | Different            (* Replicas differ *)
    of replicaContent    (*   - content of first replica *)
     * replicaContent    (*   - content of second replica *)
     * direction ref     (*   - action to take *)
     * direction         (*   - default action to take *)

type reconItem =
    {path : Path.t;
     replicas : replicas}

let ucLength = function
    File(desc,_)  -> Props.length desc
  | Dir(desc,_,_) -> Props.length desc
  | _             -> Uutil.zerofilesize

let uiLength = function
    Updates(uc,_) -> ucLength uc
  | _             -> Uutil.zerofilesize

let riAction (_, s, _, _) (_, s', _, _) =
  match s, s' with
    `Deleted, _ ->
      `Delete
  | (`Unchanged | `PropsChanged), (`Unchanged | `PropsChanged) ->
      `SetProps
  | _ ->
      `Copy

let rcLength ((_, _, p, _) as rc) rc' =
  if riAction rc rc' = `SetProps then
    Uutil.Filesize.zero
  else
    Uutil.extendfilesize (Props.length p)

let riLength ri =
  match ri.replicas with
    Different(rc1, rc2, dir, _) ->
      begin match !dir with
        Replica1ToReplica2 -> rcLength rc1 rc2
      | Replica2ToReplica1 -> rcLength rc2 rc1
      | Conflict           -> Uutil.Filesize.zero
      end
  | _ ->
      Uutil.Filesize.zero

let uiFingerprint = function
    Updates(File(_, ContentsUpdated(fp, _)), _) -> Some fp
  | _ -> None

let problematic ri =
  match ri.replicas with
    Problem _ -> true
  | Different (_,_,d,_) -> (!d = Conflict)

let isDeletion ri =
  match ri.replicas with
    Different(rc1, rc2, rDir, _) ->
      (match (!rDir, rc1, rc2) with
        (Replica1ToReplica2, (`ABSENT, _, _, _), _) -> true
      | (Replica2ToReplica1, _, (`ABSENT, _, _, _)) -> true
      | _ -> false)
  | _ -> false
