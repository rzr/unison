(* $I1: Unison file synchronizer: src/path.mli $ *)
(* $I2: Last modified by zheyang on Wed, 12 Dec 2001 02:26:21 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* Abstract type of relative pathnames *)
type t

val empty : t
val length : t -> int
val isEmpty : t -> bool

val child : t -> Name.t -> t
val parent : t -> t
val finalName : t -> Name.t option
val deconstruct : t -> (Name.t * t) option
val deconstructRev : t -> (Name.t * t) option

val fromString : string -> t
val toNames : t -> Name.t list
val toString : t -> string
val toDebugString : t -> string

val compare : t -> t -> int

val addSuffixToFinalName : t -> string -> t
val addPrefixToFinalName : t -> string -> t

val followLink : t -> bool
