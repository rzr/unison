(* $I1: Unison file synchronizer: src/pred.mli $ *)
(* $I2: Last modified by zheyang on Mon, 12 Nov 2001 18:06:11 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

type t

(* Create a new predicate and its associated preference.  The first arg
   is the name of the predicate; the second is full (tex) documentation. *)
val create : string -> string -> t  

(* Check whether a given path matches one of the default or current patterns *)
val test : t -> string -> bool

(* Add list of default patterns to the existing list *)
val addDefaultPatterns : t -> string list -> unit

(* Install a new list of patterns, overriding the current list *)
val intern : t -> string list -> unit

(* Return the current list of patterns *)
val extern : t -> string list
