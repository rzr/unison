(* $I1: Unison file synchronizer: src/transport.ml $ *)
(* $I2: Last modified by vouillon on Mon, 25 Mar 2002 12:08:56 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

open Common
open Lwt

let debug = Trace.debug "transport"

(*****************************************************************************)
(*                             OPTIONS                                       *)
(*****************************************************************************)

let backups =
  Prefs.createBool "backups" false
    "keep backup copies of files (deprecated: use 'backup')"
    ("When this flag is {\\tt true}, "
     ^ "Unison will keep the old version of a file as a backup whenever "
     ^ "a change is propagated.  These backup files are left in the same "
     ^ "directory, with extension \\verb|.bak|.  This flag is probably "
     ^ "less useful for most users than the {\tt backup} flag.")

(*****************************************************************************)
(*                              MAIN FUNCTIONS                               *)
(*****************************************************************************)

let fileSize uiFrom uiTo =
  match uiFrom, uiTo with
    _, Updates (File (props, _), _) ->
      Props.length props
  | Updates (File _, Previous (_, props, _)), NoUpdates ->
      Props.length props
  | _ ->
      assert false

let actionReg = Lwt_util.make_region 50


(* Logging for a thread: write a message before and a message after the
   execution of the thread. *)
let logLwt (msgBegin: string)
    (t: unit -> 'a Lwt.t)
    (fMsgEnd: 'a -> string)
    : 'a Lwt.t =
  Trace.log msgBegin;
  Lwt.bind (t ()) (fun v ->
    Trace.log (fMsgEnd v);
    Lwt.return v)

(* [logLwtNumbered desc t] provides convenient logging for a thread given a
   description [desc] of the thread [t ()], generate pair of messages of the
   following form in the log:
 *
    [BGN] <desc>
     ...
    [END] <desc>
 **)
let rLogCounter = ref 0
let logLwtNumbered (lwtDescription: string) (lwtShortDescription: string)
    (t: unit -> 'a Lwt.t): 'a Lwt.t =
  let lwt_id = (rLogCounter := (!rLogCounter) + 1; !rLogCounter) in
  logLwt (Printf.sprintf "[BGN] %s\n" lwtDescription) t
    (fun _ ->
      Printf.sprintf "[END] %s\n" lwtShortDescription)

let doAction (fromRoot,toRoot) path fromContents toContents id =
  if not !Trace.sendLogMsgsToStderr then
    Trace.statusDetail (Path.toString path);
  Lwt_util.run_in_region actionReg 1 (fun () ->
    Remote.Thread.unwindProtect (fun () ->
      match fromContents, toContents with
        (`ABSENT, _, _, _), (_, _, _, uiTo) ->
             logLwtNumbered
               ("Deleting " ^ Path.toString path ^
                "\n  from "^ root2string toRoot)
               ("Deleting " ^ Path.toString path)
               (fun () -> Files.delete (Prefs.read backups)
                 fromRoot path toRoot path uiTo)
        (* No need to transfer the whole directory/file if there were only
           property modifications on one side.  (And actually, it would be
           incorrect to transfer a directory in this case.) *)
        | (_, (`Unchanged | `PropsChanged), fromProps, uiFrom),
          (_, (`Unchanged | `PropsChanged), toProps, uiTo) ->
            logLwtNumbered
              ("Copying properties for " ^ Path.toString path
               ^ "\n  from " ^ root2string fromRoot ^ "\n  to " ^
               root2string toRoot)
              ("Copying properties for " ^ Path.toString path)
              (fun () ->
                Files.setProp
                  fromRoot toRoot path fromProps toProps uiFrom uiTo)
        | (`FILE, _, _, uiFrom), (`FILE, _, _, uiTo) ->
            logLwtNumbered
              ("Updating file " ^ Path.toString path ^ "\n  from " ^
               root2string fromRoot ^ "\n  to " ^
               root2string toRoot)
              ("Updating file " ^ Path.toString path)
              (fun () ->
                Files.copy (Prefs.read backups)
                  (`Update (fileSize uiFrom uiTo))
                  fromRoot path uiFrom toRoot path uiTo id)
        | (_, _, _, uiFrom), (_, _, _, uiTo) ->
            logLwtNumbered
              ("Copying " ^ Path.toString path ^ "\n  from " ^
               root2string fromRoot ^ "\n  to " ^
               root2string toRoot)
              ("Copying " ^ Path.toString path)
              (fun () -> Files.copy (Prefs.read backups) `Copy
                  fromRoot path uiFrom toRoot path uiTo id))
      (fun e -> Trace.log
          (Printf.sprintf
             "Failed with exception %s\n" (Printexc.to_string e));
        return ()))

let propagate root1 root2 reconItem id =
  let path = reconItem.path in
  match reconItem.replicas with
    Problem p ->
      begin
        Trace.log (Printf.sprintf "[ERROR] Skipping %s\n  %s"
                     (Path.toString path) p);
        return ();
      end
  | Different(rc1,rc2,dir,_) ->
      match !dir with
        Conflict ->
          begin
            Trace.log (Printf.sprintf "[CONFLICT] Skipping %s\n"
                         (Path.toString path));
            return ()
          end
      | Replica1ToReplica2 ->
          doAction (root1, root2) path rc1 rc2 id
      | Replica2ToReplica1 ->
          doAction (root2, root1) path rc2 rc1 id

let transportItem reconItem id =
  let (root1,root2) = Globals.roots() in
  propagate root1 root2 reconItem id

(* ---------------------------------------------------------------------- *)

let months = ["Jan"; "Feb"; "Mar"; "Apr"; "May"; "Jun"; "Jul"; "Aug"; "Sep";
              "Oct"; "Nov"; "Dec"]

let logStartTime () =
  let tm = Unix.localtime (Unix.time()) in
  let m =
    Printf.sprintf
      "\n\n%s started propagating changes at %02d:%02d:%02d on %02d %s %04d\n"
      (String.uppercase Uutil.myName)
      tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec
      tm.Unix.tm_mday (Safelist.nth months tm.Unix.tm_mon)
      (tm.Unix.tm_year+1900) in
  Trace.log m

let logEndTime () =
  let tm = Unix.localtime (Unix.time()) in
  let m =
    Printf.sprintf
      "%s finished propagating changes at %02d:%02d:%02d on %02d %s %04d\n\n\n"
      (String.uppercase Uutil.myName)
      tm.Unix.tm_hour tm.Unix.tm_min tm.Unix.tm_sec
      tm.Unix.tm_mday (Safelist.nth months tm.Unix.tm_mon)
      (tm.Unix.tm_year+1900) in
  Trace.log m
