(* $I1: Unison file synchronizer: src/case.ml $ *)
(* $I2: Last modified by zheyang on Sat, 09 Mar 2002 02:42:40 -0500 $ *)
(* $I3: Copyright 1999-2002 (see COPYING for details) $ *)

(* The update detector, reconciler, and transporter behave differently       *)
(* depending on whether the local and/or remote file system is case          *)
(* insensitive.  This pref is set during the initial handshake if any one of *)
(* the hosts is case insensitive.                                            *)
let caseInsensitiveMode =
  Prefs.createBool "ignorecase" false
    "ignore upper/lowercase spelling of filenames"
    ("When set to {\\tt true}, this flag causes Unison to use the Windows "
     ^ "semantics for capitalization of filenames---i.e., files in the two "
     ^ "replicas whose names differ in (upper- and lower-case) `spelling' "
     ^ "are treated as the same file.  This flag is set automatically when "
     ^ "either host is running Windows.  In rare circumstances it is also "
     ^ "useful to set it manually (e.g. when running Unison on a Unix system "
     ^ "with a FAT [Windows] volume mounted).")

let insensitive () = Prefs.read caseInsensitiveMode

(* During startup the client determines the case sensitivity of each root.   *)
(* If any root is case insensitive, all roots must know it; we ensure this   *)
(* by storing the information in a pref so that it is propagated to the      *)
(* server with the rest of the prefs.                                        *)
let init someWindows =
  Prefs.set caseInsensitiveMode (someWindows || Prefs.read caseInsensitiveMode)

