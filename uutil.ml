(* $I1: Unison file synchronizer: src/uutil.ml $ *)
(* $I2: Last modified by vouillon on Mon, 25 Mar 2002 12:08:56 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(*****************************************************************************)
(*                      Unison name and version                              *)
(*****************************************************************************)

(* $Format: "let myName = \"$Project$\""$ *)
let myName = "unison"

let versionprefix = "2."

(* $Format: "let myVersion = versionprefix ^ \"$ProjectVersion$\""$ *)
let myVersion = versionprefix ^ "9.1"

(*****************************************************************************)
(*                             HASHING                                       *)
(*****************************************************************************)

let hash2 x y = (x + 253 * y) land 0x3FFFFFFF

(* For the moment, two implementations are provided, using 32-bit and 64-bit *)
(* arithmetic.  The 64-bit version does not appear to work completely        *)
(* (caused an Out_of_memory error when I tried it with my full replica)      *)

(*****************************************************************************)
(*                             File sizes                                    *)
(*****************************************************************************)

module type FILESIZE = sig
  type t
  val zero : t
  val dummy : t
  val add : t -> t -> t
  val neg : t -> t
  val toFloat : t -> float
  val toString : t -> string
  val ofInt : int -> t
  val hash : t -> int
  val percentageOfTotalSize : t -> t -> float
end

module Filesize : FILESIZE = struct
  type t = int64
  let zero = Int64.zero
  let dummy = Int64.minus_one
  let add = Int64.add
  let neg = Int64.neg
  let toFloat = Int64.to_float
  let toString = Int64.to_string
  let ofInt = Int64.of_int
  let hash x =
    hash2 (Int64.to_int x) (Int64.to_int (Int64.shift_right_logical x 31))
  let percentageOfTotalSize current total =
    toFloat current *. 100.0 /. toFloat total
end

module Filesize32 : sig include FILESIZE val extend : t -> Filesize.t end =
struct
  type t = int
  let zero = 0
  let dummy = -1
  let add s t = s + t
  let neg s = - s
  let toFloat = float_of_int
  let toString = string_of_int
  let ofInt t = t
  let hash x = x
  let percentageOfTotalSize current total =
    toFloat current *. 100.0 /. toFloat total
  let extend s = Filesize.ofInt s
end

(* Use the 32-bit implementation for now...                                  *)
type filesize = Filesize32.t
let zerofilesize = Filesize32.zero
let dummyfilesize = Filesize32.dummy
let addfilesizes = Filesize32.add
let filesize2float = Filesize32.toFloat
let filesize2string = Filesize32.toString
let int2filesize = Filesize32.ofInt
let hashfilesize = Filesize32.hash
let percentageOfTotalSize = Filesize32.percentageOfTotalSize
let extendfilesize = Filesize32.extend

(*****************************************************************************)
(*                       File tranfer progress display                       *)
(*****************************************************************************)

module File =
  struct
    type t = int
    let ofLine l = l
    let toLine l = l
    let dummy = 0
  end

let progressPrinter = ref (fun _ _ _ -> ())
let setProgressPrinter p = progressPrinter := p
let showProgress i bytes ch = !progressPrinter i bytes ch

(*****************************************************************************)
(*               Copy bytes from one file_desc to another                    *)
(*****************************************************************************)

let bufsize = 10000
let buf = String.create bufsize

let readWrite source target notify =
  let rec read () =
    let n = Unix.read source buf 0 bufsize in
    if n>0 then begin
      let rec write pos =
        let w = Unix.write target buf pos (n-pos) in
        notify w;
        if (pos+w)<>n then write (pos+w)
      in
      write 0;
      read()
    end
  in
    Util.convertUnixErrorsToTransient "readWrite"
      read
