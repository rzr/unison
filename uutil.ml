(* $I1: Unison file synchronizer: src/uutil.ml $ *)
(* $I2: Last modified by vouillon on Tue, 31 Aug 2004 11:33:38 -0400 $ *)
(* $I3: Copyright 1999-2004 (see COPYING for details) $ *)

(*****************************************************************************)
(*                      Unison name and version                              *)
(*****************************************************************************)

(* $Format: "let myName = \"$Project$\""$ *)
let myName = "unison"

let versionprefix = "2."

(* $Format: "let myVersion = versionprefix ^ \"$ProjectVersion$\""$ *)
let myVersion = versionprefix ^ "10.2"

(*****************************************************************************)
(*                             HASHING                                       *)
(*****************************************************************************)

let hash2 x y = (17 * x + 257 * y) land 0x3FFFFFFF

(*****************************************************************************)
(*                             File sizes                                    *)
(*****************************************************************************)

module type FILESIZE = sig
  type t
  val zero : t
  val dummy : t
  val add : t -> t -> t
  val sub : t -> t -> t
  val toFloat : t -> float
  val toString : t -> string
  val ofInt : int -> t
  val ofInt64 : int64 -> t
  val toInt : t -> int
  val toInt64 : t -> int64
  val fromStats : Unix.LargeFile.stats -> t
  val hash : t -> int
  val percentageOfTotalSize : t -> t -> float
end

module Filesize : FILESIZE = struct
  type t = int64
  let zero = Int64.zero
  let dummy = Int64.minus_one
  let add = Int64.add
  let sub = Int64.sub
  let toFloat = Int64.to_float
  let toString = Int64.to_string
  let ofInt x = Int64.of_int x
  let ofInt64 x = x
  let toInt x = Int64.to_int x
  let toInt64 x = x
  let fromStats st = st.Unix.LargeFile.st_size
  let hash x =
    hash2 (Int64.to_int x) (Int64.to_int (Int64.shift_right_logical x 31))
  let percentageOfTotalSize current total =
    let total = toFloat total in
    if total = 0. then 100.0 else
    toFloat current *. 100.0 /. total
end

(*****************************************************************************)
(*                       File tranfer progress display                       *)
(*****************************************************************************)

module File =
  struct
    type t = int
    let dummy = -1
    let ofLine l = l
    let toLine l = assert (l <> dummy); l
  end

let progressPrinter = ref (fun _ _ _ -> ())
let setProgressPrinter p = progressPrinter := p
let showProgress i bytes ch =
  if i <> File.dummy then !progressPrinter i bytes ch

(*****************************************************************************)
(*               Copy bytes from one file_desc to another                    *)
(*****************************************************************************)

let bufsize = 10000
let bufsizeFS = Filesize.ofInt bufsize
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

let readWriteBounded source target len notify =
  let rec read len =
    if len > Filesize.zero then begin
      let n =
        Unix.read source buf 0
          (if len > bufsizeFS then bufsize else Filesize.toInt len)
      in
      if n > 0 then begin
        let rec write pos =
          let w = Unix.write target buf pos (n - pos) in
          notify w;
          if (pos + w) <> n then write (pos + w)
        in
        write 0;
        read (Filesize.sub len (Filesize.ofInt n))
      end
    end
  in
  Util.convertUnixErrorsToTransient "readWrite" (fun () -> read len)
