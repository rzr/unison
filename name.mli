(* $I1: Unison file synchronizer: src/name.mli $ *)
(* $I2: Last modified by zheyang on Wed, 12 Dec 2001 02:26:21 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

type t

val fromString : string -> t
val toString : t -> string

val compare : t -> t -> int
val eq : t -> t -> bool
val hash : t -> int

module Set : Set.S with type elt = t
