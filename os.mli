(* $I1: Unison file synchronizer: src/os.mli $ *)
(* $I2: Last modified by bcpierce on Sun, 24 Mar 2002 11:24:03 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

val myCanonicalHostName : string

val tempPath : Fspath.t -> Path.t -> Path.t
val backupPath : Fspath.t -> Path.t -> Path.t

val createUnisonDir : unit -> unit
val fileInUnisonDir : string -> Fspath.t
val unisonDir : Fspath.t

val childrenOf : Fspath.t -> Path.t -> string list
val readLink : Fspath.t -> Path.t -> string
val symlink : Fspath.t -> Path.t -> string -> unit

val rename : Fspath.t -> Path.t -> Fspath.t -> Path.t -> unit
val createDir : Fspath.t -> Path.t -> Props.t -> unit
val delete : Fspath.t -> Path.t -> unit

type fingerprint
val fingerprint : Fspath.t -> Path.t -> fingerprint
val fingerprint2string : fingerprint -> string
val fingerprintString : string -> fingerprint
val safeFingerprint :
  Fspath.t -> Path.t ->       (* coordinates of file to fingerprint *)
  Fileinfo.t ->               (* old fileinfo *)
  (fingerprint option) ->  (* old fingerprint, if available *)
  Fileinfo.t * fingerprint (* current fileinfo and fingerprint *)

(* Verify that the parent of the given path refers to a directory in the     *)
(* local filesystem.  Raise a Fatal error if not.                            *)
val checkThatParentPathIsADir : Fspath.t -> Path.t -> unit
