(* $I1: Unison file synchronizer: src/props.mli $ *)
(* $I2: Last modified by bcpierce on Sun, 24 Mar 2002 11:24:03 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* File properties: time, permission, length, etc. *)

type t
val dummy : t
val hash : t -> int -> int
val similar : t -> t -> bool
val override : t -> t -> t
val strip : t -> t
val diff : t -> t -> t
val toString : t -> string
val syncedPartsToString : t -> string
val set : Fspath.t -> Path.t -> [`Set | `Update] -> t -> unit
val get : Unix.stats -> t
val init : bool -> unit

val same_time : t -> t -> bool
val length : t -> Uutil.filesize
val setLength : t -> Uutil.filesize -> t
val time : t -> float
val setTime : t -> float -> t
val perms : t -> int

val fileDefault : t
val fileSafe : t
val dirDefault : t

val syncModtimes : bool Prefs.t
