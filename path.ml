(* $I1: Unison file synchronizer: src/path.ml $ *)
(* $I2: Last modified by zheyang on Sat, 09 Mar 2002 02:42:40 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* Defines an abstract type of relative pathnames *)

(* TODO: For efficiency, in the future we may want to cache the string
   representation of paths *)
type t =
    LTR of Name.t list (* Left-to-right: first name on list is leftmost *)
  | RTL of Name.t list (* Right-to-left: first name on list is rightmost *)

let empty = RTL []

let length = function
    RTL p -> Safelist.length p
  | LTR p -> Safelist.length p

let isEmpty = function
  RTL [] -> true
| LTR [] -> true
| _ -> false

(* Force a path into right-to-left representation *)
let rtl = function
  (RTL _) as path -> path
| (LTR p) -> RTL(Safelist.rev p)

(* Force a path into left-to-right representation *)
let ltr = function
  (LTR _) as path -> path
| (RTL p) -> LTR(Safelist.rev p)

(* Add a name to the end of a path *)
let rcons n path =
  match rtl path with
    RTL ns -> RTL(n::ns)
  | LTR _ -> assert false

(* Give a left-to-right list of names in the path *)
let toNames = function
  LTR p -> p
| RTL p -> Safelist.rev p

let child path name =
  match rtl path with
    RTL ns -> RTL(name::ns)
  | LTR _ -> assert false

let addSuffixToFinalName path suffix =
  match rtl path with
    RTL(n::p) -> RTL((Name.fromString (Name.toString n ^ suffix))::p)
  | _ -> assert false

let addPrefixToFinalName path suffix =
  match rtl path with
    RTL(n::p) -> RTL((Name.fromString (suffix ^ Name.toString n))::p)
  | _ -> assert false

let finalName path =
  match rtl path with
    RTL [] -> None
  | RTL(n::p) -> Some n
  | LTR _ -> assert false

let parent path =
  match rtl path with
    RTL(_::p) -> RTL(p)
  | RTL [] -> assert false
  | LTR _ -> assert false

(* pathDeconstruct : path -> (name * path) option *)
let deconstruct path =
  match ltr path with
    LTR [] -> None
  | LTR(hd::tl) -> Some(hd,LTR tl)
  | RTL _ -> assert false

let deconstructRev path =
  match rtl path with
    RTL [] -> None
  | RTL(hd::tl) -> Some(hd,RTL tl)
  | LTR _ -> assert false

let pathSeparatorChar = '/'
let pathSeparatorString = "/"

let winAbspathRx = Rx.rx "([a-zA-Z]:)?(/|\\\\).*"
let unixAbspathRx = Rx.rx "/.*"
let is_absolute s =
  if Util.osType=`Win32 then Rx.match_string winAbspathRx s
  else Rx.match_string unixAbspathRx s

(* Function string2path: string -> path

   THIS IS THE CRITICAL FUNCTION.

   Problem: What to do on argument "" ?
   What we do: we raise Invalid_argument.

   Problem: double slash within the argument, e.g., "foo//bar".
   What we do: we raise Invalid_argument.

   Problem: What if string2path is applied to an absolute path?  We
   want to disallow this, but, relative is relative.  E.g., on Unix it
   makes sense to have a directory with subdirectory "c:".  Then, it
   makes sense to synchronize on the path "c:".  But this will go
   badly if the Unix system synchronizes with a Windows system.
   What we do: we check whether a path is relative using local
   conventions, and raise Invalid_argument if not.  If we synchronize
   with a system with other conventions, then problems must be caught
   elsewhere.  E.g., the system should refuse to create a directory
   "c:" on a Windows machine.

   Problem: spaces in the argument, e.g., " ".  Still not sure what to
   do here.  Is it possible to create a file with this name in Unix or
   Windows?

   Problem: trailing slashes, e.g., "foo/bar/".  Shells with
   command-line completion may produce these routinely.
   What we do: we remove them.  Moreover, we remove as many as
   necessary, e.g., "foo/bar///" becomes "foo/bar".  This may be
   counter to conventions of some shells/os's, where "foo/bar///"
   might mean "/".

   Examples:
     loop "hello/there" -> ["hello"; "there"]
     loop "/hello/there" -> [""; "hello"; "there"]
     loop "" -> [""]
     loop "/" -> [""; ""]
     loop "//" -> [""; ""; ""]
     loop "c:/" ->["c:"; ""]
     loop "c:/foo" -> ["c:"; "foo"]
*)
let fromString str =
  let str = if Util.osType = `Win32 then Fileutil.bs2fs str else str in
  if is_absolute str then raise(Invalid_argument "Path.fromString");
  let str = Fileutil.removeTrailingSlashes str in
  if str="" then empty else
  let rec loop str =
    try
      let pos = String.index str pathSeparatorChar in
      let name1 = String.sub str 0 pos in
      let str_res =
        String.sub str (pos + 1) (String.length str - pos - 1) in
      (Name.fromString name1)::(loop str_res)
    with
      Not_found -> [Name.fromString str]
    | Invalid_argument _ -> 
        raise(Invalid_argument "Path.fromString") in
  LTR(loop str)

let toStringList p =
  List.map Name.toString (toNames p)

let toString path =
  String.concat pathSeparatorString (toStringList path)

let toDebugString path =
  String.concat " / " (toStringList path)

let compare p1 p2 =
  let n1 = toNames p1 in
  let n2 = toNames p2 in
  let rec lcomp n1 n2 =
    match n1,n2 with
      [],[]-> 0
    | [],_ -> -1
    | _,[] -> 1
    | hd1::tl1,hd2::tl2 ->
        let c = Name.compare hd1 hd2 in
        if c<>0 then c
        else lcomp tl1 tl2 in
  lcomp n1 n2

(* Pref controlling whether symlinks are followed. *)
let follow = Pred.create "follow"
    ("Including the preference \\texttt{-follow \\ARG{pathspec}} causes Unison to \
      treat symbolic links matching \\ARG{pathspec} as `invisible' and \
      behave as if the object pointed to by the link had appeared literally \
      at this position in the replica.  See \
      \\sectionref{symlinks}{Symbolic Links} for more details. \
      The syntax of \\ARG{pathspec>} is \
      described in \\sectionref{pathspec}{Path Specification}.")

let followLink path =
  Util.osType = `Unix
    &&
  Pred.test follow (toString path)
