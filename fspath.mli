(* $I1: Unison file synchronizer: src/fspath.mli $ *)
(* $I2: Last modified by zheyang on Wed, 12 Dec 2001 02:26:21 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* Defines an abstract type of absolute filenames (fspaths)                  *)

type t

val child : t -> Name.t -> t
val concat : t -> Path.t -> t

val canonize : string option -> t
val toString : t -> string
val concatToString : t -> Path.t -> string

(* If fspath+path refers to a (followed) symlink, then return the directory  *)
(* of the symlink's target; otherwise return the parent dir of path.  If     *)
(* fspath+path is a root directory, raise Fatal.                             *)
val findWorkingDir : t -> Path.t -> (t * Path.t)

(* Return the least distinguishing suffixes of two fspaths, for displaying   *)
(* in the user interface.                                                    *)
val differentSuffix: t -> t -> (string * string)

(* Wrapped system calls that use invariants of the fspath internal rep       *)

(* BE SURE TO USE ONLY THESE, NOT VERSIONS FROM THE UNIX MODULE!             *)
val stat : t -> Unix.stats
val lstat : t -> Unix.stats
val opendir : t -> Unix.dir_handle
