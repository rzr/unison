(* $I1: Unison file synchronizer: src/files.mli $ *)
(* $I2: Last modified by zheyang on Tue, 09 Apr 2002 17:08:59 -0400 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* As usual, these functions should only be called by the client (i.e., in   *)
(* the same address space as the user interface).                            *)

(* Delete the given subtree of the given replica                             *)
val delete :
     bool                        (* keep backup? *)
  -> Common.root                 (* source root *)
  -> Path.t                      (* deleted path *)
  -> Common.root                 (* root *)
  -> Path.t                      (* path to delete *)
  -> Common.updateItem           (* updates that will be discarded *)
  -> unit Lwt.t

(* Copy a path in one replica to another path in a second replica.  The copy *)
(* is performed atomically (or as close to atomically as the os will         *)
(* support) using temporary files.                                           *)
val copy :
     bool                       (* save old version? *)
  -> [`Update of Uutil.filesize | `Copy] (* whether there was already a file *)
  -> Common.root                (* from what root *)
  -> Path.t                     (* from what path *)
  -> Common.updateItem          (* source updates *)
  -> Common.root                (* to what root *)
  -> Path.t                     (* to what path *)
  -> Common.updateItem          (* dest. updates *)
  -> Uutil.File.t               (* id for showing progress of transfer *)
  -> unit Lwt.t

(* Copy the permission bits from a path in one replica to another path in a  *)
(* second replica.                                                           *)
val setProp :
     Common.root                (* source root *)
  -> Common.root                (* target root *)
  -> Path.t                     (* what path *)
  -> Props.t                    (* previous properties *)
  -> Props.t                    (* new properties *)
  -> Common.updateItem          (* source updates *)
  -> Common.updateItem          (* target updates *)
  -> unit Lwt.t

(* Generate a difference summary for two (possibly remote) versions of a     *)
(* file and send it to a given function                                      *)
val diff :
     Common.root                (* on which roots *)
  -> Common.root                (* ... *)
  -> Path.t                     (* what path *)
  -> Os.fingerprint option      (* fingerprint @ root1 *)
  -> Os.fingerprint option      (* fingerprint @ root2 *)
  -> (string->string->unit)     (* how to display the (title and) result *)
  -> Uutil.File.t               (* id for showing progress of transfer *)
  -> unit

(* This should be called at the beginning of execution, to detect and clean  *)
(* up any pending file operations left over from previous (abnormally        *)
(* terminated) synchronizations                                              *)
val processCommitLogs : unit -> unit

(* List the files in a directory matching a pattern                          *)

(* FIX: we should use fspath, etc., instead of string                        *)
val ls : string -> string -> string list

val get_files_in_directory : string -> string list

val mergeFct  : Common.root
             -> Common.root
             -> Path.t
             -> (string -> unit)    (*display error*)
             -> (string -> bool)    (*ask question to the user*)
             -> Uutil.File.t
             -> Common.updateItem
             -> Common.updateItem
             -> bool
             -> unit
