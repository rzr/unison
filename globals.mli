(* $I1: Unison file synchronizer: src/globals.mli $ *)
(* $I2: Last modified by vouillon on Mon, 25 Mar 2002 12:08:56 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* Global variables and functions needed by top-level modules and user       *)
(* interfaces                                                                *)

(* The raw names of the roots as specified in the profile or on the command  *)
(* line                                                                      *)
val rawRoots : unit -> string list
val setRawRoots : string list -> unit

(* Parse and canonize roots from their raw names                             *)
val installRoots : unit -> unit Lwt.t

(* The roots of the synchronization (with names canonized, but in the same   *)
(* order as the user gave them)                                              *)
val roots : unit -> Common.root * Common.root

(* same thing, as a list                                                     *)
val rootsList : unit -> Common.root list

(* same thing, but in a standard order and ensuring that the Local root, if  *)
(* any, comes first                                                          *)
val rootsInCanonicalOrder : unit -> Common.root list

(* Run a command on all roots                                                *)
val allRootsIter :
  (Common.root -> unit Lwt.t) -> unit Lwt.t

(* Run a command on all roots                                                *)
val allRootsIter2 :
  (Common.root -> 'a -> unit Lwt.t) -> 'a list ->
  unit Lwt.t

(* Run a command on all roots and collect results                            *)
val allRootsMap :
  (Common.root -> 'a Lwt.t) -> 'a list Lwt.t

(* Run a command on all roots in parallel, and collect the results.          *)
(* [allRootsMapWIthWaitingAction f wa] calls the function [wa] before        *)
(* waiting for the result for the corresponding root.                        *)
val allRootsMapWithWaitingAction:
    (Common.root -> 'a Lwt.t) -> (Common.root -> unit) -> 'a list Lwt.t

(* The set of paths to synchronize within the replicas                       *)
val paths : Path.t list Prefs.t

(* Expand any paths ending with *                                            *)
val expandWildcardPaths : unit -> unit

(* Run a command on all hosts in roots                                       *)
val allHostsIter : (string -> unit Lwt.t) -> unit Lwt.t

(* Run a command on all hosts in roots and collect results                   *)
val allHostsMap : (string -> 'a) -> 'a list

(* Make sure that the server has the same settings for its preferences as we *)
(* do locally.  Should be called whenever the local preferences have         *)
(* changed.  (This isn't conceptually a part of this module, but it can't    *)
(* live in the Prefs module because that would introduce a circular          *)
(* dependency.)                                                              *)
val propagatePrefs : unit -> unit Lwt.t

(* Predicates on paths                                                       *)
val ignore : Pred.t
val shouldIgnore : Path.t -> bool
