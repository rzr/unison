(* $I1: Unison file synchronizer: src/uri.mli $ *)
(* $I2: Last modified by tjim on Mon, 14 Aug 2000 17:35:20 -0400 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* Command-line roots *)
type clroot =
    ConnectLocal of
          string option (* root *)
  | ConnectByShell of
          string        (* shell = "rsh" or "ssh" *)
        * string        (* name of host *)
        * string option (* user name to log in as *)
        * int option    (* port *)
        * string option (* root of replica in host fs *)
  | ConnectBySocket of
          string        (* name of host *)
        * int           (* port where server should be listening *)
        * string option (* root of replica in host fs *)

val clroot2string : clroot -> string

val parseRoot : string -> clroot
