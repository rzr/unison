(* $I1: Unison file synchronizer: src/uicommon.mli $ *)
(* $I2: Last modified by vouillon on Mon, 25 Mar 2002 12:08:56 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* Kinds of UI *)
type interface =
   Text
 | Graphic

(* The interface of a concrete UI implementation *)
module type UI =
sig
 val start : interface -> unit
end

(* User preference: when true, ask fewer questions *)
val auto : bool Prefs.t

(* User preference: when true, don't ask any questions *)
val batch : bool Prefs.t

(* User preference: How tall to make the main window in the GTK ui *)
val mainWindowHeight : int Prefs.t

(* User preference: Should we reuse top-level windows as much as possible? *)
val reuseToplevelWindows : bool Prefs.t

(* User preference: Expert mode *)
val expert : bool Prefs.t

(* User preference: Whether to display 'contacting server' message *)
val contactquietly : bool Prefs.t

(* User preference: Descriptive label for this profile *)
val profileLabel : string Prefs.t

(* Format the information about current contents of a path in one replica *)
val details2string : Common.reconItem -> string -> string

(* Format a path, eliding initial components that are the same as the
   previous path *)
val displayPath : Path.t -> Path.t -> string

(* Format the names of the roots for display at the head of the
   corresponding columns in the UI *)
val roots2string : unit -> string

(* Format a reconItem (and its status string) for display, eliding
   initial components that are the same as the previous path *)
val reconItem2string : Path.t -> Common.reconItem -> string -> string

(* Format an exception for display *)
val exn2string : exn -> string

(* Calculate and display differences for a file *)
val showDiffs :
     Common.reconItem           (* what path *)
  -> (string->string->unit)     (* how to display the (title and) result *)
  -> (string->unit)             (* how to display errors *)
  -> Uutil.File.t               (* id for transfer progress reports *)
  -> unit

(* Create a merge file which is used for synchronization +++*)
exception Synch_props of Common.reconItem
val applyMerge :
     Common.reconItem       (* what path *)
  -> (string->unit)         (* how to display errors *)
  -> (string->bool)         (* how to ask questions *)
  -> Uutil.File.t           (* id for transfer progress reports *)
  -> bool                   (* bool for backups or not*)
  -> unit

(* Utilities for adding ignore patterns *)
val ignorePath : Path.t -> string
val ignoreName : Path.t -> string
val ignoreExt  : Path.t -> string
val addIgnorePattern : string -> unit

val usageMsg : string

val shortUsageMsg : string

val uiInit :
    reportError:(string -> unit) ->
    tryAgainOrQuit:(string -> bool) ->
    displayWaitMessage:(unit -> unit) ->
    getProfile:(unit -> string option) ->
    getFirstRoot:(unit -> string option) ->
    getSecondRoot:(unit -> string option) ->
    unit

val initPrefs :
  profileName:string ->
  displayWaitMessage:(unit->unit) ->
  getFirstRoot:(unit->string option) ->
  getSecondRoot:(unit->string option) ->
  unit

(* Exit codes *)
val perfectExit: int   (* when everything's okay *)
val skippyExit: int    (* when some items were skipped, but no failure occurred *)
val failedExit: int    (* when there's some non-fatal failure *)
val fatalExit: int     (* when fatal failure occurred *)
val exitCode: bool * bool -> int
(* (anySkipped?, anyFailure?) -> exit code *)
