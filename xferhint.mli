(* $I1: Unison file synchronizer: src/xferhint.mli $ *)
(* $I2: Last modified by zheyang on Fri, 22 Mar 2002 14:15:11 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* This module maintains a cache that can be used to map
   an Os.fingerprint to a (Fspath.t * Path.t) naming a file that *may*
   (if we are lucky) have this fingerprint.  The cache is not guaranteed
   to be reliable -- the things it returns are only hints, and must be
   double-checked before they are used (to optimize file transfers). *)

val xferbycopying: bool Prefs.t

(* Suggest a file that's likely to have a given fingerprint *)
val lookup: Os.fingerprint -> (Fspath.t * Path.t) option

(* Add, delete, and rename entries *)
val insertEntry: Fspath.t * Path.t -> Os.fingerprint -> unit
val deleteEntry: Fspath.t * Path.t -> unit
val renameEntry: Fspath.t * Path.t -> Fspath.t * Path.t -> unit 

