(* $I1: Unison file synchronizer: src/fileinfo.mli $ *)
(* $I2: Last modified by zheyang on Wed, 12 Dec 2001 02:26:21 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

type typ = [`ABSENT | `FILE | `DIRECTORY | `SYMLINK]
val type2string : typ -> string 

type t = {typ:typ; inode:int; ctime:float; desc:Props.t}

val get : bool -> Fspath.t -> Path.t -> t
val set :
  Fspath.t -> Path.t ->
  [`Set of Props.t | `Copy of Path.t | `Update of Props.t] -> Props.t -> unit

(* IF THIS CHANGES, MAKE SURE TO INCREMENT THE ARCHIVE VERSION NUMBER!       *)
type stamp = 
    InodeStamp of int         (* inode number, for Unix systems *)
  | CtimeStamp of float       (* creation time, for windows systems *)

val stamp : t -> stamp
