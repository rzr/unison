val someHfs : unit -> bool
val allHfs : unit -> bool
val init : bool -> bool -> unit
val hasResourceFork : Fspath.t -> Fspath.t option
val hasAppleDouble : Fspath.t -> Fspath.t option
val digest : Fspath.t -> Digest.t
