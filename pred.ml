(* $I1: Unison file synchronizer: src/pred.ml $ *)
(* $I2: Last modified by bcpierce on Wed, 28 Nov 2001 19:07:04 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

let debug = Util.debug "pred"

(* General description:                                                  *)
(* A predicate is determined by a list of default patterns and a list of *) 
(* current patterns.  These patterns can be modified by                  *)
(* [addDefaultPatterns] and [intern].  Function [test p s] tests whether *)
(* string [s] satisfies predicate [p], i.e., it matches a pattern of [p].*)
(*                                                                       *)
(* For efficiency, the list of patterns are compiled into a regular      *)
(* expression.  Function [test] compares the current value of default    *)
(* patterns and current patterns against the save ones (recorded in      *)
(* last_pref/last_def) to determine whether recompilation is necessary.  *)
 
(********************************************************************)
(*                              TYPES                               *)
(********************************************************************)

type t =
  { pref: string list Prefs.t;
    name: string;
    mutable default: string list;
    mutable last_pref : string list;
    mutable last_def : string list;
    mutable last_mode : bool;
    mutable spec: Rx.t }

let error_msg s =
   Printf.sprintf "bad pattern: %s\n\
    A pattern must be introduced by one of the following keywords:\n\
 \032   Name, Path, or Regex." s

(* [select str [(p1, f1), ..., (pN, fN)] fO]: (roughly) *)
(* match str with                                       *)
(*  p1 p' -> f1 p'                                      *) 
(*  ...		       	       	       	       	       	*) 
(*  pN p' -> fN p'   					*)
(*  otherwise -> fO str	       	       	       	        *)
							  
let rec select str l f =
  match l with
    [] -> f str
  | (pref, g)::r ->
      if Util.startswith str pref then
        let l = String.length pref in
        g (Util.trimWhitespace (String.sub str l (String.length str - l)))
      else
        select str r f

(* Compile a pattern (in string form) to a regular expression *)
(* Three kinds of patterns allowed                            *)
(* "Name <name>": ..../<name> (using globx)                   *)
(* "Path <path>": <path>, not starting with "/" (using globx) *)
(* "Regex <regex>": <regex> (using rx)                        *)

let compile_pattern (string:string) : Rx.t =
  try
    select string
      [("Name ", fun str -> Rx.seq [Rx.rx "(.*/)?"; Rx.globx str]);
       ("Path ", fun str ->
          if str<>"" && str.[0] = '/' then
            raise (Prefs.IllegalValue
                     ("Malformed pattern: "
                      ^ "\"" ^ string ^ "\"\n"
                      ^ "'Path' patterns may not begin with a slash; "
                      ^ "only relative paths are allowed."));
          Rx.globx str);
       ("Regex ", Rx.rx)]
      (fun str -> raise (Prefs.IllegalValue (error_msg string)))
  with
    Rx.Parse_error | Rx.Not_supported ->
      raise (Prefs.IllegalValue ("Malformed pattern \"" ^ string ^ "\"."))

let create name fulldoc =
  let pref = 
    Prefs.create name [] ("add a regexp to the " ^ name ^ " list") fulldoc
      (fun oldList string ->
         ignore (compile_pattern string); (* Check wellformedness *)
        string :: oldList)
      (fun l -> l) in
  {pref = pref; name = name;
   last_pref = []; default = []; last_def = []; last_mode = false;
   spec = Rx.empty} 

let addDefaultPatterns p pats =
  p.default <- Safelist.append pats p.default

(********************************************************************)
(*                    IMPORT / EXPORT FUNCTIONS                     *)
(********************************************************************)

let intern p regexpStringList = Prefs.set p.pref regexpStringList

let recompile mode p =
  let pref = Prefs.read p.pref in
  let completeList = Safelist.append p.default pref in
  let spec = Rx.alt (Safelist.map compile_pattern completeList) in
  p.spec <- if mode then Rx.case_insensitive spec else spec;
  p.last_pref <- pref;
  p.last_def <- p.default;
  p.last_mode <- mode

let extern p = Prefs.read p.pref

(********************************************************************)
(*                    OPERATIONS ON IGNORE SPEC                     *)
(********************************************************************)

let test p s =
  let mode = Case.insensitive () in
  if
    p.last_mode <> mode ||
    p.last_pref != Prefs.read p.pref ||
    p.last_def != p.default
  then
    recompile mode p;
  let res = Rx.match_string p.spec s in
  debug (fun() -> Util.msg "%s '%s' = %b\n" p.name s res);
  res
