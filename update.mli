(* $I1: Unison file synchronizer: src/update.mli $ *)
(* $I2: Last modified by vouillon on Thu, 21 Mar 2002 09:01:07 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

type archive =
    ArchiveDir of Props.t * (Name.t * archive) list
  | ArchiveFile of Props.t * Os.fingerprint * Fileinfo.stamp
  | ArchiveSymlink of string
  | NoArchive

(* Calculate a canonical name for the set of roots to be synchronized.  This
   will be used in constructing the archive name for each root. Note, all
   the roots in this canonical name will contain hostnames, even local
   roots, so the roots are re-sorted. *)
val storeRootsName : unit -> unit

val findOnRoot :
  Common.root -> Path.t list -> Common.updateItem list Lwt.t

val findUpdates :
  unit -> Common.updateItem list Common.oneperpath
          (* Structures describing dirty files/dirs (1 per given path) *)

(* Take a tree of equal update contents and update the archive accordingly. *)
val markEqual :
  (Name.t, Common.updateContent * Common.updateContent) Tree.t -> unit

(* Commit in memory the last archive updates, or rollback if an exception is
   raised.  A commit function must have been specified on both sides before
   finishing the transaction. *)
type transaction
val transaction : (transaction -> unit Lwt.t) -> unit Lwt.t

(* Update a part of an archive                                               *)
val updateArchive :
  Common.root -> Path.t -> Common.updateItem -> bool -> transaction ->
  archive Lwt.t
(* Replace a part of an archive by another archive *)
val replaceArchive :
  Common.root -> Path.t -> Fspath.t -> Path.t -> archive -> transaction ->
  unit Lwt.t
(* Update only some permissions *)
val updateProps :
  Common.root -> Path.t -> Props.t option -> Common.updateItem ->
  transaction -> unit Lwt.t

(* Check that no updates has taken place in a given place of the filesystem *)
val checkNoUpdates :
 Common.root -> Path.t -> Common.updateItem -> unit Lwt.t

(* Save to disk the archive updates *)
val commitUpdates : unit -> unit

(* In the user interface, it's helpful to know whether unison was started
   with no archives.  (Then we can display file status as 'unknown' rather
   than 'new', which seems friendlier for new users.)  This flag gets set
   false by the crash recovery code when it determines that no archives were
   present. *)
val foundArchives : bool ref

(* Unlock the archives, if they are locked. *)
val unlockArchives : unit -> unit

(* Find the fspath for the mirror file corresponding to a given path in the
   local replica *)
val findMirror : Path.t -> Fspath.t option

(* Mirror a file that is about to be overwritten *)
val makeMirrorFile : Common.root -> Path.t -> Path.t -> unit Lwt.t

(* Are we checking fast, or carefully? *)
val fastcheck : string Prefs.t

(* Print the archive to the current formatter (see Format) *)
val showArchive: archive -> unit
