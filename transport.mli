(* $I1: Unison file synchronizer: src/transport.mli $ *)
(* $I2: Last modified by vouillon on Mon, 25 Mar 2002 12:08:56 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* Executes the actions implied by the reconItem list.                       *)
val transportItem :
     Common.reconItem           (* Updates that need to be performed *)
  -> Uutil.File.t               (* id for progress reports *)
  -> unit Lwt.t

(* Option that controls whether backup files are kept                        *)
val backups : bool Prefs.t

(* Print a header to the log file                                            *)
val logStartTime : unit -> unit
val logEndTime   : unit -> unit
