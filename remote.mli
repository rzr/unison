(* $I1: Unison file synchronizer: src/remote.mli $ *)
(* $I2: Last modified by vouillon on Mon, 25 Mar 2002 12:08:56 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

module Thread : sig
  val unwindProtect : (unit -> 'a Lwt.t) -> (exn -> unit Lwt.t) -> 'a Lwt.t
end

(* Register a server function.  The result is a function that takes a host
   name as argument and either executes locally or else communicates with a
   remote server, as appropriate.  (Calling registerServerCmd also has the
   side effect of registering the command under the given name, so that when
   we are running as a server it can be looked up and executed when
   requested by a remote client.) *)
val registerHostCmd :
    string              (* command name *)
 -> ('a -> 'b Lwt.t) (* local command *)
 -> (   string          (* -> host *)
     -> 'a              (*    arguments *)
     -> 'b Lwt.t)      (*    -> (suspended) result *)

(* A variant of registerHostCmd, for constructing a remote command to be
   applied to a particular root (host + fspath).
 -
   A naming convention: when a `root command' is built from a
   corresponding `local command', we name the two functions
   <funcName>OnRoot and <funcName>Local *)
val registerRootCmd :
    string                         (* command name *)
 -> ((Fspath.t * 'a) -> 'b Lwt.t) (* local command *)
 -> (   Common.root                (* -> root *)
     -> 'a                         (*    additional arguments *)
     -> 'b Lwt.t)                 (*    -> (suspended) result *)


(* Transfer a file from the client to the server *)
val putFile :
    string           (* host *)
 -> [`Update of Uutil.filesize | `Copy]
 -> Fspath.t         (* fspath of source *)
 -> Path.t           (* path of source *)
 -> Fspath.t         (* fspath of target (on host) *)
 -> Path.t           (* path of target *)
 -> Path.t           (* path of "real" [original] target *)
 -> Props.t          (* permissions for new file *)
 -> Uutil.File.t     (* file's index in UI (for progress bars) *)
 -> Os.fingerprint option (* file's finger print, if readily available *)
 -> unit Lwt.t

(* Transfer a file from the server to the client *)
val getFile :
    string           (* host *)
 -> [`Update of Uutil.filesize | `Copy]
 -> Fspath.t         (* fspath of source *)
 -> Path.t           (* path of source *)
 -> Fspath.t         (* fspath of target (on host) *)
 -> Path.t           (* path of target *)
 -> Path.t           (* path of "real" [original] target *)
 -> Props.t          (* permissions for new file *)
 -> Uutil.File.t     (* file's index in UI (for progress bars) *)
 -> Os.fingerprint option  (* file's finger print, if readily available *)
 -> unit Lwt.t

(* Enter "server mode", reading and processing commands from a remote
   client process until killed *)
val beAServer : unit -> unit
val waitOnPort : int -> unit

(* Whether the server should be killed when the client terminates *)
val killServer : bool Prefs.t

(* Establish a connection to the remote server (if any) corresponding
   to the root and return the canonical name of the root *)
val canonizeRoot : Uri.clroot -> Common.root Lwt.t

(* Command line flag -rsync allows rsync to be activated *)
val rsyncActivated : bool Prefs.t

(* Statistics *)
val emittedBytes : float ref
val receivedBytes : float ref
