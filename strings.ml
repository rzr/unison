(* DO NOT MODIFY.
   This file has been automatically generated, see docs.ml. *)

let docs =
    ("about", ("About Unison", 
     "Unison File Synchronizer\n\
      http://www.cis.upenn.edu/~bcpierce/unison\n\
      Version 2.9.1\n\
      \n\
      \032  Unison is a file-synchronization tool for Unix and Windows. It allows\n\
      \032  two replicas of a collection of files and directories to be stored on\n\
      \032  different hosts (or different disks on the same host), modified\n\
      \032  separately, and then brought up to date by propagating the changes in\n\
      \032  each replica to the other.\n\
      \032  \n\
      \032  Unison shares a number of features with tools such as configuration\n\
      \032  management packages (CVS (http://www.cyclic.com/), PRCS\n\
      \032  (http://www.XCF.Berkeley.EDU/~jmacd/prcs.html), etc.), distributed\n\
      \032  filesystems (Coda (http://www.coda.cs.cmu.edu/), etc.),\n\
      \032  uni-directional mirroring utilities (rsync\n\
      \032  (http://samba.anu.edu.au/rsync/), etc.), and other synchronizers\n\
      \032  (Intellisync (http://www.pumatech.com), Reconcile\n\
      \032  (http://www.merl.com/reports/TR99-14/), etc). However, there are\n\
      \032  several points where it differs:\n\
      \032    * Unison runs on both Windows (95, 98, NT, and 2k) and Unix\n\
      \032      (Solaris, Linux, etc.) systems. Moreover, Unison works across\n\
      \032      platforms, allowing you to synchronize a Windows laptop with a\n\
      \032      Unix server, for example.\n\
      \032    * Unlike a distributed filesystem, Unison is a user-level program:\n\
      \032      there is no need to hack (or own!) the kernel, or to have\n\
      \032      superuser privileges on either host.\n\
      \032    * Unlike simple mirroring or backup utilities, Unison can deal with\n\
      \032      updates to both replicas of a distributed directory structure.\n\
      \032      Updates that do not conflict are propagated automatically.\n\
      \032      Conflicting updates are detected and displayed.\n\
      \032    * Unison works between any pair of machines connected to the\n\
      \032      internet, communicating over either a direct socket link or\n\
      \032      tunneling over an rsh or an encrypted ssh connection. It is\n\
      \032      careful with network bandwidth, and runs well over slow links such\n\
      \032      as PPP connections. Transfers of small updates to large files are\n\
      \032      optimized using a compression protocol similar to rsync.\n\
      \032    * Unison has a clear and precise specification, described below.\n\
      \032    * Unison is resilient to failure. It is careful to leave the\n\
      \032      replicas and its own private structures in a sensible state at all\n\
      \032      times, even in case of abnormal termination or communication\n\
      \032      failures.\n\
      \032    * Unison is free; full source code is available under the GNU Public\n\
      \032      License.\n\
      \032      \n\
      \032  There is a moderated, very-low-volume announcement list\n\
      \032  (http://groups.yahoo.com/group/unison-announce) for new Unison\n\
      \032  releases; the archives of this list are available at the above link.\n\
      \032  There is also a moderated (but higher volume) discussion list\n\
      \032  (http://groups.yahoo.com/group/unison-users) for Unison users.\n\
      \032  \n\
      "))
::
    ("", ("Preface", 
     "Preface\n\
      \n\
      "))
::
    ("people", ("People", 
     "\032 People\n\
      \032 \n\
      \032    * Benjamin Pierce (http://www.cis.upenn.edu/~bcpierce) is the Unison\n\
      \032      project leader. Zhe Yang is a full-time postdoc on the project.\n\
      \032    * The current version of Unison was designed and implemented by\n\
      \032      Trevor Jim (http://www.cis.upenn.edu/~tjim), Benjamin Pierce, and\n\
      \032      J\233r\244me Vouillon, with Sylvain Gommier and Matthieu Goulay.\n\
      \032    * Our implementation of the rsync protocol was built by Norman\n\
      \032      Ramsey and Sylvain Gommier. It is is based on Andrew Tridgell's\n\
      \032      thesis work and inspired by his rsync utility.\n\
      \032    * The mirroring and merging functionality was implemented by Sylvain\n\
      \032      Roy.\n\
      \032    * Jacques Garrigue contributed the original Gtk version of the user\n\
      \032      interface.\n\
      \032    * Sundar Balasubramaniam helped build a prototype implementation of\n\
      \032      an earlier synchronizer in Java. Insik Shin and Insup Lee\n\
      \032      (http://www.cis.upenn.edu/~lee) contributed design ideas to this\n\
      \032      implementation. Cedric Fournet contributed to an even earlier\n\
      \032      prototype.\n\
      \032      \n\
      "))
::
    ("copying", ("Copying", 
     "\032 Copying\n\
      \032 \n\
      \032  Unison is free software. You are free to change and redistribute it\n\
      \032  under the terms of the GNU General Public License. Please see the file\n\
      \032  COPYING in the Unison distribution for more information.\n\
      \032  \n\
      "))
::
    ("bugs", ("Reporting Bugs", 
     "\032 Reporting Bugs\n\
      \032 \n\
      \032  If Unison is not working the way you expect, here are some steps to\n\
      \032  follow:\n\
      \032  \n\
      \032    * First, try running Unison with the -debug all command line option.\n\
      \032      This will cause Unison to generate a detailed trace of what it's\n\
      \032      doing, which may make it clearer where the problem is occurring.\n\
      \032    * Second, send mail to unison-help@cis.upenn.edu\n\
      \032      (mailto:unison-help@cis.upenn.edu) describing the problem and\n\
      \032      we'll try to fix it. Make sure to include the version of Unison\n\
      \032      you are using (unison -version), the kind of machine(s) you are\n\
      \032      running it on, a record of what gets printed when the -debug all\n\
      \032      option is included, and as much information as you can about what\n\
      \032      went wrong.\n\
      \032    * If you think the problem you're having might have been encountered\n\
      \032      by others (e.g., if it seems like a configuration problem, not a\n\
      \032      real bug), then you may be able to get some help from the Unison\n\
      \032      users' mailing list, unison-users@groups.yahoo.com\n\
      \032      (mailto:unison-users@groups.yahoo.com).\n\
      \032      \n\
      "))
::
    ("contrib", ("How You Can Help", 
     "\032 How You Can Help\n\
      \032 \n\
      \032  Unison is a part-time project for its developers: we work on it\n\
      \032  because we enjoy making something that is useful for us and for the\n\
      \032  community, but we all have other jobs to do. If you like Unison and\n\
      \032  want to help improve it, your contributions would be very welcome. For\n\
      \032  more details on how the code is organized, etc., see the file CONTRIB\n\
      \032  in the source distribution.\n\
      \032  \n\
      \032  If you don't feel like hacking, you can help us by simply letting us\n\
      \032  know how you like Unison. Even a short note like ``I'm using it; works\n\
      \032  fine'' or ``I looked at it but it's not quite what I want because...''\n\
      \032  will give us valuable information.\n\
      \032  \n\
      "))
::
    ("install", ("Installation", 
     "Installation\n\
      \n\
      \032  Unison is designed to be easy to install. The following sequence of\n\
      \032  steps should get you a fully working installation in a few minutes.\n\
      \032  (If you run into trouble, you may find the suggestions in the section\n\
      \032  ``Advice'' helpful.)\n\
      \032  \n\
      \032  Unison can be used with either of two user interfaces:\n\
      \032   1. a simple textual interface, suitable for dumb terminals (and\n\
      \032      running from scripts), and\n\
      \032   2. a more sophisticated grapical interface, based on Gtk.\n\
      \032      \n\
      \032  You will need to install a copy of Unison on every machine that you\n\
      \032  want to synchronize. However, you only need the version with a\n\
      \032  graphical user interface (if you want a GUI at all) on the machine\n\
      \032  where you're actually going to display the interface (the CLIENT\n\
      \032  machine). Other machines that you synchronize with can get along just\n\
      \032  fine with the textual version.\n\
      \032  \n\
      \032 Downloading Unison\n\
      \032 \n\
      \032  If a pre-built binary of Unison is available for the client machine's\n\
      \032  architecture, just download it and put it somewhere in your search\n\
      \032  path (if you're going to invoke it from the command line) or on your\n\
      \032  desktop (if you'll be click-starting it).\n\
      \032  \n\
      \032  The executable file for the graphical version (with a name including\n\
      \032  gtkui) actually provides both interfaces: the graphical one appears by\n\
      \032  default, while the textual interface can be selected by including -ui\n\
      \032  text on the command line. The textui executable provides just the\n\
      \032  textual interface.\n\
      \032  \n\
      \032  If you don't see a pre-built executable for your architecture, you'll\n\
      \032  need to build it yourself. See the section ``Building Unison'' .\n\
      \032  (There are also a small number of ``contributed ports'' to other\n\
      \032  architectures that are not maintained by us. See the section\n\
      \032  ``Contributed Ports'' to check what's available.)\n\
      \032  \n\
      \032  Check to make sure that what you have downloaded is really executable.\n\
      \032  Either click-start it, or type \"unison -version\" at the command line.\n\
      \032  \n\
      \032  Unison can be used in several different modes: with different\n\
      \032  directories on a single machine, with a remote machine over a direct\n\
      \032  socket connection, with a remote machine using rsh (on Unix systems),\n\
      \032  or with a remote Unix system (from either a Unix or a Windows client)\n\
      \032  using ssh for authentication and secure transfer. If you intend to use\n\
      \032  the last option, you may need to install ssh; see the section\n\
      \032  ``Installing Ssh'' .\n\
      \032  \n\
      \032 Running Unison\n\
      \032 \n\
      \032  Once you've got Unison installed on at least one system, read the\n\
      \032  section ``Tutorial'' of the user manual (or type \"unison -doc\n\
      \032  tutorial\") for instructions on how to get started.\n\
      \032  \n\
      \032 Upgrading\n\
      \032 \n\
      \032  Upgrading to a new version of Unison should be as simple as throwing\n\
      \032  away the old binary and installing the new one.\n\
      \032  \n\
      \032  Before upgrading, it is a good idea to use the old version to make\n\
      \032  sure all your replicas are completely synchronized. A new version of\n\
      \032  Unison will sometimes introduce a different format for the archive\n\
      \032  files used to remember information about the previous state of the\n\
      \032  replicas. In this case, the old archive will be ignored (not deleted\n\
      \032  --- if you roll back to the previous version of Unison, you will find\n\
      \032  the old archives intact), which means that any differences between the\n\
      \032  replicas will show up as conflicts and need to be resolved manually.\n\
      \032  \n\
      \032 Contributed Ports\n\
      \032 \n\
      \032  A few people have offered to maintain pre-built executables, easy\n\
      \032  installation scripts, etc., for particular architectures. They are not\n\
      \032  maintained by us and are not guaranteed to work, be kept up to date\n\
      \032  with our latest releases, etc., but you may find them useful. Here's\n\
      \032  what's available at the moment:\n\
      \032  \n\
      \032    * Dan Pelleg (mailto:dpelleg+unison@cs.cmu.edu) has ported unison to\n\
      \032      FreeBSD. This means that any FreeBSD user with an up-to-date\n\
      \032      ``ports'' collection can install unison by doing: cd\n\
      \032      /usr/ports/net/unison; make && make install. (Make sure your\n\
      \032      ``ports'' collection is fully up to date before doing this, to\n\
      \032      ensure that you get the most recent Unison version that has been\n\
      \032      compiled for FreeBSD.)\n\
      \032      FreeBSD binaries can also be obtained directly from\n\
      \032      \n\
      \032    http://www.freebsd.org/cgi/ports.cgi?query=unison&stype=all.\n\
      \032    * Andrew Pitts has built binaries for some versions of Unison for\n\
      \032      the Linux-PPC platform. They can be found in\n\
      \032      ftp://ftp.cl.cam.ac.uk/papers/amp12/unison/.\n\
      \032    * Robert McQueen (mailto:robot101@debian.org) maintains a Debian\n\
      \032      package for Unison. The homepage is located at\n\
      \032      \n\
      \032    http://packages.debian.org/testing/non-us/unison.html.\n\
      \032    * Chris Cocosco (mailto:crisco+unison@bic.mni.mcgill.ca) provides\n\
      \032      binaries for Unison under SGI IRIX (6.5). They can be found in\n\
      \032      \n\
      \032    www.bic.mni.mcgill.ca/users/crisco/unison.irix/.\n\
      \032      \n\
      \032 Building Unison from Scratch\n\
      \032 \n\
      \032  If a pre-built image is not available, you will need to compile it\n\
      \032  from scratch; the sources are available from the same place as the\n\
      \032  binaries.\n\
      \032  \n\
      \032  In principle, Unison should work on any platform to which OCaml has\n\
      \032  been ported and on which the Unix module is fully implemented. In\n\
      \032  particular, it has been tested on many flavors of Windows (98, NT,\n\
      \032  2000) and Unix (Solaris, Linux, FreeBSD, MacOS X), and on both 32- and\n\
      \032  64-bit architectures.\n\
      \032  \n\
      \032  Unison does not work (and probably never will) on MacOS versions 8 or\n\
      \032  9.\n\
      \032  \n\
      \032   Unix\n\
      \032   \n\
      \032  You'll need the Objective Caml compiler (version 3.04 or later[1]1),\n\
      \032  which is available from its official site http://caml.inria.fr.\n\
      \032  Building and installing OCaml on Unix systems is very straightforward;\n\
      \032  follow the instructions in the distribution. You'll probably want to\n\
      \032  build the native-code compiler in addition to the bytecode compiler,\n\
      \032  but this is not absolutely necessary.\n\
      \032  \n\
      \032  (Quick start: on many systems, the following sequence of commands will\n\
      \032  get you a working and installed compiler: first do make world opt,\n\
      \032  then su to root, then do make install.)\n\
      \032  \n\
      \032  You'll also need the GNU make utility, standard on many Unix systems.\n\
      \032  (Type \"make --version\" to check that you've got the GNU version.)\n\
      \032  \n\
      \032  Once you've got OCaml installed, grab a copy of the Unison sources,\n\
      \032  unzip and untar them, change to the new \"unison\" directory, and type\n\
      \n\
      \032           make UISTYLE=text\n\
      \n\
      \032  The result should be an executable file called \"unison\".\n\
      \032  \n\
      \032  Type \"./unison\" to make sure the program is executable. You should get\n\
      \032  back a usage message.\n\
      \032  \n\
      \032  If you want to build a graphical user interface, choose one of the\n\
      \032  following:\n\
      \032    * Gtk interface:\n\
      \032      You will need Gtk (version 1.2 or later, available from\n\
      \032      http://www.gtk.org and standard on many Unix installations). You\n\
      \032      also need the get LablGtk (version 1.1.3 is known to work). Grab\n\
      \032      the developers' tarball from\n\
      \032      \n\
      \032    http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/lablgtk.html,\n\
      \032      untar it, and follow the instructions to build and install it.\n\
      \032      (Quick start: make configure, then make, then make opt, then su\n\
      \032      and make install.)\n\
      \032      Now build unison. If your search paths are set up correctly,\n\
      \032      typing\n\
      \n\
      \032      make UISTYLE=gtk\n\
      \032      should build a unison executable with a Gtk graphical interface.\n\
      \032      \n\
      \032  If this step does not work, don't worry: Unison works fine with the\n\
      \032  textual interface.\n\
      \032  \n\
      \032  Put the unison executable somewhere in your search path, either by\n\
      \032  adding the Unison directory to your PATH variable or by copying the\n\
      \032  executable to some standard directory where executables are stored.\n\
      \032  \n\
      \032   Windows\n\
      \032   \n\
      \032  Although the binary distribution should work on any version of\n\
      \032  Windows, some people may want to build Unison from scratch on those\n\
      \032  systems too.\n\
      \032  \n\
      \032     Bytecode version:\n\
      \032     \n\
      \032  The simpler but slower compilation option to build a Unison executable\n\
      \032  is to build a bytecode version. You need first install Windows version\n\
      \032  of the OCaml compiler (version 3.04 or later, available from\n\
      \032  http://caml.inria.fr). Then grab a copy of Unison sources and type\n\
      \n\
      \032      make UISTYLE=text NATIVE=false\n\
      \n\
      \032  to compile the bytecode. The result should be an executable file\n\
      \032  called unison.exe.\n\
      \032  \n\
      \032     Native version:\n\
      \032     \n\
      \032  To build a more efficient, native version of Unison on Windows, you\n\
      \032  can choose between two options. Both options require the OCaml\n\
      \032  distribution version 3.04 as well as the Cygwin layer, which provides\n\
      \032  certain GNU tools. The two options differ in the C compiler employed:\n\
      \032  MS Visual C++ (MSVC) vs. Cygwin GNU C.\n\
      \032  \n\
      \032  The tradeoff?\n\
      \032    * Only the MSVC option can produce statically linked Unison\n\
      \032      executable.\n\
      \032    * The Cygwin GNU C option requires only free software.\n\
      \032      \n\
      \032  The files ``INSTALL.win32-msvc'' and ``INSTALL.win32-cygwin-gnuc''\n\
      \032  describe the building procedures for the respective options.\n\
      \032  \n\
      \032   Installation Options\n\
      \032   \n\
      \032  The Makefile in the distribution includes several switches that can be\n\
      \032  used to control how Unison is built. Here are the most useful ones:\n\
      \032    * Building with NATIVE=true uses the native-code OCaml compiler,\n\
      \032      yielding an executable that will run quite a bit faster. We use\n\
      \032      this for building distribution versions.\n\
      \032    * Building with make DEBUGGING=true generates debugging symbols.\n\
      \032    * Building with make STATIC=true generates a (mostly) statically\n\
      \032      linked executable. We use this for building distribution versions,\n\
      \032      for portability.\n\
      \032      \n\
      "))
::
    ("tutorial", ("Tutorial", 
     "Tutorial\n\
      \n\
      \032 Preliminaries\n\
      \032 \n\
      \032  Unison can be used with either of two user interfaces:\n\
      \032   1. a straightforward textual interface and\n\
      \032   2. a more sophisticated graphical interface\n\
      \032      \n\
      \032  The textual interface is more convenient for running from scripts and\n\
      \032  works on dumb terminals; the graphical interface is better for most\n\
      \032  interactive use. For this tutorial, you can use either.\n\
      \032  \n\
      \032  The command-line arguments to both versions are identical. The\n\
      \032  graphical version can be run directly by clicking on its icon, but\n\
      \032  this requires a little set-up (see the section ``Click-starting\n\
      \032  Unison'' ). For this tutorial, we assume that you're starting it from\n\
      \032  the command line.\n\
      \032  \n\
      \032  Unison can synchronize files and directories on a single machine, or\n\
      \032  between two machines on network. (The same program runs on both\n\
      \032  machines; the only difference is which one is responsible for\n\
      \032  displaying the user interface.) If you're only interested in a\n\
      \032  single-machine setup, then let's call that machine the CLIENT . If\n\
      \032  you're synchronizing two machines, let's call them CLIENT and SERVER .\n\
      \032  \n\
      \032 Local Usage\n\
      \032 \n\
      \032  Let's get the client machine set up first, and see how to synchronize\n\
      \032  two directories on a single machine.\n\
      \032  \n\
      \032  Follow the instructions in the section ``Installation'' to either\n\
      \032  download or build an executable version of Unison, and install it\n\
      \032  somewhere on your search path. (If you just want to use the textual\n\
      \032  user interface, download the appropriate textui binary. If you just\n\
      \032  want to the graphical interface---or if you will use both interfaces\n\
      \032  [the gtkui binary actually has both compiled in]---then download the\n\
      \032  gtkui binary.)\n\
      \032  \n\
      \032  Create a small test directory a.tmp containing a couple of files\n\
      \032  and/or subdirectories, e.g.,\n\
      \n\
      \032      mkdir a.tmp\n\
      \032      touch a.tmp/a a.tmp/b\n\
      \032      mkdir a.tmp/d\n\
      \032      touch a.tmp/d/f\n\
      \n\
      \032  Copy this directory to b.tmp:\n\
      \032      cp -r a.tmp b.tmp\n\
      \n\
      \032  Now try synchronizing a.tmp and b.tmp. (Since they are identical,\n\
      \032  synchronizing them won't propagate any changes, but Unison will\n\
      \032  remember the current state of both directories so that it will be able\n\
      \032  to tell next time what has changed.) Type:\n\
      \n\
      \032      unison a.tmp b.tmp\n\
      \n\
      \032  Textual Interface:\n\
      \032    * You should see a message notifying you that all the files are\n\
      \032      actually equal and then get returned to the command line.\n\
      \032      \n\
      \032  Graphical Interface:\n\
      \032    * You should get a big empty window with a message at the bottom\n\
      \032      notifying you that all files are identical. Choose the Exit item\n\
      \032      from the File menu to get back to the command line.\n\
      \032      \n\
      \032  Next, make some changes in a.tmp and/or b.tmp. For example:\n\
      \032       rm a.tmp/a\n\
      \032       echo \"Hello\" > a.tmp/b\n\
      \032       echo \"Hello\" > b.tmp/b\n\
      \032       date > b.tmp/c\n\
      \032       echo \"Hi there\" > a.tmp/d/h\n\
      \032       echo \"Hello there\" > b.tmp/d/h\n\
      \n\
      \032  Run Unison again:\n\
      \032      unison a.tmp b.tmp\n\
      \n\
      \032  This time, the user interface will display only the files that have\n\
      \032  changed. If a file has been modified in just one replica, then it will\n\
      \032  be displayed with an arrow indicating the direction that the change\n\
      \032  needs to be propagated. For example,\n\
      \n\
      \032                <---  new file   c  [f]\n\
      \n\
      \032  indicates that the file c has been modified only in the second\n\
      \032  replica, and that the default action is therefore to propagate the new\n\
      \032  version to the first replica. To follw Unison's recommendation, press\n\
      \032  the ``f'' at the prompt.\n\
      \032  \n\
      \032  If both replicas are modified and their contents are different, then\n\
      \032  the changes are in conflict: <-?-> is displayed to indicate that\n\
      \032  Unison needs guidance on which replica should override the other.\n\
      \n\
      \032    new file  <-?->  new file   d/h  []\n\
      \n\
      \032  By default, neither version will be propagated and both replicas will\n\
      \032  remain as they are.\n\
      \032  \n\
      \032  If both replicas have been modified but their new contents are the\n\
      \032  same (as with the file b), then no propagation is necessary and\n\
      \032  nothing is shown. Unison simply notes that the file is up to date.\n\
      \032  \n\
      \032  These display conventions are used by both versions of the user\n\
      \032  interface. The only difference lies in the way in which Unison's\n\
      \032  default actions are either accepted or overriden by the user.\n\
      \032  \n\
      \032  Textual Interface:\n\
      \032    * The status of each modified file is displayed, in turn. When the\n\
      \032      copies of a file in the two replicas are not identical, the user\n\
      \032      interface will ask for instructions as to how to propagate the\n\
      \032      change. If some default action is indicated (by an arrow), you can\n\
      \032      simply press Return to go on to the next changed file. If you want\n\
      \032      to do something different with this file, press ``<'' or ``>'' to\n\
      \032      force the change to be propagated from right to left or from left\n\
      \032      to right, or else press ``/'' to skip this file and leave both\n\
      \032      replicas alone. When it reaches the end of the list of modified\n\
      \032      files, Unison will ask you one more time whether it should proceed\n\
      \032      with the updates that have been selected.\n\
      \032      When Unison stops to wait for input from the user, pressing ``?''\n\
      \032      will always give a list of possible responses and their meanings.\n\
      \032      \n\
      \032  Graphical Interface:\n\
      \032    * The main window shows all the files that have been modified in\n\
      \032      either a.tmp or b.tmp. To override a default action (or to select\n\
      \032      an action in the case when there is no default), first select the\n\
      \032      file, either by clicking on its name or by using the up- and\n\
      \032      down-arrow keys. Then press either the left-arrow or ``<'' key (to\n\
      \032      cause the version in a.tmp to propagate to b.tmp) or the\n\
      \032      right-arrow or ``>'' key (which makes the b.tmp version override\n\
      \032      a.tmp).\n\
      \032      Every keyboard command can also be invoked from the menus at the\n\
      \032      top of the user interface. (Conversely, each menu item is\n\
      \032      annotated with its keyboard equivalent, if it has one.)\n\
      \032      When you are satisfied with the directions for the propagation of\n\
      \032      changes as shown in the main window, click the ``Go'' button to\n\
      \032      set them in motion. A check sign will be displayed next to each\n\
      \032      filename when the file has been dealt with.\n\
      \032      \n\
      \032 Remote Usage\n\
      \032 \n\
      \032  Next, we'll get Unison set up to synchronize replicas on two different\n\
      \032  machines.\n\
      \032  \n\
      \032  Follow the instructions in the Installation section to download or\n\
      \032  build an executable version of Unison on the server machine, and\n\
      \032  install it somewhere on your search path. (It doesn't matter whether\n\
      \032  you install the textual or graphical version, since the copy of Unison\n\
      \032  on the server doesn't need to display any user interface at all.)\n\
      \032  \n\
      \032  It is important that the version of Unison installed on the server\n\
      \032  machine is the same as the version of Unison on the client machine.\n\
      \032  But some flexibility on the version of Unison at the client side can\n\
      \032  be achieved by using the -addversionno option; see the section\n\
      \032  ``Preferences'' .\n\
      \032  \n\
      \032  Now there is a decision to be made. Unison provides two methods for\n\
      \032  communicating between the client and the server:\n\
      \032    * Remote shell method: To use this method, you must have some way of\n\
      \032      invoking remote commands on the server from the client's command\n\
      \032      line, using a facility such as ssh or rsh. This method is more\n\
      \032      convenient (since there is no need to manually start a ``unison\n\
      \032      server'' process on the server) and also more secure (especially\n\
      \032      if you use ssh).\n\
      \032    * Socket method: This method requires only that you can get TCP\n\
      \032      packets from the client to the server and back. A draconian\n\
      \032      firewall can prevent this, but otherwise it should work anywhere.\n\
      \032      \n\
      \032  Decide which of these you want to try, and continue with the section\n\
      \032  ``Remote Shell Method'' or the section ``Socket Method'' , as\n\
      \032  appropriate.\n\
      \032  \n\
      \032 Remote Shell Method\n\
      \032 \n\
      \032  The standard remote shell facility on Unix systems is rsh. A drop-in\n\
      \032  replacement for rsh is ssh, which provides the same functionality but\n\
      \032  much better security. (Ssh is available from\n\
      \032  ftp://ftp.cs.hut.fi/pub/ssh/; up-to-date binaries for some\n\
      \032  architectures can also be found at ftp://ftp.faqs.org/ssh/contrib. See\n\
      \032  section [2]A.2 for installation instructions for the Windows version.)\n\
      \032  Both rsh and ssh require some coordination between the client and\n\
      \032  server machines to establish that the client is allowed to invoke\n\
      \032  commands on the server; please refer to the rsh or ssh documentation\n\
      \032  for information on how to set this up. The examples in this section\n\
      \032  use ssh, but you can substitute rsh for ssh if you wish.\n\
      \032  \n\
      \032  First, test that we can invoke Unison on the server from the client.\n\
      \032  Typing\n\
      \n\
      \032       ssh remotehostname unison -version\n\
      \n\
      \032  should print the same version information as running\n\
      \032       unison -version\n\
      \n\
      \032  locally on the client. If remote execution fails, then either\n\
      \032  something is wrong with your ssh setup (e.g., ``permission denied'')\n\
      \032  or else the search path that's being used when executing commands on\n\
      \032  the server doesn't contain the unison executable (e.g., ``command not\n\
      \032  found'').\n\
      \032  \n\
      \032  Create a test directory a.tmp in your home directory on the client\n\
      \032  machine.\n\
      \032  \n\
      \032  Test that the local unison client can start and connect to the remote\n\
      \032  server. Type\n\
      \n\
      \032         unison -testServer a.tmp ssh://remotehostname/a.tmp\n\
      \n\
      \032  Now cd to your home directory and type:\n\
      \032         unison a.tmp ssh://remotehostname/a.tmp\n\
      \n\
      \032  The result should be that the entire directory a.tmp is propagated\n\
      \032  from the client to your home directory on the server.\n\
      \032  \n\
      \032  After finishing the first synchronization, change a few files and try\n\
      \032  synchronizing again. You should see similar results as in the local\n\
      \032  case.\n\
      \032  \n\
      \032  If your user name on the server is not the same as on the client, you\n\
      \032  need to specify it on the command line:\n\
      \n\
      \032         unison a.tmp ssh://username@remotehostname/a.tmp\n\
      \n\
      \032  Notes:\n\
      \032    * If you want to put a.tmp some place other than your home directory\n\
      \032      on the remote host, you can give an absolute path for it by adding\n\
      \032      an extra slash between remotehostname and the beginning of the\n\
      \032      path:\n\
      \n\
      \032         unison a.tmp ssh://remotehostname//absolute/path/to/a.tmp\n\
      \032    * You can give an explicit path for the unison executable on the\n\
      \032      server by using the command-line option \"-servercmd\n\
      \032      /full/path/name/of/unison\" or adding\n\
      \032      \"servercmd=/full/path/name/of/unison\" to your profile (see the\n\
      \032      section ``Profile'' ). Similarly, you can specify a explicit path\n\
      \032      for the rsh or ssh program using the option \"-rshcmd\" or\n\
      \032      \"-sshcmd\".\n\
      \032      \n\
      \032 Socket Method\n\
      \032 \n\
      \032  To run Unison over a socket connection, you must start a Unison\n\
      \032  ``daemon'' process on the server. This process runs continuously,\n\
      \032  waiting for connections over a given socket from client machines\n\
      \032  running Unison and processing their requests in turn.\n\
      \032  \n\
      \032    Warning: The socket method is insecure: not only are the texts of\n\
      \032    your changes transmitted over the network in unprotected form, it\n\
      \032    is also possible for anyone in the world to connect to the server\n\
      \032    process and read out the contents of your filesystem! (Of course,\n\
      \032    to do this they must understand the protocol that Unison uses to\n\
      \032    communicate between client and server, but all they need for this\n\
      \032    is a copy of the Unison sources.)\n\
      \032    \n\
      \032  To start the daemon, type\n\
      \032      unison -socket NNNN\n\
      \n\
      \032  on the server machine, where NNNN is the socket number that the daemon\n\
      \032  should listen on for connections from clients. (NNNN can be any large\n\
      \032  number that is not being used by some other program; if NNNN is\n\
      \032  already in use, Unison will exit with an error message.) Note that\n\
      \032  paths specified by the client will be interpreted relative to the\n\
      \032  directory in which you start the server process; this behavior is\n\
      \032  different from the ssh case, where the path is relative to your home\n\
      \032  directory on the server.\n\
      \032  \n\
      \032  Create a test directory a.tmp in your home directory on the client\n\
      \032  machine. Now type:\n\
      \n\
      \032      unison a.tmp socket://remotehostname:NNNN/a.tmp\n\
      \n\
      \032  The result should be that the entire directory a.tmp is propagated\n\
      \032  from the client to the server (a.tmp will be created on the server in\n\
      \032  the directory that the server was started from). After finishing the\n\
      \032  first synchronization, change a few files and try synchronizing again.\n\
      \032  You should see similar results as in the local case.\n\
      \032  \n\
      \032 Using Unison for All Your Files\n\
      \032 \n\
      \032  Once you are comfortable with the basic operation of Unison, you may\n\
      \032  find yourself wanting to use it regularly to synchronize your commonly\n\
      \032  used files. There are several possible ways of going about this:\n\
      \032  \n\
      \032   1. Synchronize your whole home directory, using the Ignore facility\n\
      \032      (see the section ``Ignore'' ) to avoid synchronizing temporary\n\
      \032      files and things that only belong on one host.\n\
      \032   2. Create a subdirectory called shared (or current, or whatever) in\n\
      \032      your home directory on each host, and put all the files you want\n\
      \032      to synchronize into this directory.\n\
      \032   3. Create a subdirectory called shared (or current, or whatever) in\n\
      \032      your home directory on each host, and put links to all the files\n\
      \032      you want to synchronize into this directory. Use the follow\n\
      \032      preference (see the section ``Symbolic Links'' ) to make sure that\n\
      \032      all these links are treated transparently by Unison.\n\
      \032   4. Make your home directory the root of the synchronization, but tell\n\
      \032      Unison to synchronize only some of the files and subdirectories\n\
      \032      within it. This can be accomplished by using the -path switch on\n\
      \032      the command line:\n\
      \n\
      \032      unison /home/username ssh://remotehost//home/username -path shared\n\
      \032      The -path option can be used as many times as needed, to\n\
      \032      synchronize several files or subdirectories:\n\
      \n\
      \032      unison /home/username ssh://remotehost//home/username \\\n\
      \032         -path shared \\\n\
      \032         -path pub \\\n\
      \032         -path .netscape/bookmarks.html\n\
      \032      These -path arguments can also be put in your preference file. See\n\
      \032      the section ``Preferences'' for an example.\n\
      \032      \n\
      \032  When you synchronize a large directory structure (e.g. your home\n\
      \032  directory) for the first time, Unison will need to spend a lot of time\n\
      \032  walking over all the files and building its internal data structures.\n\
      \032  You'll probably save time if you start off focusing Unison's attention\n\
      \032  on just a subset of your files, by including the option -path\n\
      \032  some/small/subdirectory on the command line. When this is working to\n\
      \032  your satisfaction, take away the -path option and go get lunch while\n\
      \032  Unison works.\n\
      \032  \n\
      \032  If your replicas are large and at least one of them is on a Windows\n\
      \032  system, you may find that Unison's default method for detecting\n\
      \032  changes (which involves scanning the full contents of every file on\n\
      \032  every sync---the only completely safe way to do it under Windows) is\n\
      \032  too slow. In this case, you may be interested in the fastcheck\n\
      \032  preference, documented in the section ``Fast Update Checking'' .\n\
      \032  \n\
      \032  Most people find that they only need to maintain a profile (or\n\
      \032  profiles) on one of the hosts that they synchronize, since Unison is\n\
      \032  always initiated from this host. (For example, if you're synchronizing\n\
      \032  a laptop with a fileserver, you'll probably always run Unison on the\n\
      \032  laptop.) This is a bit different from the usual situation with\n\
      \032  asymmetric mirroring programs like rdist, where the mirroring\n\
      \032  operation typically needs to be initiated from the machine with the\n\
      \032  most recent changes. the section ``Profile'' covers the syntax of\n\
      \032  Unison profiles, together with some sample profiles.\n\
      \032  \n\
      \032 Going Further\n\
      \032 \n\
      \032  On-line documentation for the various features of Unison can be\n\
      \032  obtained either by typing\n\
      \n\
      \032       unison -doc topics\n\
      \n\
      \032  at the command line, or by selecting the Help menu in the graphical\n\
      \032  user interface. The same information is also available in a typeset\n\
      \032  User's Manual (HTML or PostScript format) through\n\
      \032  http://www.cis.upenn.edu/~bcpierce/unison.\n\
      \032  \n\
      \032  There are two email lists for users of unison. Visit\n\
      \032  \n\
      \032    http://www.cis.upenn.edu/~bcpierce/unison/download.html\n\
      \032    \n\
      \032  for more details.\n\
      \032  \n\
      "))
::
    ("basics", ("Basic Concepts", 
     "Basic Concepts\n\
      \n\
      \032  Unison deals in a few straightforward concepts. (A more mathematical\n\
      \032  development of these concepts can be found in ``What is a File\n\
      \032  Synchronizer?''\n\
      \032  (http://www.cis.upenn.edu/~bcpierce/papers/snc-mobicom.ps.gz) by\n\
      \032  Sundar Balasubramaniam and Benjamin Pierce [MobiCom 1998]. A more\n\
      \032  up-to-date version can be found in a recent set of slides\n\
      \032  (http://www.cis.upenn.edu/~bcpierce/papers/snc-tacs-2001Oct.ps).)\n\
      \032  \n\
      \032 Roots\n\
      \032 \n\
      \032  A replica's root tells Unison where to find a set of files to be\n\
      \032  synchronized, either on the local machine or on a remote host. For\n\
      \032  example,\n\
      \n\
      \032     relative/path/of/root\n\
      \n\
      \032  specifies a local root relative to the directory where Unison is\n\
      \032  started, while\n\
      \n\
      \032     /absolute/path/of/root\n\
      \n\
      \032  specifies a root relative to the top of the local filesystem,\n\
      \032  independent of where Unison is running. Remote roots can begin with\n\
      \032  ssh://, rsh:// to indicate that the remote server should be started\n\
      \032  with rsh or ssh:\n\
      \n\
      \032     ssh://remotehost//absolute/path/of/root\n\
      \032     rsh://user@remotehost/relative/path/of/root\n\
      \n\
      \032  If the remote server is already running (in the socket mode), then the\n\
      \032  syntax\n\
      \n\
      \032     socket://remotehost:portnum//absolute/path/of/root\n\
      \032     socket://remotehost:portnum/relative/path/of/root\n\
      \n\
      \032  is used to specify the hostname and the port that the client Unison\n\
      \032  should use to contact it.\n\
      \032  \n\
      \032  The syntax for roots is based on that of URIs (described in RFC 2396).\n\
      \032  The full grammar is:\n\
      \n\
      \032 replica ::= [protocol:]//[user@][host][:port][/path]\n\
      \032          |  path\n\
      \n\
      \032 protocol ::= file\n\
      \032           |  socket\n\
      \032           |  ssh\n\
      \032           |  rsh\n\
      \n\
      \032 user ::= [-_a-zA-Z0-9]+\n\
      \n\
      \032 host ::= [-_a-zA-Z0-9.]+\n\
      \n\
      \032 port ::= [0-9]+\n\
      \n\
      \032  When path is given without any protocol prefix, the protocol is\n\
      \032  assumed to be file:. Under Windows, it is possible to synchronize with\n\
      \032  a remote directory using the file: protocol over the Windows Network\n\
      \032  Neighborhood. For example,\n\
      \n\
      \032      unison foo //host/drive/bar\n\
      \n\
      \032  synchronizes the local directory foo with the directory drive:\\bar on\n\
      \032  the machine host, provided that host is accessible via Network\n\
      \032  Neighborhood. When the file: protocol is used in this way, there is no\n\
      \032  need for a Unison server to be running on the remote host. (However,\n\
      \032  running Unison this way is only a good idea if the remote host is\n\
      \032  reached by a very fast network connection, since the full contents of\n\
      \032  every file in the remote replica will have to be transferred to the\n\
      \032  local machine to detect updates.)\n\
      \032  \n\
      \032  The names of roots are canonized by Unison before it uses them to\n\
      \032  compute the names of the corresponding archive files, so\n\
      \032  //saul//home/bcpierce/common and //saul.cis.upenn.edu/common will be\n\
      \032  recognized as the same replica under different names.\n\
      \032  \n\
      \032 Paths\n\
      \032 \n\
      \032  A path refers to a point within a set of files being synchronized; it\n\
      \032  is specified relative to the root of the replica.\n\
      \032  \n\
      \032  Formally, a path is just a sequence of names, separated by /. Note\n\
      \032  that the path separator character is always a forward slash, no matter\n\
      \032  what operating system Unison is running on. Forward slashes are\n\
      \032  converted to backslashes as necessary when paths are converted to\n\
      \032  filenames in the local filesystem on a particular host. (For example,\n\
      \032  suppose that we run Unison on a Windows system, synchronizing the\n\
      \032  local root c:\\pierce with the root\n\
      \032  ssh://saul.cis.upenn.edu/home/bcpierce on a Unix server. Then the path\n\
      \032  current/todo.txt refers to the file c:\\pierce\\current\\todo.txt on the\n\
      \032  client and /home/bcpierce/current/todo.txt on the server.)\n\
      \032  \n\
      \032  The empty path (i.e., the empty sequence of names) denotes the whole\n\
      \032  replica. Unison displays the empty path as ``[root].''\n\
      \032  \n\
      \032  If p is a path and q is a path beginning with p, then q is said to be\n\
      \032  a descendant of p. (Each path is also a descendant of itself.)\n\
      \032  \n\
      \032 What is an Update?\n\
      \032 \n\
      \032  The contents of a path p in a particular replica could be a file, a\n\
      \032  directory, a symbolic link, or absent (if p does not refer to anything\n\
      \032  at all in that replica). More specifically:\n\
      \032    * If p refers to an ordinary file, then the contents of p are the\n\
      \032      actual contents of this file (a string of bytes) plus the current\n\
      \032      permission bits of the file.\n\
      \032    * If p refers to a symbolic link, then the contents of p are just\n\
      \032      the string specifying where the link points.\n\
      \032    * If p refers to a directory, then the contents of p are just the\n\
      \032      token ``DIRECTORY'' plus the current permission bits of the\n\
      \032      directory.\n\
      \032    * If p does not refer to anything in this replica, then the contents\n\
      \032      of p are the token ``ABSENT.''\n\
      \032      \n\
      \032  Unison keeps a record of the contents of each path after each\n\
      \032  successful synchronization of that path (i.e., it remembers the\n\
      \032  contents at the last moment when they were the same in the two\n\
      \032  replicas).\n\
      \032  \n\
      \032  We say that a path is updated (in some replica) if its current\n\
      \032  contents are different from its contents the last time it was\n\
      \032  successfully synchronized.\n\
      \032  \n\
      \032  (What Unison actually calculates is a slight approximation to this\n\
      \032  definition; see the section ``Caveats and Shortcomings'' .)\n\
      \032  \n\
      \032 What is a Conflict?\n\
      \032 \n\
      \032  A path is said to be conflicting if\n\
      \032   1. it has been updated in one replica,\n\
      \032   2. it or any of its descendants has been updated in the other\n\
      \032      replica, and\n\
      \032   3. its contents in the two replicas are not identical.\n\
      \032      \n\
      \032 Reconciliation\n\
      \032 \n\
      \032  Unison operates in several distinct stages:\n\
      \032   1. On each host, it compares its archive file (which records the\n\
      \032      state of each path in the replica when it was last synchronized)\n\
      \032      with the current contents of the replica, to determine which paths\n\
      \032      have been updated.\n\
      \032   2. It checks for ``false conflicts'' --- paths that have been updated\n\
      \032      on both replicas, but whose current values are identical. These\n\
      \032      paths are silently marked as synchronized in the archive files in\n\
      \032      both replicas.\n\
      \032   3. It displays all the updated paths to the user. For updates that do\n\
      \032      not conflict, it suggests a default action (propagating the new\n\
      \032      contents from the updated replica to the other). Conflicting\n\
      \032      updates are just displayed. The user is given an opportunity to\n\
      \032      examine the current state of affairs, change the default actions\n\
      \032      for nonconflicting updates, and choose actions for conflicting\n\
      \032      updates.\n\
      \032   4. It performs the selected actions, one at a time. Each action is\n\
      \032      performed by first transferring the new contents to a temporary\n\
      \032      file on the receiving host, then atomically moving them into\n\
      \032      place.\n\
      \032   5. It updates its archive files to reflect the new state of the\n\
      \032      replicas.\n\
      \032      \n\
      "))
::
    ("failures", ("Invariants", 
     "\032 Invariants\n\
      \032 \n\
      \032  Given the importance and delicacy of the job that it performs, it is\n\
      \032  important to understand both what a synchronizer does under normal\n\
      \032  conditions and what can happen under unusual conditions such as system\n\
      \032  crashes and communication failures.\n\
      \032  \n\
      \032  Unison is careful to protect both its internal state and the state of\n\
      \032  the replicas at every point in this process. Specifically, the\n\
      \032  following guarantees are enforced:\n\
      \032    * At every moment, each path in each replica has either (1) its\n\
      \032      original contents (i.e., no change at all has been made to this\n\
      \032      path), or (2) its correct final contents (i.e., the value that the\n\
      \032      user expected to be propagated from the other replica).\n\
      \032    * At every moment, the information stored on disk about Unison's\n\
      \032      private state can be either (1) unchanged, or (2) updated to\n\
      \032      reflect those paths that have been successfully synchronized.\n\
      \032      \n\
      \032  The upshot is that it is safe to interrupt Unison at any time, either\n\
      \032  manually or accidentally.\n\
      \032  \n\
      \032  If an interruption happens while it is propagating updates, then there\n\
      \032  may be some paths for which an update has been propagated but which\n\
      \032  have not been marked as synchronized in Unison's archives. This is no\n\
      \032  problem: the next time Unison runs, it will detect changes to these\n\
      \032  paths in both replicas, notice that the contents are now equal, and\n\
      \032  mark the paths as successfully updated when it writes back its private\n\
      \032  state at the end of this run.\n\
      \032  \n\
      \032  If Unison is interrupted, it may sometimes leave temporary working\n\
      \032  files (with suffix .tmp) in the replicas. It is safe to delete these\n\
      \032  files. Also, if the (deprecated) backups flag is set, Unison will\n\
      \032  leave around old versions of files, with names like file.0.unison.bak.\n\
      \032  These can be deleted safely, when they are no longer wanted.\n\
      \032  \n\
      \032  Unison is not bothered by clock skew between the different hosts on\n\
      \032  which it is running. It only performs comparisons between timestamps\n\
      \032  obtained from the same host, and the only assumption it makes about\n\
      \032  them is that the clock on each system always runs forward.\n\
      \032  \n\
      \032  If Unison finds that its archive files have been deleted (or that the\n\
      \032  archive format has changed and they cannot be read, or that they don't\n\
      \032  exist because this is the first run of Unison on these particular\n\
      \032  roots), it takes a conservative approach: it behaves as though the\n\
      \032  replicas had both been completely empty at the point of the last\n\
      \032  synchronization. The effect of this is that, on the first run, files\n\
      \032  that exist in only one replica will be propagated to the other, while\n\
      \032  files that exist in both replicas but are unequal will be marked as\n\
      \032  conflicting.\n\
      \032  \n\
      \032  Touching a file without changing its contents should never affect\n\
      \032  Unison's behavior. (On Unix, it uses file modtimes for a quick first\n\
      \032  pass to tell which files have definitely not changed; then for each\n\
      \032  file that might have changed it computes a fingerprint of the file's\n\
      \032  contents and compares it against the last-synchronized contents.)\n\
      \032  \n\
      \032  It is safe to ``brainwash'' Unison by deleting its archive files on\n\
      \032  both replicas. The next time it runs, it will assume that all the\n\
      \032  files it sees in the replicas are new.\n\
      \032  \n\
      \032  It is safe to modify files while Unison is working. If Unison\n\
      \032  discovers that it has propagated an out-of-date change, or that the\n\
      \032  file it is updating has changed on the target replica, it will signal\n\
      \032  a failure for that file. Run Unison again to propagate the latest\n\
      \032  change.\n\
      \032  \n\
      \032  Changes to the ignore patterns from the user interface (e.g., using\n\
      \032  the `i' key) are immediately reflected in the current profile.\n\
      \032  \n\
      \032 Caveats and Shortcomings\n\
      \032 \n\
      \032  Here are some things to be careful of when using Unison. A complete\n\
      \032  list of bugs can be found in the file BUGS.txt in the source\n\
      \032  distribution.\n\
      \032  \n\
      \032    * In the interests of speed, the update detection algorithm may\n\
      \032      (depending on which OS architecture that you run Unison on)\n\
      \032      actually use an approximation to the definition given in the\n\
      \032      section ``What is an Update?'' .\n\
      \032      In particular, the Unix implementation does not compare the actual\n\
      \032      contents of files to their previous contents, but simply looks at\n\
      \032      each file's inode number and modtime; if neither of these have\n\
      \032      changed, then it concludes that the file has not been changed.\n\
      \032      Under normal circumstances, this approximation is safe, in the\n\
      \032      sense that it may sometimes detect ``false updates'' will never\n\
      \032      miss a real one. However, it is possible to fool it, for example\n\
      \032      by using retouch to change a file's modtime back to a time in the\n\
      \032      past.\n\
      \032    * If you synchronize between a single-user filesystem and a shared\n\
      \032      Unix server, you should pay attention to your permission bits: by\n\
      \032      default, Unison will synchronize permissions verbatim, which may\n\
      \032      leave group-writable files on the server that could be written\n\
      \032      over by a lot of people.\n\
      \032      You can control this by setting your umask on both computers to\n\
      \032      something like 022, masking out the ``world write'' and ``group\n\
      \032      write'' permission bits.\n\
      \032    * The graphical user interface is currently single-threaded. This\n\
      \032      means that if Unison is performing some long-running operation,\n\
      \032      the display will not be repainted until it finishes. We recommend\n\
      \032      not trying to do anything with the user interface while Unison is\n\
      \032      in the middle of detecting changes or propagating files.\n\
      \032    * Unison does not currently understand hard links.\n\
      \032      \n\
      "))
::
    ("", ("Reference", 
     "Reference\n\
      \n\
      \032  This section covers the features of Unison in detail.\n\
      \032  \n\
      "))
::
    ("running", ("Running Unison", 
     "\032 Running Unison\n\
      \032 \n\
      \032  There are several ways to start Unison.\n\
      \032    * Typing ``unison profile'' on the command line. Unison will look\n\
      \032      for a file profile.prf in the .unison directory. If this file does\n\
      \032      not specify a pair of roots, Unison will prompt for them and add\n\
      \032      them to the information specified by the profile.\n\
      \032    * Typing ``unison profile root1 root2'' on the command line. In this\n\
      \032      case, Unison will use profile, which should not contain any root\n\
      \032      directives.\n\
      \032    * Typing ``unison root1 root2'' on the command line. This has the\n\
      \032      same effect as typing ``unison default root1 root2.''\n\
      \032    * Typing just ``unison'' (or invoking Unison by clicking on a\n\
      \032      desktop icon). In this case, Unison will ask for the profile to\n\
      \032      use for synchronization (or create a new one, if necessary).\n\
      \032      \n\
      \032 The .unison Directory\n\
      \032 \n\
      \032  Unison stores a variety of information in a private directory on each\n\
      \032  host. If the environment variable UNISON is defined, then its value\n\
      \032  will be used as the name of this directory. If UNISON is not defined,\n\
      \032  then the name of the directory depends on which operating system you\n\
      \032  are using. In Unix, the default is to use $HOME/.unison. In Windows,\n\
      \032  if the environment variable USERPROFILE is defined, then the directory\n\
      \032  will be $USERPROFILE\\.unison; otherwise if HOME is defined, it will be\n\
      \032  $HOME\\.unison; otherwise, it will be c:\\.unison.\n\
      \032  \n\
      \032  The archive file for each replica is found in the .unison directory on\n\
      \032  that replica's host. Profiles (described below) are always taken from\n\
      \032  the .unison directory on the client host.\n\
      \032  \n\
      \032  Note that Unison maintains a completely different set of archive files\n\
      \032  for each pair of roots.\n\
      \032  \n\
      \032  We do not recommend synchronizing the whole .unison directory, as this\n\
      \032  will involve frequent propagation of large archive files. It should be\n\
      \032  safe to do it, though, if you really want to. (Synchronizing the\n\
      \032  profile files in the .unison directory is definitely OK.)\n\
      \032  \n\
      \032 Archive Files\n\
      \032 \n\
      \032  The name of the archive file on each replica is calculated from\n\
      \032    * the canonical names of all the hosts (short names like saul are\n\
      \032      converted into full addresses like saul.cis.upenn.edu),\n\
      \032    * the paths to the replicas on all the hosts (again, relative\n\
      \032      pathnames, symbolic links, etc. are converted into full, absolute\n\
      \032      paths), and\n\
      \032    * an internal version number that is changed whenever a new Unison\n\
      \032      release changes the format of the information stored in the\n\
      \032      archive.\n\
      \032      \n\
      \032  This method should work well for most users. However, it is\n\
      \032  occasionally useful to change the way archive names are generated.\n\
      \032  Unison provides two ways of doing this.\n\
      \032  \n\
      \032  The function that finds the canonical hostname of the local host\n\
      \032  (which is used, for example, in calculating the name of the archive\n\
      \032  file used to remember which files have been synchronized) normally\n\
      \032  uses the gethostname operating system call. However, if the\n\
      \032  environment variable UNISONLOCALHOSTNAME is set, its value will be\n\
      \032  used instead. This makes it easier to use Unison in situations where a\n\
      \032  machine's name changes frequently (e.g., because it is a laptop and\n\
      \032  gets moved around a lot).\n\
      \032  \n\
      \032  A more powerful way of changing archive names is provided by the\n\
      \032  rootalias preference. The preference file may contain any number of\n\
      \032  lines of the form:\n\
      \n\
      \032   rootalias = //hostnameA//path-to-replicaA -> //hostnameB//path-to-replicaB\n\
      \n\
      \032  When calculating the name of the archive files for a given pair of\n\
      \032  roots, Unison replaces any root that matches the left-hand side of any\n\
      \032  rootalias rule by the corresponding right-hand side.\n\
      \032  \n\
      \032  So, if you need to relocate a root on one of the hosts, you can add a\n\
      \032  rule of the form:\n\
      \n\
      \032   rootalias = //new-hostname//new-path -> //old-hostname//old-path\n\
      \n\
      \032  Warning: The rootalias option is dangerous and should only be used if\n\
      \032  you are sure you know what you're doing. In particular, it should only\n\
      \032  be used if you are positive that either (1) both the original root and\n\
      \032  the new alias refer to the same set of files, or (2) the files have\n\
      \032  been relocated so that the original name is now invalid and will never\n\
      \032  be used again. (If the original root and the alias refer to different\n\
      \032  sets of files, Unison's update detector could get confused.) After\n\
      \032  introducing a new rootalias, it is a good idea to run Unison a few\n\
      \032  times interactively (with the batch flag off, etc.) and carefully\n\
      \032  check that things look reasonable---in particular, that update\n\
      \032  detection is working as expected.\n\
      \032  \n\
      \032 Preferences\n\
      \032 \n\
      \032  Many details of Unison's behavior are configurable by user-settable\n\
      \032  ``preferences.''\n\
      \032  \n\
      \032  Some preferences are boolean-valued; these are often called flags.\n\
      \032  Others take numeric or string arguments, indicated in the preferences\n\
      \032  list by n or xxx. Most of the string preferences can be given several\n\
      \032  times; the arguments are accumulated into a list internally.\n\
      \032  \n\
      \032  There are two ways to set the values of preferences: temporarily, by\n\
      \032  providing command-line arguments to a particular run of Unison, or\n\
      \032  permanently, by adding commands to a profile in the .unison directory\n\
      \032  on the client host. The order of preferences (either on the command\n\
      \032  line or in preference files) is not significant.\n\
      \032  \n\
      \032  To set the value of a preference p from the command line, add an\n\
      \032  argument -p (for a boolean flag) or -p n or -p xxx (for a numeric or\n\
      \032  string preference) anywhere on the command line. There is currently no\n\
      \032  way to set a boolean flag to false on the command line (all the\n\
      \032  boolean preferences default to false, so this is only a restriction if\n\
      \032  you've set one to true in your profile and want to reset it\n\
      \032  temporarily to false from the command line).\n\
      \032  \n\
      \032  Here are all the preferences supported by Unison. (This list can be\n\
      \032  obtained by typing unison -help.)\n\
      \032  \n\
      Usage: unison [options]\n\
      \032   or unison root1 root2 [options]\n\
      \032   or unison profilename [options]\n\
      \n\
      Options:\n\
      \032 -addprefsto xxx     file to add new prefs to\n\
      \032 -addversionno       add version number to name of unison executable on server\n\
      \032 -auto               automatically accept default actions\n\
      \032 -backup xxx         add a regexp to the backup list\n\
      \032 -backups            keep backup copies of files (deprecated: use 'backup')\n\
      \032 -batch              batch mode: ask no questions at all\n\
      \032 -contactquietly      Suppress the 'contacting server' message during startup\n\
      \032 -debug xxx          debug module xxx ('all' -> everything, 'verbose' -> more)\n\
      \032 -doc xxx            show documentation ('-doc topics' lists topics)\n\
      \032 -dumbtty            do not try to change terminal settings in text UI\n\
      \032 -editor xxx         command for displaying the output of the merge program\n\
      \032 -fastcheck xxx      do fast update detection (`true', `false', or `default')\n\
      \032 -follow xxx         add a regexp to the follow list\n\
      \032 -force xxx          force changes from this replica to the other\n\
      \032 -group              synchronize group\n\
      \032 -height n           height (in lines) of main window in graphical interface\n\
      \032 -ignore xxx         add a regexp to the ignore list\n\
      \032 -ignorecase         ignore upper/lowercase spelling of filenames\n\
      \032 -ignorenot xxx      add a regexp to the ignorenot list\n\
      \032 -key xxx            define a keyboard shortcut for this profile\n\
      \032 -killserver         kill server when done (even when using sockets)\n\
      \032 -label xxx          provide a descriptive string label for this profile\n\
      \032 -log                record actions in file specified by logfile preference\n\
      \032 -logfile xxx        Log file name\n\
      \032 -maxbackups n       number of backed up versions of a file\n\
      \032 -merge xxx          command for merging conflicting files\n\
      \032 -merge2 xxx         command for merging files (when no common version exists)\n\
      \032 -numericids         don't map uid/gid values by user/group names\n\
      \032 -owner              synchronize owner\n\
      \032 -path xxx           path to synchronize\n\
      \032 -perms n            part of the permissions which is synchronized\n\
      \032 -prefer xxx         choose this replica's version for conflicting changes\n\
      \032 -root xxx           root of a replica\n\
      \032 -rootalias xxx      Register alias for canonical root names\n\
      \032 -rshargs xxx        other arguments (if any) for remote shell command\n\
      \032 -rshcmd xxx         path to the rsh executable\n\
      \032 -servercmd xxx      name of unison executable on remote server\n\
      \032 -silent             print nothing (except error messages)\n\
      \032 -socket xxx         act as a server on a socket\n\
      \032 -sortbysize         list changed files by size, not name\n\
      \032 -sortfirst xxx      add a regexp to the sortfirst list\n\
      \032 -sortlast xxx       add a regexp to the sortlast list\n\
      \032 -sortnewfirst       list new before changed files\n\
      \032 -sshcmd xxx         path to the ssh executable\n\
      \032 -statusdepth n      status display depth for local files\n\
      \032 -terse              suppress status messages\n\
      \032 -testserver         exit immediately after the connection to the server\n\
      \032 -times              synchronize modification times\n\
      \032 -ui xxx             select user interface ('text' or 'graphic')\n\
      \032 -version            print version and exit\n\
      \032 -xferbycopying      optimize transfers using local copies, if possible\n\
      \n\
      \032  Here, in more detail, are what they do. Many are discussed in even\n\
      \032  greater detail in other sections of the manual.\n\
      \032  addprefsto xxx\n\
      \032         By default, new preferences added by Unison (e.g., new ignore\n\
      \032         clauses) will be appended to whatever preference file Unison\n\
      \032         was told to load at the beginning of the run. Setting the\n\
      \032         preference addprefsto filename makes Unison add new preferences\n\
      \032         to the file named filename instead.\n\
      \032  addversionno\n\
      \032         When this flag is set to true, Unison will use\n\
      \032         unison-currentversionnumber instead of just unison as the\n\
      \032         remote server command. This allows multiple binaries for\n\
      \032         different versions of unison to coexist conveniently on the\n\
      \032         same server: whichever version is run on the client, the same\n\
      \032         version will be selected on the server.\n\
      \032  auto\n\
      \032         When set to true, this flag causes the user interface to skip\n\
      \032         asking for confirmations except for non-conflicting changes.\n\
      \032         (More precisely, when the user interface is done setting the\n\
      \032         propagation direction for one entry and is about to move to the\n\
      \032         next, it will skip over all non-conflicting entries and go\n\
      \032         directly to the next conflict.)\n\
      \032  backup xxx\n\
      \032         Including the preference -backup pathspec causes Unison to make\n\
      \032         back up for each path that matches pathspec. More precisely,\n\
      \032         for each path that matches this pathspec, Unison will keep\n\
      \032         several old versions of a file as a backup whenever a change is\n\
      \032         propagated. These backup files are left in the directory\n\
      \032         specified by the environment variable UNISONBACKUPDIR\n\
      \032         (.unison/backup/ by default). The newest backed up copy\n\
      \032         willhave the same name as the original; older versions will be\n\
      \032         named with extensions .n.unibck. The number of versions that\n\
      \032         are kept is determined by the maxbackups preference.\n\
      \032         The syntax of pathspec is described in the section ``Path\n\
      \032         Specification'' .\n\
      \032  backups\n\
      \032         When this flag is true, Unison will keep the old version of a\n\
      \032         file as a backup whenever a change is propagated. These backup\n\
      \032         files are left in the same directory, with extension .bak. This\n\
      \032         flag is probably less useful for most users than the t backup\n\
      \032         flag.\n\
      \032  batch\n\
      \032         When this is set to true, the user interface will ask no\n\
      \032         questions at all. Non-conflicting changes will be propagated;\n\
      \032         conflicts will be skipped.\n\
      \032  contactquietly\n\
      \032         If this flag is set, Unison will skip displaying the\n\
      \032         `Contacting server' window (which some users find annoying)\n\
      \032         during startup.\n\
      \032  debug xxx\n\
      \032         This preference is used to make Unison print various sorts of\n\
      \032         information about what it is doing internally on the standard\n\
      \032         error stream. It can be used many times, each time with the\n\
      \032         name of a module for which debugging information should be\n\
      \032         printed. Possible arguments for debug can be found by looking\n\
      \032         for calls to Util.debug in the sources (using, e.g., grep).\n\
      \032         Setting -debug all causes information from all modules to be\n\
      \032         printed (this mode of usage is the first one to try, if you are\n\
      \032         trying to understand something that Unison seems to be doing\n\
      \032         wrong); -debug verbose turns on some additional debugging\n\
      \032         output from some modules (e.g., it will show exactly what bytes\n\
      \032         are being sent across the network).\n\
      \032  diff xxx\n\
      \032         This preference can be used to control the name (and\n\
      \032         command-line arguments) of the system utility used to generate\n\
      \032         displays of file differences. The default is `diff'. The diff\n\
      \032         program should expect two file names as arguments\n\
      \032  doc xxx\n\
      \032         The command-line argument -doc secname causes unison to display\n\
      \032         section secname of the manual on the standard output and then\n\
      \032         exit. Use -doc all to display the whole manual, which includes\n\
      \032         exactly the same information as the printed and HTML manuals,\n\
      \032         modulo formatting. Use -doc topics to obtain a list of the\n\
      \032         names of the various sections that can be printed.\n\
      \032  dumbtty\n\
      \032         When set to true, this flag makes the text mode user interface\n\
      \032         avoid trying to change any of the terminal settings. (Normally,\n\
      \032         Unison puts the terminal in `raw mode', so that it can do\n\
      \032         things like overwriting the current line.) This is useful, for\n\
      \032         example, when Unison runs in a shell inside of Emacs.\n\
      \032         When dumbtty is set, commands to the user interface need to be\n\
      \032         followed by a carriage return before Unison will execute them.\n\
      \032         (When it is off, Unison recognizes keystrokes as soon as they\n\
      \032         are typed.)\n\
      \032         This preference has no effect on the graphical user interface.\n\
      \032  editor xxx\n\
      \032         This preference is used when unison wants to display the output\n\
      \032         of the merge program when its return value is not 0. User\n\
      \032         changes the file as he wants and then save it, unison will take\n\
      \032         this version for the synchronisation. By default the value is\n\
      \032         `emacs'.\n\
      \032  fastcheck xxx\n\
      \032         When this preference is set to true, Unison will use file\n\
      \032         creation times as `pseudo inode numbers' when scanning replicas\n\
      \032         for updates, instead of reading the full contents of every\n\
      \032         file. Under Windows, this may cause Unison to miss propagating\n\
      \032         an update if the create time, modification time, and length of\n\
      \032         the file are all unchanged by the update (this is not easy to\n\
      \032         achieve, but it can be done). However, Unison will never\n\
      \032         overwrite such an update with a change from the other replica,\n\
      \032         since it always does a safe check for updates just before\n\
      \032         propagating a change. Thus, it is reasonable to use this switch\n\
      \032         under Windows most of the time and occasionally run Unison once\n\
      \032         with fastcheck set to false, if you are worried that Unison may\n\
      \032         have overlooked an update. The default value of the preference\n\
      \032         is auto, which causes Unison to use fast checking on Unix\n\
      \032         replicas (where it is safe) and slow checking on Windows\n\
      \032         replicas. For backward compatibility, yes, no, and default can\n\
      \032         be used in place of true, false, and auto. See the section\n\
      \032         ``Fast Checking'' for more information.\n\
      \032  follow xxx\n\
      \032         Including the preference -follow pathspec causes Unison to\n\
      \032         treat symbolic links matching pathspec as `invisible' and\n\
      \032         behave as if the object pointed to by the link had appeared\n\
      \032         literally at this position in the replica. See the section\n\
      \032         ``Symbolic Links'' for more details. The syntax of pathspec> is\n\
      \032         described in the section ``Path Specification'' .\n\
      \032  force xxx\n\
      \032         Including the preference -force root causes Unison to resolve\n\
      \032         all differences (even non-conflicting changes) in favor of\n\
      \032         root. This effectively changes Unison from a synchronizer into\n\
      \032         a mirroring utility.\n\
      \032         You can also specify -force newer (or -force older) to force\n\
      \032         Unison to choose the file with the later (earlier) modtime. In\n\
      \032         this case, the -times preference must also be enabled.\n\
      \032         This preference should be used only if you are sure you know\n\
      \032         what you are doing!\n\
      \032  group\n\
      \032         When this flag is set to true, the group attributes of the\n\
      \032         files are synchronized. Whether the group names or the group\n\
      \032         identifiers are synchronizeddepends on the preference numerids.\n\
      \032  height n\n\
      \032         Used to set the height (in lines) of the main window in the\n\
      \032         graphical user interface.\n\
      \032  ignore xxx\n\
      \032         Including the preference -ignore pathspec causes Unison to\n\
      \032         completely ignore paths that match pathspec (as well as their\n\
      \032         children). This is useful for avoiding synchronizing temporary\n\
      \032         files, object files, etc. The syntax of pathspec is described\n\
      \032         in the section ``Path Specification'' , and further details on\n\
      \032         ignoring paths is found in the section ``Ignoring Paths'' .\n\
      \032  ignorecase\n\
      \032         When set to true, this flag causes Unison to use the Windows\n\
      \032         semantics for capitalization of filenames---i.e., files in the\n\
      \032         two replicas whose names differ in (upper- and lower-case)\n\
      \032         `spelling' are treated as the same file. This flag is set\n\
      \032         automatically when either host is running Windows. In rare\n\
      \032         circumstances it is also useful to set it manually (e.g. when\n\
      \032         running Unison on a Unix system with a FAT [Windows] volume\n\
      \032         mounted).\n\
      \032  ignorenot xxx\n\
      \032         This preference overrides the preference ignore. It gives a\n\
      \032         list of patterns (in the same format as ignore) for paths that\n\
      \032         should definitely not be ignored, whether or not they happen to\n\
      \032         match one of the ignore patterns.\n\
      \032         Note that the semantics of t ignore and ignorenot is a little\n\
      \032         counter-intuitive. When detecting updates, Unison examines\n\
      \032         paths in depth-first order, starting from the roots of the\n\
      \032         replicas and working downwards. Before examining each path, it\n\
      \032         checks whether it matches t ignore and does not match t\n\
      \032         ignorenot; in this case it skips this path and all its\n\
      \032         descendants. This means that, if some parent of a given path\n\
      \032         matches an ignore pattern, then it will be skipped even if the\n\
      \032         path itself matches an ignorenot pattern. In particular,\n\
      \032         putting ignore = Path * in your profile and then using t\n\
      \032         ignorenot to select particular paths to be synchronized will\n\
      \032         not work. Instead, you should use the path preference to choose\n\
      \032         particular paths to synchronize.\n\
      \032  key xxx\n\
      \032         Used in a profile to define a numeric key (0-9) that can be\n\
      \032         used in the graphical user interface to switch immediately to\n\
      \032         this profile.\n\
      \032  killserver\n\
      \032         When set to true, this flag causes Unison to kill the remote\n\
      \032         server process when the synchronization is finished. This\n\
      \032         behavior is the default for ssh connections, so this preference\n\
      \032         is not normally needed when running over ssh; it is provided so\n\
      \032         that socket-mode servers can be killed off after a single run\n\
      \032         of Unison, rather than waiting to accept future connections.\n\
      \032         (Some users prefer to start a remote socket server for each run\n\
      \032         of Unison, rather than leaving one running all the time.)\n\
      \032  label xxx\n\
      \032         Used in a profile to provide a descriptive string documenting\n\
      \032         its settings. (This is useful for users that switch between\n\
      \032         several profiles, especially using the `fast switch' feature of\n\
      \032         the graphical user interface.)\n\
      \032  log\n\
      \032         When this flag is set, Unison will log all changes to the\n\
      \032         filesystems on a file.\n\
      \032  logfile xxx\n\
      \032         By default, logging messages will be appended to the file\n\
      \032         unison.log in your HOME directory. Set this preference if you\n\
      \032         prefer another file.\n\
      \032  maxbackups n\n\
      \032         This preference specifies the number of backup versions that\n\
      \032         will be kept by unison, for each path that matches the\n\
      \032         predicate backup. The default is 2.\n\
      \032  merge xxx\n\
      \032         This preference can be used to run a merge program which will\n\
      \032         create a new version of the file with the last backup and the\n\
      \032         both replicas. This new version will be used for the\n\
      \032         synchronization. See the section ``Merging Conflicting\n\
      \032         Versions'' for further detail.\n\
      \032  merge2 xxx\n\
      \032         This preference can be used to run a merge program which will\n\
      \032         create a new version of the file with the last backup and the\n\
      \032         both replicas. This new version will be used for the\n\
      \032         synchronization. See the section ``Merging Conflicting\n\
      \032         Versions'' for further detail.\n\
      \032  numericids\n\
      \032         When this flag is set to true, groups and users are\n\
      \032         synchronized numerically, rather than by name.\n\
      \032         The special uid 0 and the special group 0 are never mapped via\n\
      \032         user/group names even if this preference is not set.\n\
      \032  owner\n\
      \032         When this flag is set to true, the owner attributes of the\n\
      \032         files are synchronized. Whether the owner names or the owner\n\
      \032         identifiers are synchronizeddepends on the preference\n\
      \032         extttnumerids.\n\
      \032  path xxx\n\
      \032         When no path preference is given, Unison will simply\n\
      \032         synchronize the two entire replicas, beginning from the given\n\
      \032         pair of roots. If one or more path preferences are given, then\n\
      \032         Unison will synchronize only these paths and their children.\n\
      \032         (This is useful for doing a fast synch of just one directory,\n\
      \032         for example.) Note that path preferences are intepreted\n\
      \032         literally---they are not regular expressions.\n\
      \032  perms n\n\
      \032         The integer value of this preference is a mask indicating which\n\
      \032         permission bits should be synchronized. It is set by default to\n\
      \032         0o1777: all bits but the set-uid and set-gid bits are\n\
      \032         synchronised (synchronizing theses latter bits can be a\n\
      \032         security hazard). If you want to synchronize all bits, you can\n\
      \032         set the value of this preference to -1.\n\
      \032  prefer xxx\n\
      \032         Including the preference -prefer root causes Unison always to\n\
      \032         resolve conflicts in favor of root, rather than asking for\n\
      \032         guidance from the user. (The syntax of root is the same as for\n\
      \032         the root preference, plus the special values newer and older.)\n\
      \032         This preference should be used only if you are sure you know\n\
      \032         what you are doing!\n\
      \032  root xxx\n\
      \032         Each use of this preference names the root of one of the\n\
      \032         replicas for Unison to synchronize. Exactly two roots are\n\
      \032         needed, so normal modes of usage are either to give two values\n\
      \032         for root in the profile, or to give no values in the profile\n\
      \032         and provide two on the command line. Details of the syntax of\n\
      \032         roots can be found in the section ``Roots'' .\n\
      \032         The two roots can be given in either order; Unison will sort\n\
      \032         them into a canonical order before doing anything else. It also\n\
      \032         tries to `canonize' the machine names and paths that appear in\n\
      \032         the roots, so that, if Unison is invoked later with a slightly\n\
      \032         different name for the same root, it will be able to locate the\n\
      \032         correct archives.\n\
      \032  rootalias xxx\n\
      \032         When calculating the name of the archive files for a given pair\n\
      \032         of roots, Unison replaces any roots matching the left-hand side\n\
      \032         of any rootalias rule by the corresponding right-hand side.\n\
      \032  rshargs xxx\n\
      \032         The string value of this preference will be passed as\n\
      \032         additional arguments (besides the host name and the name of the\n\
      \032         Unison executable on the remote system) to the ssh or rsh\n\
      \032         command used to invoke the remote server. (This option is used\n\
      \032         for passing arguments to both rsh or ssh---that's why its name\n\
      \032         is rshargs rather than sshargs.)\n\
      \032  rshcmd xxx\n\
      \032         This preference can be used to explicitly set the name of the\n\
      \032         rsh executable (e.g., giving a full path name), if necessary.\n\
      \032  servercmd xxx\n\
      \032         This preference can be used to explicitly set the name of the\n\
      \032         Unison executable on the remote server (e.g., giving a full\n\
      \032         path name), if necessary.\n\
      \032  silent\n\
      \032         When this preference is set to true, the textual user interface\n\
      \032         will print nothing at all, except in the case of errors.\n\
      \032         Setting silent to true automatically sets the batch preference\n\
      \032         to true.\n\
      \032  sortbysize\n\
      \032         When this flag is set, the user interface will list changed\n\
      \032         files by size (smallest first) rather than by name. This is\n\
      \032         useful, for example, for synchronizing over slow links, since\n\
      \032         it puts very large files at the end of the list where they will\n\
      \032         not prevent smaller files from being transferred quickly.\n\
      \032         This preference (as well as the other sorting flags, but not\n\
      \032         the sorting preferences that require patterns as arguments) can\n\
      \032         be set interactively and temporarily using the 'Sort' menu in\n\
      \032         the graphical user interface.\n\
      \032  sortfirst xxx\n\
      \032         Each argument to sortfirst is a pattern pathspec, which\n\
      \032         describes a set of paths. Files matching any of these patterns\n\
      \032         will be listed first in the user interface. The syntax of\n\
      \032         pathspec is described in the section ``Path Specification'' .\n\
      \032  sortlast xxx\n\
      \032         Similar to sortfirst, except that files matching one of these\n\
      \032         patterns will be listed at the very end.\n\
      \032  sortnewfirst\n\
      \032         When this flag is set, the user interface will list newly\n\
      \032         created files before all others. This is useful, for example,\n\
      \032         for checking that newly created files are not `junk', i.e.,\n\
      \032         ones that should be ignored or deleted rather than\n\
      \032         synchronized.\n\
      \032  sshcmd xxx\n\
      \032         This preference can be used to explicitly set the name of the\n\
      \032         ssh executable (e.g., giving a full path name), if necessary.\n\
      \032  sshversion xxx\n\
      \032         This preference can be used to control which version of ssh\n\
      \032         should be used to connect to the server. Legal values are 1 and\n\
      \032         2, which will cause unison to try to use ssh1 orssh2 instead of\n\
      \032         just ssh to invoke ssh. The default value is empty, which will\n\
      \032         make unison use whatever version of ssh is installed as the\n\
      \032         default `ssh' command.\n\
      \032  statusdepth n\n\
      \032         This preference suppresses the display of status messages\n\
      \032         during update detection on the local machine for paths deeper\n\
      \032         than the specified cutoff. (Displaying too many local status\n\
      \032         messages can slow down update detection somewhat.)\n\
      \032  terse\n\
      \032         When this preference is set to true, the user interface will\n\
      \032         not print status messages.\n\
      \032  testserver\n\
      \032         Setting this flag on the command line causes Unison to attempt\n\
      \032         to connect to the remote server and, if successful, print a\n\
      \032         message and immediately exit. Useful for debugging installation\n\
      \032         problems. Should not be set in preference files.\n\
      \032  times\n\
      \032         When this flag is set to true, file modification times (but not\n\
      \032         directory modtimes) are propagated.\n\
      \032  ui xxx\n\
      \032         This preference selects either the graphical or the textual\n\
      \032         user interface. Legal values are graphic or text.\n\
      \032         If the Unison executable was compiled with only a textual\n\
      \032         interface, this option has no effect. (The pre-compiled\n\
      \032         binaries are all compiled with both interfaces available.)\n\
      \032  version\n\
      \032         Print the current version number and exit. (This option only\n\
      \032         makes sense on the command line.)\n\
      \032  xferbycopying\n\
      \032         When this preference is set, Unison will try to avoid\n\
      \032         transferring file contents across the network by recognizing\n\
      \032         when a file with the required contents already exists in the\n\
      \032         target replica. This usually allows file moves to be propagated\n\
      \032         very quickly. The default value is exttttrue.\n\
      \032         \n\
      \032 Profiles\n\
      \032 \n\
      \032  A profile is a text file that specifies permanent settings for roots,\n\
      \032  paths, ignore patterns, and other preferences, so that they do not\n\
      \032  need to be typed at the command line every time Unison is run.\n\
      \032  Profiles should reside in the .unison directory on the client machine.\n\
      \032  If Unison is started with just one argument name on the command line,\n\
      \032  it looks for a profile called name.prf in the .unison directory. If it\n\
      \032  is started with no arguments, it scans the .unison directory for files\n\
      \032  whose names end in .prf and offers a menu (provided that the Unison\n\
      \032  executable is compiled with the graphical user interface). If a file\n\
      \032  named default.prf is found, its settings will be offered as the\n\
      \032  default choices.\n\
      \032  \n\
      \032  To set the value of a preference p permanently, add to the appropriate\n\
      \032  profile a line of the form\n\
      \n\
      \032       p = true\n\
      \n\
      \032  for a boolean flag or\n\
      \032       p = <value>\n\
      \n\
      \032  for a preference of any other type.\n\
      \032  \n\
      \032  Whitespaces around p and xxx are ignored. A profile may also include\n\
      \032  blank lines, and lines beginning with #; both kinds of lines are\n\
      \032  ignored.\n\
      \032  \n\
      \032  When Unison starts, it first reads the profile and then the command\n\
      \032  line, so command-line options will override settings from the profile.\n\
      \032  \n\
      \032  Profiles may also include lines of the form include name, which will\n\
      \032  cause the file name (or name.prf, if name does not exist in the\n\
      \032  .unison directory) to be read at the point, and included as if its\n\
      \032  contents, instead of the include line, was part of the profile.\n\
      \032  Include lines allows settings common to several profiles to be stored\n\
      \032  in one place.\n\
      \032  \n\
      \032  A profile may include a preference `label = desc' to provide a\n\
      \032  description of the options selected in this profile. The string desc\n\
      \032  is listed along with the profile name in the profile selection dialog,\n\
      \032  and displayed in the top-right corner of the main Unison window in the\n\
      \032  graphical user interface.\n\
      \032  \n\
      \032  The graphical user-interface also supports one-key shortcuts for\n\
      \032  commonly used profiles. If a profile contains a preference of the form\n\
      \032  `key = n', where n is a single digit, then pressing this digit key\n\
      \032  will cause Unison to immediately switch to this profile and begin\n\
      \032  synchronization again from scratch. In this case, all actions that\n\
      \032  have been selected for a set of changes currently being displayed will\n\
      \032  be discarded.\n\
      \032  \n\
      \032 Sample Profiles\n\
      \032 \n\
      \032   A Minimal Profile\n\
      \032   \n\
      \032  Here is a very minimal profile file, such as might be found in\n\
      \032  .unison/default.prf:\n\
      \n\
      \032   # Roots of the synchronization\n\
      \032   root = /home/bcpierce\n\
      \032   root = ssh://saul//home/bcpierce\n\
      \n\
      \032   # Paths to synchronize\n\
      \032   path = current\n\
      \032   path = common\n\
      \032   path = .netscape/bookmarks.html\n\
      \n\
      \032   A Basic Profile\n\
      \032   \n\
      \032  Here is a more sophisticated profile, illustrating some other useful\n\
      \032  features.\n\
      \n\
      \032   # Roots of the synchronization\n\
      \032   root = /home/bcpierce\n\
      \032   root = ssh://saul//home/bcpierce\n\
      \n\
      \032   # Paths to synchronize\n\
      \032   path = current\n\
      \032   path = common\n\
      \032   path = .netscape/bookmarks.html\n\
      \n\
      \032   # Some regexps specifying names and paths to ignore\n\
      \032   ignore = Name temp.*\n\
      \032   ignore = Name *~\n\
      \032   ignore = Name .*~\n\
      \032   ignore = Path */pilot/backup/Archive_*\n\
      \032   ignore = Name *.o\n\
      \032   ignore = Name *.tmp\n\
      \n\
      \032   # Window height\n\
      \032   height = 37\n\
      \n\
      \032   # Keep a backup copy of the entire replica\n\
      \032   backup = Name *\n\
      \n\
      \032   # Use this command for displaying diffs\n\
      \032   diff = diff -y -W 79 --suppress-common-lines\n\
      \n\
      \032   # Log actions to the terminal\n\
      \032   log = true\n\
      \n\
      \032   A Power-User Profile\n\
      \032   \n\
      \032  When Unison is used with large replicas, it is often convenient to be\n\
      \032  able to synchronize just a part of the replicas on a given run (this\n\
      \032  saves the time of detecting updates in the other parts). This can be\n\
      \032  accomplished by splitting up the profile into several parts --- a\n\
      \032  common part containing most of the preference settings, plus one\n\
      \032  ``top-level'' file for each set of paths that need to be synchronized.\n\
      \032  (The include mechanism can also be used to allow the same set of\n\
      \032  preference settings to be used with different roots.)\n\
      \032  \n\
      \032  The collection of profiles implementing this scheme might look as\n\
      \032  follows. The file default.prf is empty except for an include\n\
      \032  directive:\n\
      \n\
      \032   # Include the contents of the file common\n\
      \032   include common\n\
      \n\
      \032  Note that the name of the common file is common, not common.prf; this\n\
      \032  prevents Unison from offering common as one of the list of profiles in\n\
      \032  the opening dialog (in the graphical UI).\n\
      \032  \n\
      \032  The file common contains the real preferences:\n\
      \032   # (... other preferences ...)\n\
      \n\
      \032   # If any new preferences are added by Unison (e.g. 'ignore'\n\
      \032   # preferences added via the graphical UI), then store them in the\n\
      \032   # file 'common' rathen than in the top-level preference file\n\
      \032   addprefsto = common\n\
      \n\
      \032   # regexps specifying names and paths to ignore\n\
      \032   ignore = Name temp.*\n\
      \032   ignore = Name *~\n\
      \032   ignore = Name .*~\n\
      \032   ignore = Path */pilot/backup/Archive_*\n\
      \032   ignore = Name *.o\n\
      \032   ignore = Name *.tmp\n\
      \n\
      \032  Note that there are no path preferences in common. This means that,\n\
      \032  when we invoke Unison with the default profile (e.g., by typing\n\
      \032  'unison default' or just 'unison' on the command line), the whole\n\
      \032  replicas will be synchronized. (If we never want to synchronize the\n\
      \032  whole replicas, then default.prf would instead include settings for\n\
      \032  all the paths that are usually synchronized.)\n\
      \032  \n\
      \032  To synchronize just part of the replicas, Unison is invoked with an\n\
      \032  alternate preference file---e.g., doing 'unison papers', where the\n\
      \032  preference file papers.prf contains\n\
      \n\
      \032   path = current/papers\n\
      \032   path = older/papers\n\
      \032   include common\n\
      \n\
      \032  causes Unison to synchronize just the subdirectories current/papers\n\
      \032  and older/papers.\n\
      \032  \n\
      \032  The key preference can be used in combination with the graphical UI to\n\
      \032  quickly switch between different sets of paths. For example, if the\n\
      \032  file mail.prf contains\n\
      \n\
      \032   path = Mail\n\
      \032   batch = true\n\
      \032   key = 2\n\
      \032   include common\n\
      \n\
      \032  then pressing 2 will cause Unison to look for updates in the Mail\n\
      \032  subdirectory and (because the batch flag is set) immediately propagate\n\
      \032  any that it finds.\n\
      \032  \n\
      \032 Keeping Backups\n\
      \032 \n\
      \032  Unison can maintain full backups of the last-synchronized versions of\n\
      \032  some of the files in each replica; these function both as backups in\n\
      \032  the usual sense and as the ``common version'' when invoking external\n\
      \032  merge programs.\n\
      \032  \n\
      \032  The backed up files are stored in a directory ~/.unison/backup on each\n\
      \032  host. The name of this directory can be changed by setting the\n\
      \032  environment variable UNISONBACKUPDIR. Files are added to the backup\n\
      \032  directory whenever unison updates its archive. This means that\n\
      \032    * When unison reconstructs its archive from scratch (e.g., because\n\
      \032      of an upgrade, or because the archive files have been manually\n\
      \032      deleted), all files will be backed up.\n\
      \032    * Otherwise, each file will be backed up the first time unison\n\
      \032      propagates an update for it.\n\
      \032      \n\
      \032  It is safe to manually delete files from the backup directory (or to\n\
      \032  throw away the directory itself). Before unison uses any of these\n\
      \032  files for anything important, it checks that its fingerprint matches\n\
      \032  the one that it expects.\n\
      \032  \n\
      \032  The preference backup controls which files are actually backed up: for\n\
      \032  example, giving the preference `backup = Path *' causes backing up of\n\
      \032  all files. The preference backupversions controls how many previous\n\
      \032  versions of each file are kept. The default is value 2 (i.e., the last\n\
      \032  synchronized version plus one backup). For backward compatibility, the\n\
      \032  backups preference is also still supported, but backup is now\n\
      \032  preferred.\n\
      \032  \n\
      \032 Merging Conflicting Versions\n\
      \032 \n\
      \032  Both user interfaces offer a `merge' command that can be used to\n\
      \032  interactively merge conflicting versions of a file. It is invoked by\n\
      \032  selecting a conflicting file and pressing `m'.\n\
      \032  \n\
      \032  The actual merging is performed by an external program. The\n\
      \032  preferences merge and merge2 control how this program is invoked. If a\n\
      \032  backup exists for this file (see the backup preference), then the\n\
      \032  merge preference is used for this purpose; otherwise merge2 is used.\n\
      \032  In both cases, the value of the preference should be a string\n\
      \032  representing the command that should be passed to a shell to invoke\n\
      \032  the merge program. Within this string, the special substrings\n\
      \032  CURRENT1, CURRENT2, NEW, and OLD may appear at any point. Unison will\n\
      \032  substitute these substrings as follows before invoking the command:\n\
      \032    * CURRENT1 is replaced by the name of the local copy of the file;\n\
      \032    * CURRENT2 is replaced by the name of a temporary file, into which\n\
      \032      the contents of the remote copy of the file have been transferred\n\
      \032      by Unison prior to performing the merge;\n\
      \032    * NEW is replaced by the name of a temporary file that Unison\n\
      \032      expects to be written by the merge program when it finishes,\n\
      \032      giving the desired new contents of the file; and\n\
      \032    * OLD is replaced by the name of the backed up copy of the original\n\
      \032      version of the file (i.e., its state at the end of the last\n\
      \032      successful run of Unison), if one exists. Substitution of OLD\n\
      \032      applies only to merge, not merge2).\n\
      \032      \n\
      \032  For example, on Unix systems setting the merge preference to\n\
      \032  merge = diff3 -m CURRENT1 OLD CURRENT2 > NEW\n\
      \n\
      \032  will tell Unison to use the external diff3 program for merging. A\n\
      \032  large number of external merging programs are available. For example,\n\
      \032  emacs users may find the following settings convenient:\n\
      \n\
      \032   merge2 = emacs -q --eval '(ediff-merge-files \"CURRENT1\" \"CURRENT2\"\n\
      \032              nil \"NEW\")'\n\
      \032   merge = emacs -q --eval '(ediff-merge-files-with-ancestor\n\
      \032              \"CURRENT1\" \"CURRENT2\" \"OLD\" nil \"NEW\")'\n\
      \n\
      \032  (These commands are displayed here on two lines to avoid running off\n\
      \032  the edge of the page. In your preference file, each command should be\n\
      \032  written on a single line.)\n\
      \032  \n\
      \032  If the external program exits without leaving any file at the path\n\
      \032  NEW, Unison considers the merge to have failed. If the merge program\n\
      \032  writes a file called NEW but exits with a non-zero status code, then\n\
      \032  Unison considers the merge to have succeeded but to have generated\n\
      \032  conflicts. In this case, it attempts to invoke an external editor so\n\
      \032  that the user can resolve the conflicts. The value of the editor\n\
      \032  preference controls what editor is invoked by Unison. The default is\n\
      \032  emacs.\n\
      \032  \n\
      \032    Please send us suggestions for other useful values of the merge2\n\
      \032    and merge preferences---we'd like to give several examples in the\n\
      \032    manual.) \n\
      \032    \n\
      \032 The User Interface\n\
      \032 \n\
      \032  Both the textual and the graphical user interfaces are intended to be\n\
      \032  mostly self-explanatory. Here are just a few tricks:\n\
      \032    * By default, when running on Unix the textual user interface will\n\
      \032      try to put the terminal into the ``raw mode'' so that it reads the\n\
      \032      input a character at a time rather than a line at a time. (This\n\
      \032      means you can type just the single keystroke ``>'' to tell Unison\n\
      \032      to propagate a file from left to right, rather than ``> Enter.'')\n\
      \032      There are some situations, though, where this will not work ---\n\
      \032      for example, when Unison is running in a shell window inside\n\
      \032      Emacs. Setting the dumbtty preference will force Unison to leave\n\
      \032      the terminal alone and process input a line at a time.\n\
      \032      \n\
      \032 Exit code\n\
      \032 \n\
      \032  When running in the textual mode, Unison returns an exit status, which\n\
      \032  describes whether, and at which level, the synchronization was\n\
      \032  successful. The exit status could be useful when Unison is invoked\n\
      \032  from a script. Currently, there are four possible values for the exit\n\
      \032  status:\n\
      \032    * 0: successful synchronization; everything is up-to-date now.\n\
      \032    * 1: some files were skipped, but all file transfers were\n\
      \032      successful.\n\
      \032    * 2: non-fatal failures occurred during file transfer.\n\
      \032    * 3: a fatal error occurred, or the execution was interrupted.\n\
      \032      \n\
      \032  The graphical interface does not return any useful information through\n\
      \032  the exit status.\n\
      \032  \n\
      \032 Path specification\n\
      \032 \n\
      \032  Several Unison preferences (e.g., ignore/ignorenot, follow,\n\
      \032  sortfirst/sortlast, backup) specify individual paths or sets of paths.\n\
      \032  These preferences share a common syntax based on regular-expressions.\n\
      \032  Each preference is associated with a list of path patterns; the paths\n\
      \032  specified are those that match any one of the path pattern.\n\
      \032  \n\
      \032    * Pattern preferences can be given on the command line, or, more\n\
      \032      often, stored in profiles, using the same syntax as other\n\
      \032      preferences. For example, a profile line of the form\n\
      \n\
      \032            ignore = pattern\n\
      \032      adds pattern to the list of patterns to be ignored.\n\
      \032    * Each pattern can have one of three forms. The most general form is\n\
      \032      a Posix extended regular expression introduced by the keyword\n\
      \032      Regex. (The collating sequences and character classes of full\n\
      \032      Posix regexps are not currently supported).\n\
      \n\
      \032                Regex regexp\n\
      \032      For convenience, two other styles of pattern are also recognized:\n\
      \n\
      \032                Name name\n\
      \032      matches any path in which the last component matches name, while\n\
      \n\
      \032                Path path\n\
      \032      matches exactly the path path. The name and path arguments of the\n\
      \032      latter forms of patterns are not regular expressions. Instead,\n\
      \032      standard ``globbing'' conventions can be used in name and path:\n\
      \032         + a ? matches any single character except /\n\
      \032         + a * matches any sequence of characters not including /\n\
      \032         + [xyz] matches any character from the set {x, y, z }\n\
      \032         + {a,bb,ccc} matches any one of a, bb, or ccc.\n\
      \032    * The path separator in path patterns is always the forward-slash\n\
      \032      character ``/'' --- even when the client or server is running\n\
      \032      under Windows, where the normal separator character is a\n\
      \032      backslash. This makes it possible to use the same set of path\n\
      \032      patterns for both Unix and Windows file systems.\n\
      \032      \n\
      \032  Some examples of path patterns appear in the section ``Ignoring\n\
      \032  Paths'' .\n\
      \032  \n\
      \032 Ignoring Paths\n\
      \032 \n\
      \032  Most users of Unison will find that their replicas contain lots of\n\
      \032  files that they don't ever want to synchronize --- temporary files,\n\
      \032  very large files, old stuff, architecture-specific binaries, etc. They\n\
      \032  can instruct Unison to ignore these paths using patterns introduced in\n\
      \032  the section ``Path Patterns'' .\n\
      \032  \n\
      \032  For example, the following pattern will make Unison ignore any path\n\
      \032  containing the name CVS or a name ending in .cmo:\n\
      \n\
      \032            ignore = Name {CVS,*.cmo}\n\
      \n\
      \032  The next pattern makes Unison ignore the path a/b:\n\
      \032            ignore = Path a/b\n\
      \n\
      \032  This pattern makes Unison ignore any path beginning with a/b and\n\
      \032  ending with a name ending by .ml.\n\
      \n\
      \032            ignore = Regex a/b/.*\\.ml\n\
      \n\
      \032  Note that regular expression patterns are ``anchored'': they must\n\
      \032  match the whole path, not just a substring of the path.\n\
      \032  \n\
      \032  Here are a few extra points regarding the ignore preference.\n\
      \032    * If a directory is ignored, all its descendents will be too.\n\
      \032    * The user interface provides some convenient commands for adding\n\
      \032      new patterns to be ignored. To ignore a particular file, select it\n\
      \032      and press ``i''. To ignore all files with the same extension,\n\
      \032      select it and press ``E'' (with the shift key). To ignore all\n\
      \032      files with the same name, no matter what directory they appear in,\n\
      \032      select it and press ``N''. These new patterns become permanent:\n\
      \032      they are immediately added to the current profile on disk.\n\
      \032    * If you use the include directive to include a common collection of\n\
      \032      preferences in several top-level preference files, you will\n\
      \032      probably also want to set the addprefsto preference to the name of\n\
      \032      this file. This will cause any new ignore patterns that you add\n\
      \032      from inside Unison to be appended to this file, instead of\n\
      \032      whichever top-level preference file you started Unison with.\n\
      \032    * Ignore patterns can also be specified on the command line, if you\n\
      \032      like (this is probably not very useful), using an option like\n\
      \032      -ignore 'Name temp.txt'.\n\
      \032      \n\
      \032 Symbolic Links\n\
      \032 \n\
      \032  Ordinarily, Unison treats symbolic links in Unix replicas as\n\
      \032  ``opaque'': it considers the contents of the link to be just the\n\
      \032  string specifying where the link points, and it will propagate changes\n\
      \032  in this string to the other replica.\n\
      \032  \n\
      \032  It is sometimes useful to treat a symbolic link ``transparently,''\n\
      \032  acting as though whatever it points to were physically in the replica\n\
      \032  at the point where the symbolic link appears. To tell Unison to treat\n\
      \032  a link in this manner, add a line of the form\n\
      \n\
      \032            follow = pathspec\n\
      \n\
      \032  to the profile, where pathspec is a path pattern as described in the\n\
      \032  section ``Path Patterns'' .\n\
      \032  \n\
      \032  Windows file systems do not support symbolic links; Unison will refuse\n\
      \032  to propagate an opaque symbolic link from Unix to Windows and flag the\n\
      \032  path as erroneous. When a Unix replica is to be synchronized with a\n\
      \032  Windows system, all symbolic links should match either an ignore\n\
      \032  pattern or a follow pattern.\n\
      \032  \n\
      \032 Permissions\n\
      \032 \n\
      \032  Synchronizing the permission bits of files is slightly tricky when two\n\
      \032  different filesytems are involved (e.g., when synchronizing a Windows\n\
      \032  client and a Unix server). In detail, here's how it works:\n\
      \032    * When the permission bits of an existing file or directory are\n\
      \032      changed, the values of those bits that make sense on both\n\
      \032      operating systems will be propagated to the other replica. The\n\
      \032      other bits will not be changed.\n\
      \032    * When a newly created file is propagated to a remote replica, the\n\
      \032      permission bits that make sense in both operating systems are also\n\
      \032      propagated. The values of the other bits are set to default values\n\
      \032      (they are taken from the current umask, if the receiving host is a\n\
      \032      Unix system).\n\
      \032    * For security reasons, the Unix setuid and setgid bits are not\n\
      \032      propagated.\n\
      \032    * The Unix owner and group ids are not propagated. (What would this\n\
      \032      mean, in general?) All files are created with the owner and group\n\
      \032      of the server process.\n\
      \032      \n\
      \032 Cross-Platform Synchronization\n\
      \032 \n\
      \032  If you use Unison to synchronize files between Windows and Unix\n\
      \032  systems, there are a few special issues to be aware of.\n\
      \032  \n\
      \032  Case conflicts. In Unix, filenames are case sensitive: foo and FOO can\n\
      \032  refer to different files. In Windows, on the other hand, filenames are\n\
      \032  not case sensitive: foo and FOO can only refer to the same file. This\n\
      \032  means that a Unix foo and FOO cannot be synchronized onto a Windows\n\
      \032  system --- Windows won't allow two different files to have the\n\
      \032  ``same'' name. Unison detects this situation for you, and reports that\n\
      \032  it cannot synchronize the files.\n\
      \032  \n\
      \032  You can deal with a case conflict in a couple of ways. If you need to\n\
      \032  have both files on the Windows system, your only choice is to rename\n\
      \032  one of the Unix files to avoid the case conflict, and re-synchronize.\n\
      \032  If you don't need the files on the Windows system, you can simply\n\
      \032  disregard Unison's warning message, and go ahead with the\n\
      \032  synchronization; Unison won't touch those files. If you don't want to\n\
      \032  see the warning on each synchronization, you can tell Unison to ignore\n\
      \032  the files (see the section ``Ignore'' ).\n\
      \032  \n\
      \032  Illegal filenames. Unix allows some filenames that are illegal in\n\
      \032  Windows. For example, colons (`:') are not allowed in Windows\n\
      \032  filenames, but they are legal in Unix filenames. This means that a\n\
      \032  Unix file foo:bar can't be synchronized to a Windows system. As with\n\
      \032  case conflicts, Unison detects this situation for you, and you have\n\
      \032  the same options: you can either rename the Unix file and\n\
      \032  re-synchronize, or you can ignore it.\n\
      \032  \n\
      \032 Slow Links\n\
      \032 \n\
      \032  Unison is built to run well even over relatively slow links such as\n\
      \032  modems and DSL connections.\n\
      \032  \n\
      \032  Unison uses the ``rsync protocol'' designed by Andrew Tridgell and\n\
      \032  Paul Mackerras to greatly speed up transfers of large files in which\n\
      \032  only small changes have been made. More information about the rsync\n\
      \032  protocol can be found at the rsync web site\n\
      \032  (http://samba.anu.edu.au/rsync/).\n\
      \032  \n\
      \032  If you are using Unison with ssh, you may get some speed improvement\n\
      \032  by enabling ssh's compression feature. Do this by adding the option\n\
      \032  ``-rshargs -C'' to the command line or ``rshargs = -C'' to your\n\
      \032  profile.\n\
      \032  \n\
      \032 Fast Update Detection\n\
      \032 \n\
      \032  If your replicas are large and at least one of them is on a Windows\n\
      \032  system, you may find that Unison's default method for detecting\n\
      \032  changes (which involves scanning the full contents of every file on\n\
      \032  every sync---the only completely safe way to do it under Windows) is\n\
      \032  too slow. Unison provides a preference fastcheck that, when set to\n\
      \032  yes, causes it to use file creation times as 'pseudo inode numbers'\n\
      \032  when scanning replicas for updates, instead of reading the full\n\
      \032  contents of every file.\n\
      \032  \n\
      \032  When fastcheck is set to no, Unison will perform slow\n\
      \032  checking---re-scanning the contents of each file on each\n\
      \032  synchronization---on all replicas. When fastcheck is set to default\n\
      \032  (which, naturally, is the default), Unison will use fast checks on\n\
      \032  Unix replicas and slow checks on Windows replicas.\n\
      \032  \n\
      \032  This strategy may cause Unison to miss propagating an update if the\n\
      \032  create time, modification time, and length of the file are all\n\
      \032  unchanged by the update (this is not easy to achieve, but it can be\n\
      \032  done). However, Unison will never overwrite such an update with a\n\
      \032  change from the other replica, since it always does a safe check for\n\
      \032  updates just before propagating a change. Thus, it is reasonable to\n\
      \032  use this switch most of the time and occasionally run Unison once with\n\
      \032  fastcheck set to no, if you are worried that Unison may have\n\
      \032  overlooked an update.\n\
      \032  \n\
      \032 Click-starting Unison\n\
      \032 \n\
      \032  On Windows NT/2k systems, the graphical version of Unison can be\n\
      \032  invoked directly by clicking on its icon. On Windows 95/98 systems,\n\
      \032  click-starting also works, as long as you are not using ssh. Due to an\n\
      \032  incompatibility with ocaml and Windows 95/98 that is not under our\n\
      \032  control, you must start Unison from a DOS window in Windows 95/98 if\n\
      \032  you want to use ssh.\n\
      \032  \n\
      \032  When you click on the Unison icon, two windows will be created:\n\
      \032  Unison's regular window, plus a console window, which is used only for\n\
      \032  giving your password to ssh (if you do not use ssh to connect, you can\n\
      \032  ignore this window). When your password is requested, you'll need to\n\
      \032  activate the console window (e.g., by clicking in it) before typing.\n\
      \032  If you start Unison from a DOS window, Unison's regular window will\n\
      \032  appear and you will type your password in the DOS window you were\n\
      \032  using.\n\
      \032  \n\
      \032  To use Unison in this mode, you must first create a profile (see the\n\
      \032  section ``Profile'' ). Use your favorite editor for this.\n\
      \032  \n\
      "))
::
    ("", ("Advice", 
     "Advice\n\
      \n\
      "))
::
    ("faq", ("Frequently Asked Questions", 
     "\032 Frequently Asked Questions\n\
      \032 \n\
      \032  (See the section ``Common Problems'' and the section ``Tips and\n\
      \032  Tricks'' for further suggestions.)\n\
      \032  \n\
      \032    * What are the differences between Unison and rsync?\n\
      \032      Rsync is a mirroring tool; Unison is a synchronizer. That is,\n\
      \032      rsync needs to be told ``this replica contains the true versions\n\
      \032      of all the files; please make the other replica look exactly the\n\
      \032      same.'' Unison is capable of recognizing updates in both replicas\n\
      \032      and deciding which way they should be propagated.\n\
      \032      Both Unison and rsync use the so-called ``rsync algorithm,'' by\n\
      \032      Andrew Tridgell and Paul Mackerras, for performing updates. This\n\
      \032      algorithm streamlines updates in small parts of large files by\n\
      \032      transferring only the parts that have changed.\n\
      \032    * What are the differences between Unison and CVS?\n\
      \032      Both CVS and Unison can be used to keep a remote replica of a\n\
      \032      directory structure up to date with a central repository. Both are\n\
      \032      capable of propagating updates in both directions and recognizing\n\
      \032      conflicting updates. Both use the rsync protocol for file\n\
      \032      transfer.\n\
      \032      Unison's main advantage is being somewhat more automatic and\n\
      \032      easier to use, especially on large groups of files. CVS requires\n\
      \032      manual notification whenever files are added or deleted. Moving\n\
      \032      files is a bit tricky. And if you decide to move a directory...\n\
      \032      well, heaven help you.\n\
      \032      CVS, on the other hand, is a full-blown version control system,\n\
      \032      and it has lots of other features (version history, multiple\n\
      \032      branches, etc.) that Unison (which is just a file synchronizer)\n\
      \032      doesn't have.\n\
      \032    * Is it OK to mount my remote filesystem using NFS and run unison\n\
      \032      locally, or should I run a remote server process?\n\
      \032      NFS-mounting the replicas is fine, as long as the local network is\n\
      \032      fast enough. Unison needs to read a lot of files (in particular,\n\
      \032      it needs to check the last-modified time of every file in the\n\
      \032      repository every time it runs), so if the link bandwidth is low\n\
      \032      then running a remote server is much better.\n\
      \032    * When I run Unison on Windows, it creates two different windows,\n\
      \032      the main user interface and a blank console window. Is there any\n\
      \032      way to get rid of the second one?\n\
      \032      The extra console window is there for ssh to use to get your\n\
      \032      password. Unfortunately, in the present version of unison the\n\
      \032      window will appear whether you're using ssh or not.\n\
      \032      Karl Moerder contributed some scripts that he uses to make the\n\
      \032      command window a bit more attractive. He starts unison from a\n\
      \032      shortcut to a .cmd file. This lets him control the attributes of\n\
      \032      the command window, making it small and gray and centering the\n\
      \032      passphrase request. His scripts can be found at\n\
      \032      http://www.cis.upenn.edu/~bcpierce/unison/download/resources/karls\n\
      \032      -winhax.zip.\n\
      \032      It is also possible to get rid of the window entirely (for users\n\
      \032      that only want socket mode connections) by playing games with\n\
      \032      icons. If you make a symbolic link to the executable, you can edit\n\
      \032      the properties box to make this window come up iconic. That way\n\
      \032      when you click on the link, you seem to just get a unison window\n\
      \032      (except on the task bar, where the text window shows).\n\
      \032    * Will unison behave correctly if used transitively? That is, if I\n\
      \032      synchronize both between host1:dir and host2:dir and between\n\
      \032      host2:dir and host3:dir at different times? Are there any problems\n\
      \032      if the ``connectivity graph'' has loops?\n\
      \032      This mode of usage will work fine. As far as each ``host pair'' is\n\
      \032      concerned, filesystem updates made by Unison when synchronizing\n\
      \032      any other pairs of hosts are exactly the same as ordinary user\n\
      \032      changes to the filesystem. So if a file started out having been\n\
      \032      modified on just one machine, then every time Unison is run on a\n\
      \032      pair of hosts where one has heard about the change and the other\n\
      \032      hasn't will result in the change being propagated to the other\n\
      \032      host. Running unison between machines where both have already\n\
      \032      heard about the change will leave that file alone. So, no matter\n\
      \032      what the connectivity graph looks like (as long as it is not\n\
      \032      partitioned), eventually everyone will agree on the new value of\n\
      \032      the file.\n\
      \032      The only thing to be careful of is changing the file again on the\n\
      \032      first machine (or, in fact, any other machine) before all the\n\
      \032      machines have heard about the first change -- this can result in\n\
      \032      Unison reporting conflicting changes to the file, which you'll\n\
      \032      then have to resolve by hand.\n\
      \032    * What will happen if I try to synchronize a special file (e.g.,\n\
      \032      something in /dev, /proc, etc.)?\n\
      \032      Unison will refuse to synchronize such files. It only understands\n\
      \032      ordinary files, directories, and symlinks.\n\
      \032    * Is it OK to run several copies of Unison concurrently?\n\
      \032      Unison is built to handle this case, but this functionality has\n\
      \032      not been extensively tested. Keep your eyes open.\n\
      \032    * What will happen if I do a local (or NFS, etc.) sync and some file\n\
      \032      happens to be part of both replicas?\n\
      \032      It will look to Unison as though somebody else has been modifying\n\
      \032      the files it is trying to synchronize, and it will fail (safely)\n\
      \032      on these files.\n\
      \032    * What happens if Unison gets killed while it is working? Do I have\n\
      \032      to kill it nicely, or can I use kill -9? What if the network goes\n\
      \032      down during a synchronization? What if one machine crashes but the\n\
      \032      other keeps running?\n\
      \032      Don't worry; be happy. See the section ``Invariants'' .\n\
      \032    * What about race conditions when both Unison and some other program\n\
      \032      or user are both trying to write to a file at exactly the same\n\
      \032      moment?\n\
      \032      Unison works hard to make these ``windows of danger'' as short as\n\
      \032      possible, but they cannot be eliminated completely.\n\
      \032    * The Unix file locking mechanism doesn't work very well under NFS.\n\
      \032      Is this a problem for Unison?\n\
      \032      No.\n\
      \032    * On Windows systems, it looks like the root preferences are\n\
      \032      specified using backslashes, but path and ignore preferences are\n\
      \032      specified with forward slashes. What's up with that?\n\
      \032      Unison uses two sorts of paths: native filesystem paths, which use\n\
      \032      the syntax of the host filesystem, and ``portable'' paths relative\n\
      \032      to the roots of the replicas, which always use / to separate the\n\
      \032      path components. Roots are native filesystem paths; the others are\n\
      \032      root-relative.\n\
      \032      \n\
      "))
::
    ("problems", ("Common Problems", 
     "\032 Common Problems\n\
      \032 \n\
      \032  If you're having problems with Unison, the suggestions in this section\n\
      \032  may help.\n\
      \032  \n\
      \032  A general recommendation is that, if you've gotten into a state you\n\
      \032  don't understand, deleting the archive files on both replicas (files\n\
      \032  with names like arNNNNNNNNNNNNNNN in the .unison directory) will\n\
      \032  return you to a blank slate. If the replicas are identical, then\n\
      \032  deleting the archives is always safe. If they are not identical, then\n\
      \032  deleting the archives will cause all files that exist on one side but\n\
      \032  not the other to be copied, and will report conflicts for all\n\
      \032  non-identical files that do exist on both sides.\n\
      \032  \n\
      \032  (If you think the behavior you're observing is an actual bug, then you\n\
      \032  might consider moving the archives to somewhere else instead of\n\
      \032  deleting them, so that you can try to replicate the bad behavior and\n\
      \032  tell us what more clearly happened.)\n\
      \032  \n\
      \032    * The text mode user interface fails with ``Uncaught exception\n\
      \032      Sys_blocked_io'' when running over ssh2.\n\
      \032      The problem here is that ssh2 puts its standard file descriptors\n\
      \032      into non-blocking mode. But unison and ssh share the same stderr\n\
      \032      (so that error messages from the server are displayed), and the\n\
      \032      nonblocking setting interferes with Unison's interaction with the\n\
      \032      user. This can be corrected by redirecting the stderr when\n\
      \032      invoking Unison:\n\
      \n\
      \032    unison -ui text <other args> 2>/dev/tty\n\
      \032      (The redirection syntax is a bit shell-specific. On some shells,\n\
      \032      e.g., csh and tcsh, you may need to write\n\
      \n\
      \032  unison -ui text <other args>  > & /dev/tty\n\
      \032      instead.)\n\
      \032    * What does the following mean?\n\
      \n\
      \032   Propagating updates [accounting/fedscwh3qt2000.wb3]\n\
      \032   failed: error in renaming locally:\n\
      \032   /DANGER.README: permission denied\n\
      \032      It means that unison is having trouble creating the temporary file\n\
      \032      DANGER.README, which it uses as a \"commit log\" for operations\n\
      \032      (such as renaming its temporary file\n\
      \032      accounting/fedscwh3qt2000.wb3.unison.tmp to the real location\n\
      \032      accounting/fedscwh3qt2000.wb3) that may leave the filesystem in a\n\
      \032      bad state if they are interrupted in the middle. This is pretty\n\
      \032      unlikely, since the rename operation happens fast, but it is\n\
      \032      possible; if it happens, the commit log will be left around and\n\
      \032      Unison will notice (and tell you) the next time it runs that the\n\
      \032      consistency of that file needs to be checked.\n\
      \032      The specific problem here is that Unison is trying to create\n\
      \032      DANGER.README in the directory specified by your HOME environment\n\
      \032      variable, which seems to be set to /, where you do not have write\n\
      \032      permission.\n\
      \032    * The command line\n\
      \n\
      \032    unison work ssh://remote.dcs.ed.ac.uk/work\n\
      \032      fails, with ``fatal error: could not connect to server.'' But when\n\
      \032      I connect directly with ssh remote.dcs.ed.ac.uk/work, I see that\n\
      \032      my PATH variable is correctly set, and the unison executable is\n\
      \032      found. \n\
      \032      In the first case, Unison is using ssh to execute a command, and\n\
      \032      in the second, it is giving you an interactive remote shell. Under\n\
      \032      some ssh configurations, these two use different startup\n\
      \032      sequences. You can test whether this is the problem here by\n\
      \032      trying, e.g.,\n\
      \n\
      \032   ssh remote.dcs.ed.ac.uk 'echo $PATH'\n\
      \032      and seeing whether your PATH is the same as when you do\n\
      \n\
      \032   ssh remote.dcs.ed.ac.uk\n\
      \032   [give password and wait for connection]\n\
      \032   echo $PATH\n\
      \032      This seems to be controlled by the configuration of ssh, but we\n\
      \032      have not understood all the details---if someone does, please let\n\
      \032      us know.\n\
      \032    * I'm having trouble getting unison working with openssh under\n\
      \032      Windows. Any suggestions? Antony Courtney\n\
      \032      (http://www.apocalypse.org/pub/u/antony) contributed the following\n\
      \032      comment.\n\
      \032      \n\
      \032    I ran in to some difficulties trying to use this ssh client with\n\
      \032    Unison, and tracked down at least one of the problems. I thought\n\
      \032    I'd share my experiences, and provide a 'known good' solution for\n\
      \032    other users who might want to use this Windows / Unison / ssh /\n\
      \032    Cygwin combination. If you launch Unison from bash, it fails (at\n\
      \032    least for me). Running unison_win32-gtkui.exe, I get a dialog box\n\
      \032    that reads:\n\
      \n\
      \032       Fatal error: Error in checkServer: Broken pipe [read()]\n\
      \n\
      \032    and a message is printed to stderr in the bash window that reads:\n\
      \032       ssh: unison_win32-gtkui.exe: no address associated with hostname.\n\
      \n\
      \032    My guess is that this is caused by some incompatibility between the\n\
      \032    Ocaml Win32 library routines and Cygwin with regard to setting up\n\
      \032    argv[] for child processes.\n\
      \032      The solution is to launch Unison from a DOS command prompt\n\
      \032      instead; or see section [3]5.18.\n\
      \032    * When I use ssh to log into the server, everything looks fine (and\n\
      \032      I can see the Unison binary in my path). But when I do 'ssh\n\
      \032      <server> unison' it fails. Why?\n\
      \032      [Thanks to Nick Phillips for the following explanation.]\n\
      \032      It's simple. If you start ssh, enter your password etc. and then\n\
      \032      end up in a shell, you have a login shell.\n\
      \032      If you do \"ssh myhost.com unison\" then unison is not run in a\n\
      \032      login shell.\n\
      \032      This means that different shell init scripts are used, and most\n\
      \032      people seem to have their shell init scripts set up all wrong.\n\
      \032      With bash, for example, your .bash_profile only gets used if you\n\
      \032      start a login shell. This usually means that you've logged in on\n\
      \032      the system console, on a terminal, or remotely. If you start an\n\
      \032      xterm from the command line you won't get a login shell in it. If\n\
      \032      you start a command remotely from the ssh or rsh command line you\n\
      \032      also won't get a login shell to run it in (this is of course a\n\
      \032      Good Thing -- you may want to run interactive commands from it,\n\
      \032      for example to ask what type of terminal they're using today).\n\
      \032      If people insist on setting their PATH in their .bash_profile,\n\
      \032      then they should probably do at least one of the following:\n\
      \032        1. stop it;\n\
      \032        2. read the bash manual, section \"INVOCATION\";\n\
      \032        3. set their path in their .bashrc;\n\
      \032        4. get their sysadmin to set a sensible system-wide default\n\
      \032           path;\n\
      \032        5. source their .bash_profile from their .bashrc ...\n\
      \032      It's pretty similar for most shells.\n\
      \032    * Unison crashes with an ``out of memory'' error when used to\n\
      \032      synchronize really huge directories (e.g., with hundreds of\n\
      \032      thousands of files).\n\
      \032      You may need to increase your maximum stack size. On Linux and\n\
      \032      Solaris systems, for example, you can do this using the ulimit\n\
      \032      command (see the bash documentation for details).\n\
      \032    * Unison seems to be unable to copy a single really huge file. I get\n\
      \032      something like this:\n\
      \n\
      \032   Error in querying file information:\n\
      \032   Value too large for defined data type [lstat(...)]\n\
      \032      This is a limitation in the OCaml interface to the Unix system\n\
      \032      calls. (The problem is that the OCaml library uses 32-bit integers\n\
      \032      to represent file positions. The maximal positive 'int' in OCaml\n\
      \032      is about 2.1E9. We hope that the OCaml team will someday provide\n\
      \032      an alternative interface that uses 64-bit integers.\n\
      \032    * Why does unison run so slowly the first time I start it?\n\
      \032      On the first synchronization, unison doesn't have any ``memory''\n\
      \032      of what your replicas used to look like, so it has to go through,\n\
      \032      fingerprint every file, transfer the fingerprints across the\n\
      \032      network, and compare them to what's on the other side. Having done\n\
      \032      this once, it stashes away the information so that in future runs\n\
      \032      almost all of the work can be done locally on each side.\n\
      \032    * I can't seem to override the paths selected in the profile by\n\
      \032      using a -path argument on the command line.\n\
      \032      Right: the path preference is additive (each use adds an entry to\n\
      \032      the list of paths within the replicas that Unison will try to\n\
      \032      synchronize), and there is no way to remove entries once they have\n\
      \032      gotten into this list. The solution is to split your preference\n\
      \032      file into different ``top-level'' files containing different sets\n\
      \032      of path preferences and make them all include a common preference\n\
      \032      file to avoid repeating the non-path preferences. See the section\n\
      \032      ``Profile Examples'' for a complete example.\n\
      \032    * I can't seem to override the roots selected in the profile by\n\
      \032      listing the roots on the command line. I get ``Fatal error: Wrong\n\
      \032      number of roots (2 expected; 4 provided).''\n\
      \032      Roots should be provided either in the preference file or on the\n\
      \032      command line, not both. See the section ``Profile Examples'' for\n\
      \032      further advice.\n\
      \032    * I am trying to compile unison 2.7.7 using OCaml 3.04. I get\n\
      \032      ``Values do not match'' error. Unison 2.7.7 compiles with Ocaml\n\
      \032      3.02. Later versions of OCaml, include version 3.04, require by\n\
      \032      default all parameter labels for function calls if they are\n\
      \032      declared in the interface. Adding the compilation option\n\
      \032      ``-nolabels'' (by inserting a line ``CAMLFLAGS+=-nolabels'' to the\n\
      \032      file named ``Makefile.OCaml'') should solve the problem. To\n\
      \032      compile the graphical user interface for Unison 2.7.7, use LablGtk\n\
      \032      1.1.2 instead of LablGtk 1.1.3.\n\
      \032      \n\
      "))
::
    ("tips", ("Tricks and Tips", 
     "\032 Tricks and Tips\n\
      \032 \n\
      \032    * Is it possible to run Unison from inetd (the Unix internet\n\
      \032      services daemon)?\n\
      \032      We haven't tried this ourselves, but Toby Johnson has contributed\n\
      \032      a detailed chroot min-HOWTO\n\
      \032      (http://www.cis.upenn.edu/~bcpierce/unison/download/resources/xine\n\
      \032      td-chroot-howto.txt) describing how to do it. (Yan Seiner wrote an\n\
      \032      earlier howto\n\
      \032      (http://www.cis.upenn.edu/~bcpierce/unison/download/resources/inet\n\
      \032      d-howto.txt), on which Toby's is based.)\n\
      \032    * Is there a way to get Unison not to prompt me for a password every\n\
      \032      time I run it (e.g., so that I can run it every half hour from a\n\
      \032      shell script)? It's actually ssh that's asking for the password.\n\
      \032      If you're running the Unison client on a Unix system, you should\n\
      \032      check out the 'ssh-agent' facility in ssh. If you do\n\
      \n\
      \032     ssh-agent bash\n\
      \032      (or ssh-agent startx, when you first log in) it will start you a\n\
      \032      shell (or an X Windows session) in which all processes and\n\
      \032      sub-processes are part of the same ssh-authorization group. If,\n\
      \032      inside any shell belonging to this authorization group, you run\n\
      \032      the ssh-add program, it will prompt you once for a password and\n\
      \032      then remember it for the duration of the bash session. You can\n\
      \032      then use Unison over ssh---or even run it repeatedly from a shell\n\
      \032      script---without giving your password again.\n\
      \032      It may also be possible to configure ssh so that it does not\n\
      \032      require any password: just enter an empty password when you create\n\
      \032      a pair of keys. If you think it is safe enough to keep your\n\
      \032      private key unencrypted on your client machine, this solution\n\
      \032      should work even under Windows.\n\
      \032    * Is there a way, under Windows, to click-start Unison and make it\n\
      \032      synchronize according to a particular profile?\n\
      \032      Greg Sullivan sent us the following useful trick:\n\
      \032      \n\
      \032    In order to make syncing a particular profile ``clickable'' from\n\
      \032    the Win98 desktop, when the profile uses ssh, you need to create a\n\
      \032    .bat file that contains nothing but ``unison profile-name''\n\
      \032    (assuming unison.exe is in the PATH). I first tried the ``obvious''\n\
      \032    strategy of creating a shortcut on the desktop with the actual\n\
      \032    command line ``unison profile, but that hangs. The .bat file trick\n\
      \032    works, though, because it runs command.com and then invokes the\n\
      \032    .bat file.\n\
      \032    * Can Unison be used with SSH's port forwarding features?\n\
      \032      Mark Thomas says the following procedure works for him:\n\
      \032      \n\
      \032    After having problems with unison spawning a command line ssh in\n\
      \032    Windows I noticed that unison also supports a socket mode of\n\
      \032    communication (great software!) so I tried the port forwarding\n\
      \032    feature of ssh using a graphical SSH terminal TTSSH:\n\
      \032    \n\
      \032    http://www.zip.com.au/~roca/ttssh.html\n\
      \032    \n\
      \032    To use unison I start TTSHH with port forwarding enabled and login\n\
      \032    to the Linux box where the unison server (unison -socket xxxx) is\n\
      \032    started automatically. In windows I just run unison and connect to\n\
      \032    localhost (unison socket://localhost:xxxx/ ...)\n\
      \032    * How can I use Unison from a laptop whose hostname changes\n\
      \032      depending on where it is plugged into the network?\n\
      \032      See the discussion of the rootalias preference in the section\n\
      \032      ``Archive Files'' .\n\
      \032    * It's annoying that (on Unix systems) I have to type an ssh\n\
      \032      passphrase into a console window, rather than being asked for it\n\
      \032      in a dialog box. Is there a better way?\n\
      \032      We have some ideas about how this might be done (by allocating a\n\
      \032      PTY and using it to talk to ssh), but we haven't implemented them\n\
      \032      yet. If you'd like to have a crack at it, we'd be glad to discuss\n\
      \032      ideas and incorporate patches.\n\
      \032      In the meantime, tmb has contributed a script that uses expectk to\n\
      \032      do what's needed. It's available at\n\
      \032      http://www.cis.upenn.edu/ bcpierce/unison/download/resources/expec\n\
      \032      tk-startup.\n\
      \032      \n\
      "))
::
    ("ssh", ("Installing Ssh", 
     "Installing Ssh\n\
      \n\
      \032  Your local host will need just an ssh client; the remote host needs an\n\
      \032  ssh server (or daemon), which is available on Unix systems.[4]2 Unison\n\
      \032  is known to work with ssh version 1.2.27 (Unix) and version 1.2.14\n\
      \032  (Windows); other versions may or may not work.\n\
      \032  \n\
      \032 Unix\n\
      \032 \n\
      \032   1. Install ssh.\n\
      \032        1. Become root. (If you do not have administrator permissions,\n\
      \032           ask your system manager to install an ssh client and an ssh\n\
      \032           server for you and skip this section.)\n\
      \032        2. Download ssh-1.2.27.tar.gz from ftp://ftp.ssh.com/pub/ssh/.\n\
      \032        3. Install it:\n\
      \032              o Unpack the archive (gunzip ssh-1.2.27.tar.gz and then\n\
      \032                tar xvf ssh-1.2.27.tar.gz).\n\
      \032              o following instructions in INSTALL, enter ./configure,\n\
      \032                make, and make install.\n\
      \032              o to run the ssh daemon:\n\
      \032                   # find the server daemon sshd (e.g.,\n\
      \032                     /usr/local/sbin/sshd on RedHat-Linux systems).\n\
      \032                   # put its full pathname in the system initialization\n\
      \032                     script to have it run at startup (this script is\n\
      \032                     called /etc/rc.d/rc.sysinit on RedHat-Linux, for\n\
      \032                     example).\n\
      \032        4. Once a server is running on the remote host and a client is\n\
      \032           available on the local host, you should be able to connect\n\
      \032           with ssh in the same way as with rsh (e.g., ssh foobar, then\n\
      \032           enter your password).\n\
      \032   2. If you like, you can now set up ssh so that you only need to type\n\
      \032      your password once per X session, rather than every time you run\n\
      \032      Unison (this is not necessary for using ssh with Unison, but it\n\
      \032      saves typing).\n\
      \032        1. Build your keys :\n\
      \032              o enter ssh-keygen and type a passphrase as required.\n\
      \032              o your private key is now in ~/.ssh/identity (this file\n\
      \032                must remain private) and your public key in\n\
      \032                ~/.ssh/identity.pub.\n\
      \032        2. Allow user-mode secure connection.\n\
      \032              o append contents of the local file ~/.ssh/identity.pub to\n\
      \032                the file ~/.ssh/authorized_keys on the remote system.\n\
      \032              o Test that you can connect by starting ssh and giving the\n\
      \032                passphrase you just chose instead of your remote\n\
      \032                password.\n\
      \032        3. Create an agent to manage authentication for you :\n\
      \032              o start ssh-agent with the parent program whose children\n\
      \032                will be granted automatic connections (e.g., ssh-agent\n\
      \032                bash or ssh-agent startx).\n\
      \032              o enter ssh-add to enter your passphrase and enable\n\
      \032                automatic login for connections to come.\n\
      \032              o you should now be able to run Unison using SSH without\n\
      \032                giving any passphrase or password.\n\
      \032              o to kill the agent, enter ssh-agent -k, or simply exit\n\
      \032                the program you launched using ssh-agent.\n\
      \032      \n\
      \032 Windows\n\
      \032 \n\
      \032  Many Windows implementations of ssh only provide graphical interfaces,\n\
      \032  but Unison requires an ssh client that it can invoke with a\n\
      \032  command-line interface. A suitable version of ssh can be installed as\n\
      \032  follows.\n\
      \032  \n\
      \032   1. Download an ssh executable. Warning: there are many\n\
      \032      implementations and ports of ssh for Windows, and not all of them\n\
      \032      will work with Unison. We have gotten Unison to work with Cygwin's\n\
      \032      port of openssh, and we suggest you use that one. Here's how to\n\
      \032      install it:\n\
      \032        1. First, create a new folder on your desktop to hold temporary\n\
      \032           installation files. It can have any name you like, but in\n\
      \032           these instructions we'll assume that you call it Foo.\n\
      \032        2. Direct your web browser to www.cygwin.com, and click on the\n\
      \032           ``Install now!'' link. This will download a file, setup.exe;\n\
      \032           save it in the directory Foo. The file setup.exe is a small\n\
      \032           program that will download the actual install files from the\n\
      \032           Internet when you run it.\n\
      \032        3. Start setup.exe (by double-clicking). This brings up a series\n\
      \032           of dialogs that you will have to go through. Select ``Install\n\
      \032           from Internet.'' For ``Local Package Directory'' select the\n\
      \032           directory Foo. For ``Select install root directory'' we\n\
      \032           recommend that you use the default, C:\\cygwin. The next\n\
      \032           dialog asks you to select the way that you want to connect to\n\
      \032           the network to download the installation files; we have used\n\
      \032           ``Use IE5 Settings'' successfully, but you may need to make a\n\
      \032           different selection depending on your networking setup. The\n\
      \032           next dialog gives a list of mirrors; select one close to you.\n\
      \032           Next you are asked to select which packages to install. The\n\
      \032           default settings in this dialog download a lot of packages\n\
      \032           that are not strictly necessary to run Unison with ssh. If\n\
      \032           you don't want to install a package, click on it until\n\
      \032           ``skip'' is shown. For a minimum installation, select only\n\
      \032           the packages ``cygwin'' and ``openssh,'' which come to about\n\
      \032           1900KB; the full installation is much larger.\n\
      \032           \n\
      \032    Note that you are plan to build unison using the free CygWin GNU C\n\
      \032    compiler, you need to install essential development packages such\n\
      \032    as ``gcc'', ``make'', ``fileutil'', etc; we refer to the file\n\
      \032    ``INSTALL.win32-cygwin-gnuc'' in the source distribution for\n\
      \032    further details. \n\
      \032           After the packages are downloaded and installed, the next\n\
      \032           dialog allows you to choose whether to ``Create Desktop\n\
      \032           Icon'' and ``Add to Start Menu.'' You make the call.\n\
      \032        4. You can now delete the directory Foo and its contents.\n\
      \032   2. You must set the environment variables HOME and PATH. Ssh will\n\
      \032      create a directory .ssh in the directory given by HOME, so that it\n\
      \032      has a place to keep data like your public and private keys. PATH\n\
      \032      must be set to include the Cygwin bin directory, so that Unison\n\
      \032      can find the ssh executable.\n\
      \032         + On Windows 95/98, add the lines\n\
      \n\
      \032   set PATH=%PATH%;<SSHDIR>\n\
      \032   set HOME=<HOMEDIR>\n\
      \032           to the file C:\\AUTOEXEC.BAT, where <HOMEDIR> is the directory\n\
      \032           where you want ssh to create its .ssh directory, and <SSHDIR>\n\
      \032           is the directory where the executable ssh.exe is stored; if\n\
      \032           you've installed Cygwin in the default location, this is\n\
      \032           C:\\cygwin\\bin. You will have to reboot your computer to take\n\
      \032           the changes into account.\n\
      \032         + On Windows NT/2k, open the environment variables dialog box:\n\
      \032              o Windows NT: My Computer/Properties/Environment\n\
      \032              o Windows 2k: My Computer/Properties/Advanced/Environment\n\
      \032                variables\n\
      \032           then select Path and edit its value by appending ;<SSHDIR> to\n\
      \032           it, where <SSHDIR> is the full name of the directory that\n\
      \032           includes the ssh executable; if you've installed Cygwin in\n\
      \032           the default location, this is C:\\cygwin\\bin.\n\
      \032   3. Test ssh from a DOS shell by typing\n\
      \n\
      \032     ssh <remote host> -l <login name>\n\
      \032      You should get a prompt for your password on <remote host>,\n\
      \032      followed by a working connection.\n\
      \032   4. Note that ssh-keygen may not work (fails with ``gethostname: no\n\
      \032      such file or directory'') on some systems. This is OK: you can use\n\
      \032      ssh with your regular password for the remote system.\n\
      \032   5. You should now be able to use Unison with an ssh connection. If\n\
      \032      you are logged in with a different user name on the local and\n\
      \032      remote hosts, provide your remote user name when providing the\n\
      \032      remote root (i.e., //username@host/path...).\n\
      \032      \n\
      "))
::
    ("news", ("Changes in Version 2.9.1", 
     "Changes in Version 2.9.1\n\
      \n\
      \032  Changes since 2.8.19:\n\
      \032    * Fixed a bug due to a wrong assumption\n\
      \032    * Changing profile works again under Windows\n\
      \032    * Fixed a bug due to a wrong assumption\n\
      \032    * fixed the Makefile\n\
      \032      \n\
      \032  Changes since 2.8.1:\n\
      \032    * Statistic window (transfer rate, amount of data transferred). [NB:\n\
      \032      not available Cygwin version.]\n\
      \032    * symlinks works under the cygwin version (which is dynamically\n\
      \032      linked).\n\
      \032    * File movement hack: Unison now tries to use local copy instead of\n\
      \032      transfer for moved or copied files. It is controled by a boolean\n\
      \032      option ``xferbycopying''.\n\
      \032    * Fixed deadlock when synchronizing between Windows and Unix\n\
      \032    * Small improvements:\n\
      \032         + If neither the\n\
      \032           tt USERPROFILE nor the\n\
      \032           tt HOME environment variables are set, then Unison will put\n\
      \032           its temporary commit log (called\n\
      \032           tt DANGER.README) into the directory named by the\n\
      \032           tt UNISON environment variable, if any; otherwise it will use\n\
      \032           tt C:.\n\
      \032         + alternative set of values for fastcheck: yes = true; no =\n\
      \032           false; default = auto.\n\
      \032         + -silent implies -contactquietly\n\
      \032    * Source code:\n\
      \032         + Code reorganization and tidying. (Started breaking up some of\n\
      \032           the basic utility modules so that the non-unison-specific\n\
      \032           stuff can be made available for other projects.)\n\
      \032         + several Makefile and docs changes (for release);\n\
      \032         + further comments in ``update.ml'';\n\
      \032         + connection information are not stored in global variables\n\
      \032           anymore.\n\
      \032      \n\
      \032  Changes since 2.7.78:\n\
      \032    * Small bugfix to textual user interface under Unix (to avoid\n\
      \032      leaving the terminal in a bad state where it would not echo inputs\n\
      \032      after Unison exited).\n\
      \032      \n\
      \032  Changes since 2.7.39:\n\
      \032    * Improvements to the main web page (stable and beta version docs\n\
      \032      are now both accessible).\n\
      \032    * User manual revised.\n\
      \032    * Added some new preferences:\n\
      \032         + ``sshcmd'' and ``rshcmd'' for specifying paths to ssh and rsh\n\
      \032           programs.\n\
      \032         + ``contactquietly'' for suppressing the ``contacting server''\n\
      \032           message during Unison startup (under the graphical UI).\n\
      \032    * Bug fixes:\n\
      \032         + Fixed small bug in UI that neglected to change the displayed\n\
      \032           column headers if loading a new profile caused the roots to\n\
      \032           change.\n\
      \032         + Fixed a bug that would put the text UI into an infinite loop\n\
      \032           if it encountered a conflict when run in batch mode.\n\
      \032         + Added some code to try to fix the display of non-Ascii\n\
      \032           characters in filenames on Windows systems in the GTK UI.\n\
      \032           (This code is currently untested---if you're one of the\n\
      \032           people that had reported problems with display of non-ascii\n\
      \032           filenames, we'd appreciate knowing if this actually fixes\n\
      \032           things.)\n\
      \032         + `-prefer/-force newer' works properly now. (The bug was\n\
      \032           reported by Sebastian Urbaniak and Sean Fulton.)\n\
      \032    * User interface and Unison behavior:\n\
      \032         + Renamed `Proceed' to `Go' in the graphical UI.\n\
      \032         + Added exit status for the textual user interface.\n\
      \032         + Paths that are not synchronized because of conflicts or\n\
      \032           errors during update detection are now noted in the log file.\n\
      \032         + [END] messages in log now use a briefer format\n\
      \032         + Changed the text UI startup sequence so that\n\
      \032           tt ./unison -ui text will use the default profile instead of\n\
      \032           failing.\n\
      \032         + Made some improvements to the error messages.\n\
      \032         + Added some debugging messages to remote.ml.\n\
      \032      \n\
      \032  Changes since 2.7.7:\n\
      \032    * Incorporated, once again, a multi-threaded transport sub-system.\n\
      \032      It transfers several files at the same time, thereby making much\n\
      \032      more effective use of available network bandwidth. Unlike the\n\
      \032      earlier attempt, this time we do not rely on the native thread\n\
      \032      library of OCaml. Instead, we implement a light-weight,\n\
      \032      non-preemptive multi-thread library in OCaml directly. This\n\
      \032      version appears stable.\n\
      \032      Some adjustments to unison are made to accommodate the\n\
      \032      multi-threaded version. These include, in particular, changes to\n\
      \032      the user interface and logging, for example:\n\
      \032         + Two log entries for each transferring task, one for the\n\
      \032           beginning, one for the end.\n\
      \032         + Suppressed warning messages against removing temp files left\n\
      \032           by a previous unison run, because warning does not work\n\
      \032           nicely under multi-threading. The temp file names are made\n\
      \032           less likely to coincide with the name of a file created by\n\
      \032           the user. They take the form\n\
      \032           .#<filename>.<serial>.unison.tmp.\n\
      \032    * Added a new command to the GTK user interface: pressing 'f' causes\n\
      \032      Unison to start a new update detection phase, using as paths just\n\
      \032      those paths that have been detected as changed and not yet marked\n\
      \032      as successfully completed. Use this command to quickly restart\n\
      \032      Unison on just the set of paths still needing attention after a\n\
      \032      previous run.\n\
      \032    * Made the ignorecase preference user-visible, and changed the\n\
      \032      initialization code so that it can be manually set to true, even\n\
      \032      if neither host is running Windows. (This may be useful, e.g.,\n\
      \032      when using Unison running on a Unix system with a FAT volume\n\
      \032      mounted.)\n\
      \032    * Small improvements and bug fixes:\n\
      \032         + Errors in preference files now generate fatal errors rather\n\
      \032           than warnings at startup time. (I.e., you can't go on from\n\
      \032           them.) Also, we fixed a bug that was preventing these\n\
      \032           warnings from appearing in the text UI, so some users who\n\
      \032           have been running (unsuspectingly) with garbage in their\n\
      \032           prefs files may now get error reports.\n\
      \032         + Error reporting for preference files now provides file name\n\
      \032           and line number.\n\
      \032         + More intelligible message in the case of identical change to\n\
      \032           the same files: ``Nothing to do: replicas have been changed\n\
      \032           only in identical ways since last sync.''\n\
      \032         + Files with prefix '.#' excluded when scanning for preference\n\
      \032           files.\n\
      \032         + Rsync instructions are send directly instead of first\n\
      \032           marshaled.\n\
      \032         + Won't try forever to get the fingerprint of a continuously\n\
      \032           changing file: unison will give up after certain number of\n\
      \032           retries.\n\
      \032         + Other bug fixes, including the one reported by Peter Selinger\n\
      \032           (force=older preference not working).\n\
      \032    * Compilation:\n\
      \032         + Upgraded to the new OCaml 3.04 compiler, with the LablGtk\n\
      \032           1.2.3 library (patched version used for compiling under\n\
      \032           Windows).\n\
      \032         + Added the option to compile unison on the Windows platform\n\
      \032           with Cygwin GNU C compiler. This option only supports\n\
      \032           building dynamically linked unison executables.\n\
      \032      \n\
      \032  Changes since 2.7.4:\n\
      \032    * Fixed a silly (but debilitating) bug in the client startup\n\
      \032      sequence.\n\
      \032      \n\
      \032  Changes since 2.7.1:\n\
      \032    * Added addprefsto preference, which (when set) controls which\n\
      \032      preference file new preferences (e.g. new ignore patterns) are\n\
      \032      added to.\n\
      \032    * Bug fix: read the initial connection header one byte at a time, so\n\
      \032      that we don't block if the header is shorter than expected. (This\n\
      \032      bug did not affect normal operation --- it just made it hard to\n\
      \032      tell when you were trying to use Unison incorrectly with an old\n\
      \032      version of the server, since it would hang instead of giving an\n\
      \032      error message.)\n\
      \032      \n\
      \032  Changes since 2.6.59:\n\
      \032    * Changed fastcheck from a boolean to a string preference. Its legal\n\
      \032      values are yes (for a fast check), no (for a safe check), or\n\
      \032      default (for a fast check---which also happens to be safe---when\n\
      \032      running on Unix and a safe check when on Windows). The default is\n\
      \032      default.\n\
      \032    * Several preferences have been renamed for consistency. All\n\
      \032      preference names are now spelled out in lowercase. For backward\n\
      \032      compatibility, the old names still work, but they are not\n\
      \032      mentioned in the manual any more.\n\
      \032    * The temp files created by the 'diff' and 'merge' commands are now\n\
      \032      named by prepending a new prefix to the file name, rather than\n\
      \032      appending a suffix. This should avoid confusing diff/merge\n\
      \032      programs that depend on the suffix to guess the type of the file\n\
      \032      contents.\n\
      \032    * We now set the keepalive option on the server socket, to make sure\n\
      \032      that the server times out if the communication link is\n\
      \032      unexpectedly broken.\n\
      \032    * Bug fixes:\n\
      \032         + When updating small files, Unison now closes the destination\n\
      \032           file.\n\
      \032         + File permissions are properly updated when the file is behind\n\
      \032           a followed link.\n\
      \032         + Several other small fixes.\n\
      \032      \n\
      \032  Changes since 2.6.38:\n\
      \032    * Major Windows performance improvement!\n\
      \032      We've added a preference fastcheck that makes Unison look only at\n\
      \032      a file's creation time and last-modified time to check whether it\n\
      \032      has changed. This should result in a huge speedup when checking\n\
      \032      for updates in large replicas.\n\
      \032      When this switch is set, Unison will use file creation times as\n\
      \032      'pseudo inode numbers' when scanning Windows replicas for updates,\n\
      \032      instead of reading the full contents of every file. This may cause\n\
      \032      Unison to miss propagating an update if the create time,\n\
      \032      modification time, and length of the file are all unchanged by the\n\
      \032      update (this is not easy to achieve, but it can be done). However,\n\
      \032      Unison will never overwrite such an update with a change from the\n\
      \032      other replica, since it always does a safe check for updates just\n\
      \032      before propagating a change. Thus, it is reasonable to use this\n\
      \032      switch most of the time and occasionally run Unison once with\n\
      \032      fastcheck set to false, if you are worried that Unison may have\n\
      \032      overlooked an update.\n\
      \032      Warning: This change is has not yet been thoroughly field-tested.\n\
      \032      If you set the fastcheck preference, pay careful attention to what\n\
      \032      Unison is doing.\n\
      \032    * New functionality: centralized backups and merging\n\
      \032         + This version incorporates two pieces of major new\n\
      \032           functionality, implemented by Sylvain Roy during a summer\n\
      \032           internship at Penn: a centralized backup facility that keeps\n\
      \032           a full backup of (selected files in) each replica, and a\n\
      \032           merging feature that allows Unison to invoke an external\n\
      \032           file-merging tool to resolve conflicting changes to\n\
      \032           individual files.\n\
      \032         + Centralized backups:\n\
      \032              o Unison now maintains full backups of the\n\
      \032                last-synchronized versions of (some of) the files in\n\
      \032                each replica; these function both as backups in the\n\
      \032                usual sense and as the ``common version'' when invoking\n\
      \032                external merge programs.\n\
      \032              o The backed up files are stored in a directory\n\
      \032                /.unison/backup on each host. (The name of this\n\
      \032                directory can be changed by setting the environment\n\
      \032                variable UNISONBACKUPDIR.)\n\
      \032              o The predicate backup controls which files are actually\n\
      \032                backed up: giving the preference 'backup = Path *'\n\
      \032                causes backing up of all files.\n\
      \032              o Files are added to the backup directory whenever unison\n\
      \032                updates its archive. This means that\n\
      \032                   # When unison reconstructs its archive from scratch\n\
      \032                     (e.g., because of an upgrade, or because the\n\
      \032                     archive files have been manually deleted), all\n\
      \032                     files will be backed up.\n\
      \032                   # Otherwise, each file will be backed up the first\n\
      \032                     time unison propagates an update for it.\n\
      \032              o The preference backupversions controls how many previous\n\
      \032                versions of each file are kept. The default is 2 (i.e.,\n\
      \032                the last synchronized version plus one backup).\n\
      \032              o For backward compatibility, the backups preference is\n\
      \032                also still supported, but backup is now preferred.\n\
      \032              o It is OK to manually delete files from the backup\n\
      \032                directory (or to throw away the directory itself).\n\
      \032                Before unison uses any of these files for anything\n\
      \032                important, it checks that its fingerprint matches the\n\
      \032                one that it expects.\n\
      \032         + Merging:\n\
      \032              o Both user interfaces offer a new 'merge' command,\n\
      \032                invoked by pressing 'm' (with a changed file selected).\n\
      \032              o The actual merging is performed by an external program.\n\
      \032                The preferences merge and merge2 control how this\n\
      \032                program is invoked. If a backup exists for this file\n\
      \032                (see the backup preference), then the merge preference\n\
      \032                is used for this purpose; otherwise merge2 is used. In\n\
      \032                both cases, the value of the preference should be a\n\
      \032                string representing the command that should be passed to\n\
      \032                a shell to invoke the merge program. Within this string,\n\
      \032                the special substrings CURRENT1, CURRENT2, NEW, and OLD\n\
      \032                may appear at any point. Unison will substitute these as\n\
      \032                follows before invoking the command:\n\
      \032                   # CURRENT1 is replaced by the name of the local copy\n\
      \032                     of the file;\n\
      \032                   # CURRENT2 is replaced by the name of a temporary\n\
      \032                     file, into which the contents of the remote copy of\n\
      \032                     the file have been transferred by Unison prior to\n\
      \032                     performing the merge;\n\
      \032                   # NEW is replaced by the name of a temporary file\n\
      \032                     that Unison expects to be written by the merge\n\
      \032                     program when it finishes, giving the desired new\n\
      \032                     contents of the file; and\n\
      \032                   # OLD is replaced by the name of the backed up copy\n\
      \032                     of the original version of the file (i.e., its\n\
      \032                     state at the end of the last successful run of\n\
      \032                     Unison), if one exists (applies only to merge, not\n\
      \032                     merge2).\n\
      \032                For example, on Unix systems setting the merge\n\
      \032                preference to\n\
      \n\
      \032  merge = diff3 -m CURRENT1 OLD CURRENT2 > NEW\n\
      \032                will tell Unison to use the external diff3 program for\n\
      \032                merging.\n\
      \032                A large number of external merging programs are\n\
      \032                available. For example, emacs users may find the\n\
      \032                following convenient:\n\
      \n\
      \032   merge2 = emacs -q --eval '(ediff-merge-files \"CURRENT1\" \"CURRENT2\"\n\
      \032              nil \"NEW\")'\n\
      \032   merge = emacs -q --eval '(ediff-merge-files-with-ancestor\n\
      \032              \"CURRENT1\" \"CURRENT2\" \"OLD\" nil \"NEW\")'\n\
      \032                (These commands are displayed here on two lines to avoid\n\
      \032                running off the edge of the page. In your preference\n\
      \032                file, each should be written on a single line.)\n\
      \032              o If the external program exits without leaving any file\n\
      \032                at the path NEW, Unison considers the merge to have\n\
      \032                failed. If the merge program writes a file called NEW\n\
      \032                but exits with a non-zero status code, then Unison\n\
      \032                considers the merge to have succeeded but to have\n\
      \032                generated conflicts. In this case, it attempts to invoke\n\
      \032                an external editor so that the user can resolve the\n\
      \032                conflicts. The value of the editor preference controls\n\
      \032                what editor is invoked by Unison. The default is emacs.\n\
      \032              o Please send us suggestions for other useful values of\n\
      \032                the merge2 and merge preferences -- we'd like to give\n\
      \032                several examples in the manual.\n\
      \032    * Smaller changes:\n\
      \032         + When one preference file includes another, unison no longer\n\
      \032           adds the suffix '.prf' to the included file by default. If a\n\
      \032           file with precisely the given name exists in the .unison\n\
      \032           directory, it will be used; otherwise Unison will add .prf,\n\
      \032           as it did before. (This change means that included preference\n\
      \032           files can be named blah.include instead of blah.prf, so that\n\
      \032           unison will not offer them in its 'choose a preference file'\n\
      \032           dialog.)\n\
      \032         + For Linux systems, we now offer both a statically linked and\n\
      \032           a dynamically linked executable. The static one is larger,\n\
      \032           but will probably run on more systems, since it doesn't\n\
      \032           depend on the same versions of dynamically linked library\n\
      \032           modules being available.\n\
      \032         + Fixed the force and prefer preferences, which were getting\n\
      \032           the propagation direction exactly backwards.\n\
      \032         + Fixed a bug in the startup code that would cause unison to\n\
      \032           crash when the default profile (~/.unison/default.prf) does\n\
      \032           not exist.\n\
      \032         + Fixed a bug where, on the run when a profile is first\n\
      \032           created, Unison would confusingly display the roots in\n\
      \032           reverse order in the user interface.\n\
      \032    * For developers:\n\
      \032         + We've added a module dependency diagram to the source\n\
      \032           distribution, in src/DEPENDENCIES.ps, to help new prospective\n\
      \032           developers with navigating the code.\n\
      \032      \n\
      \032  Changes since 2.6.11:\n\
      \032    * INCOMPATIBLE CHANGE: Archive format has changed.\n\
      \032    * INCOMPATIBLE CHANGE: The startup sequence has been completely\n\
      \032      rewritten and greatly simplified. The main user-visible change is\n\
      \032      that the defaultpath preference has been removed. Its effect can\n\
      \032      be approximated by using multiple profiles, with include\n\
      \032      directives to incorporate common settings. All uses of defaultpath\n\
      \032      in existing profiles should be changed to path.\n\
      \032      Another change in startup behavior that will affect some users is\n\
      \032      that it is no longer possible to specify roots both in the profile\n\
      \032      and on the command line.\n\
      \032      You can achieve a similar effect, though, by breaking your profile\n\
      \032      into two:\n\
      \n\
      \n\
      \032 default.prf =\n\
      \032     root = blah\n\
      \032     root = foo\n\
      \032     include common\n\
      \n\
      \032 common.prf =\n\
      \032     <everything else>\n\
      \032      Now do\n\
      \n\
      \032 unison common root1 root2\n\
      \032      when you want to specify roots explicitly.\n\
      \032    * The -prefer and -force options have been extended to allow users\n\
      \032      to specify that files with more recent modtimes should be\n\
      \032      propagated, writing either -prefer newer or -force newer. (For\n\
      \032      symmetry, Unison will also accept -prefer older or -force older.)\n\
      \032      The -force older/newer options can only be used when -times is\n\
      \032      also set.\n\
      \032      The graphical user interface provides access to these facilities\n\
      \032      on a one-off basis via the Actions menu.\n\
      \032    * Names of roots can now be ``aliased'' to allow replicas to be\n\
      \032      relocated without changing the name of the archive file where\n\
      \032      Unison stores information between runs. (This feature is for\n\
      \032      experts only. See the ``Archive Files'' section of the manual for\n\
      \032      more information.)\n\
      \032    * Graphical user-interface:\n\
      \032         + A new command is provided in the Synchronization menu for\n\
      \032           switching to a new profile without restarting Unison from\n\
      \032           scratch.\n\
      \032         + The GUI also supports one-key shortcuts for commonly used\n\
      \032           profiles. If a profile contains a preference of the form 'key\n\
      \032           = n', where n is a single digit, then pressing this key will\n\
      \032           cause Unison to immediately switch to this profile and begin\n\
      \032           synchronization again from scratch. (Any actions that may\n\
      \032           have been selected for a set of changes currently being\n\
      \032           displayed will be discarded.)\n\
      \032         + Each profile may include a preference 'label = <string>'\n\
      \032           giving a descriptive string that described the options\n\
      \032           selected in this profile. The string is listed along with the\n\
      \032           profile name in the profile selection dialog, and displayed\n\
      \032           in the top-right corner of the main Unison window.\n\
      \032    * Minor:\n\
      \032         + Fixed a bug that would sometimes cause the 'diff' display to\n\
      \032           order the files backwards relative to the main user\n\
      \032           interface. (Thanks to Pascal Brisset for this fix.)\n\
      \032         + On Unix systems, the graphical version of Unison will check\n\
      \032           the DISPLAY variable and, if it is not set, automatically\n\
      \032           fall back to the textual user interface.\n\
      \032         + Synchronization paths (path preferences) are now matched\n\
      \032           against the ignore preferences. So if a path is both\n\
      \032           specified in a path preference and ignored, it will be\n\
      \032           skipped.\n\
      \032         + Numerous other bugfixes and small improvements.\n\
      \032      \n\
      \032  Changes since 2.6.1:\n\
      \032    * The synchronization of modification times has been disabled for\n\
      \032      directories.\n\
      \032    * Preference files may now include lines of the form include <name>,\n\
      \032      which will cause name.prf to be read at that point.\n\
      \032    * The synchronization of permission between Windows and Unix now\n\
      \032      works properly.\n\
      \032    * A binding CYGWIN=binmode in now added to the environment so that\n\
      \032      the Cygwin port of OpenSSH works properly in a non-Cygwin context.\n\
      \032    * The servercmd and addversionno preferences can now be used\n\
      \032      together: -addversionno appends an appropriate -NNN to the server\n\
      \032      command, which is found by using the value of the -servercmd\n\
      \032      preference if there is one, or else just unison.\n\
      \032    * Both '-pref=val' and '-pref val' are now allowed for boolean\n\
      \032      values. (The former can be used to set a preference to false.)\n\
      \032    * Lot of small bugs fixed.\n\
      \032      \n\
      \032  Changes since 2.5.31:\n\
      \032    * The log preference is now set to true by default, since the log\n\
      \032      file seems useful for most users.\n\
      \032    * Several miscellaneous bugfixes (most involving symlinks).\n\
      \032      \n\
      \032  Changes since 2.5.25:\n\
      \032    * INCOMPATIBLE CHANGE: Archive format has changed (again).\n\
      \032    * Several significant bugs introduced in 2.5.25 have been fixed.\n\
      \032      \n\
      \032  Changes since 2.5.1:\n\
      \032    * INCOMPATIBLE CHANGE: Archive format has changed. Make sure you\n\
      \032      synchronize your replicas before upgrading, to avoid spurious\n\
      \032      conflicts. The first sync after upgrading will be slow.\n\
      \032    * New functionality:\n\
      \032         + Unison now synchronizes file modtimes, user-ids, and\n\
      \032           group-ids.\n\
      \032           These new features are controlled by a set of new\n\
      \032           preferences, all of which are currently false by default.\n\
      \032              o When the times preference is set to true, file\n\
      \032                modification times are propaged. (Because the\n\
      \032                representations of time may not have the same\n\
      \032                granularity on both replicas, Unison may not always be\n\
      \032                able to make the modtimes precisely equal, but it will\n\
      \032                get them as close as the operating systems involved\n\
      \032                allow.)\n\
      \032              o When the owner preference is set to true, file ownership\n\
      \032                information is synchronized.\n\
      \032              o When the group preference is set to true, group\n\
      \032                information is synchronized.\n\
      \032              o When the numericIds preference is set to true, owner and\n\
      \032                group information is synchronized numerically. By\n\
      \032                default, owner and group numbers are converted to names\n\
      \032                on each replica and these names are synchronized. (The\n\
      \032                special user id 0 and the special group 0 are never\n\
      \032                mapped via user/group names even if this preference is\n\
      \032                not set.)\n\
      \032         + Added an integer-valued preference perms that can be used to\n\
      \032           control the propagation of permission bits. The value of this\n\
      \032           preference is a mask indicating which permission bits should\n\
      \032           be synchronized. It is set by default to 0o1777: all bits but\n\
      \032           the set-uid and set-gid bits are synchronised (synchronizing\n\
      \032           theses latter bits can be a security hazard). If you want to\n\
      \032           synchronize all bits, you can set the value of this\n\
      \032           preference to -1.\n\
      \032         + Added a log preference (default false), which makes Unison\n\
      \032           keep a complete record of the changes it makes to the\n\
      \032           replicas. By default, this record is written to a file called\n\
      \032           unison.log in the user's home directory (the value of the\n\
      \032           HOME environment variable). If you want it someplace else,\n\
      \032           set the logfile preference to the full pathname you want\n\
      \032           Unison to use.\n\
      \032         + Added an ignorenot preference that maintains a set of\n\
      \032           patterns for paths that should definitely not be ignored,\n\
      \032           whether or not they match an ignore pattern. (That is, a path\n\
      \032           will now be ignored iff it matches an ignore pattern and does\n\
      \032           not match any ignorenot patterns.)\n\
      \032    * User-interface improvements:\n\
      \032         + Roots are now displayed in the user interface in the same\n\
      \032           order as they were given on the command line or in the\n\
      \032           preferences file.\n\
      \032         + When the batch preference is set, the graphical user\n\
      \032           interface no longer waits for user confirmation when it\n\
      \032           displays a warning message: it simply pops up an advisory\n\
      \032           window with a Dismiss button at the bottom and keeps on\n\
      \032           going.\n\
      \032         + Added a new preference for controlling how many status\n\
      \032           messages are printed during update detection: statusdepth\n\
      \032           controls the maximum depth for paths on the local machine\n\
      \032           (longer paths are not displayed, nor are non-directory\n\
      \032           paths). The value should be an integer; default is 1.\n\
      \032         + Removed the trace and silent preferences. They did not seem\n\
      \032           very useful, and there were too many preferences for\n\
      \032           controlling output in various ways.\n\
      \032         + The text UI now displays just the default command (the one\n\
      \032           that will be used if the user just types <return>) instead of\n\
      \032           all available commands. Typing ? will print the full list of\n\
      \032           possibilities.\n\
      \032         + The function that finds the canonical hostname of the local\n\
      \032           host (which is used, for example, in calculating the name of\n\
      \032           the archive file used to remember which files have been\n\
      \032           synchronized) normally uses the gethostname operating system\n\
      \032           call. However, if the environment variable\n\
      \032           UNISONLOCALHOSTNAME is set, its value will now be used\n\
      \032           instead. This makes it easier to use Unison in situations\n\
      \032           where a machine's name changes frequently (e.g., because it\n\
      \032           is a laptop and gets moved around a lot).\n\
      \032         + File owner and group are now displayed in the ``detail\n\
      \032           window'' at the bottom of the screen, when unison is\n\
      \032           configured to synchronize them.\n\
      \032    * For hackers:\n\
      \032         + Updated to Jacques Garrigue's new version of lablgtk, which\n\
      \032           means we can throw away our local patched version.\n\
      \032           If you're compiling the GTK version of unison from sources,\n\
      \032           you'll need to update your copy of lablgtk to the developers\n\
      \032           release, available from\n\
      \032           http://wwwfun.kurims.kyoto-u.ac.jp/soft/olabl/lablgtk.html\n\
      \032           (Warning: installing lablgtk under Windows is currently a bit\n\
      \032           challenging.)\n\
      \032         + The TODO.txt file (in the source distribution) has been\n\
      \032           cleaned up and reorganized. The list of pending tasks should\n\
      \032           be much easier to make sense of, for people that may want to\n\
      \032           contribute their programming energies. There is also a\n\
      \032           separate file BUGS.txt for open bugs.\n\
      \032         + The Tk user interface has been removed (it was not being\n\
      \032           maintained and no longer compiles).\n\
      \032         + The debug preference now prints quite a bit of additional\n\
      \032           information that should be useful for identifying sources of\n\
      \032           problems.\n\
      \032         + The version number of the remote server is now checked right\n\
      \032           away during the connection setup handshake, rather than\n\
      \032           later. (Somebody sent a bug report of a server crash that\n\
      \032           turned out to come from using inconsistent versions: better\n\
      \032           to check this earlier and in a way that can't crash either\n\
      \032           client or server.)\n\
      \032         + Unison now runs correctly on 64-bit architectures (e.g. Alpha\n\
      \032           linux). We will not be distributing binaries for these\n\
      \032           architectures ourselves (at least for a while) but if someone\n\
      \032           would like to make them available, we'll be glad to provide a\n\
      \032           link to them.\n\
      \032    * Bug fixes:\n\
      \032         + Pattern matching (e.g. for ignore) is now case-insensitive\n\
      \032           when Unison is in case-insensitive mode (i.e., when one of\n\
      \032           the replicas is on a windows machine).\n\
      \032         + Some people had trouble with mysterious failures during\n\
      \032           propagation of updates, where files would be falsely reported\n\
      \032           as having changed during synchronization. This should be\n\
      \032           fixed.\n\
      \032         + Numerous smaller fixes.\n\
      \032      \n\
      \032  Changes since 2.4.1:\n\
      \032    * Added a number of 'sorting modes' for the user interface. By\n\
      \032      default, conflicting changes are displayed at the top, and the\n\
      \032      rest of the entries are sorted in alphabetical order. This\n\
      \032      behavior can be changed in the following ways:\n\
      \032         + Setting the sortnewfirst preference to true causes newly\n\
      \032           created files to be displayed before changed files.\n\
      \032         + Setting sortbysize causes files to be displayed in increasing\n\
      \032           order of size.\n\
      \032         + Giving the preference sortfirst=<pattern> (where <pattern> is\n\
      \032           a path descriptor in the same format as 'ignore' and 'follow'\n\
      \032           patterns, causes paths matching this pattern to be displayed\n\
      \032           first.\n\
      \032         + Similarly, giving the preference sortlast=<pattern> causes\n\
      \032           paths matching this pattern to be displayed last.\n\
      \032      The sorting preferences are described in more detail in the user\n\
      \032      manual. The sortnewfirst and sortbysize flags can also be accessed\n\
      \032      from the 'Sort' menu in the grpahical user interface.\n\
      \032    * Added two new preferences that can be used to change unison's\n\
      \032      fundamental behavior to make it more like a mirroring tool instead\n\
      \032      of a synchronizer.\n\
      \032         + Giving the preference prefer with argument <root> (by adding\n\
      \032           -prefer <root> to the command line or prefer=<root>) to your\n\
      \032           profile) means that, if there is a conflict, the contents of\n\
      \032           <root> should be propagated to the other replica (with no\n\
      \032           questions asked). Non-conflicting changes are treated as\n\
      \032           usual.\n\
      \032         + Giving the preference force with argument <root> will make\n\
      \032           unison resolve all differences in favor of the given root,\n\
      \032           even if it was the other replica that was changed.\n\
      \032      These options should be used with care! (More information is\n\
      \032      available in the manual.)\n\
      \032    * Small changes:\n\
      \032         + Changed default answer to 'Yes' in all two-button dialogs in\n\
      \032           the graphical interface (this seems more intuitive).\n\
      \032         + The rsync preference has been removed (it was used to\n\
      \032           activate rsync compression for file transfers, but rsync\n\
      \032           compression is now enabled by default).\n\
      \032         + In the text user interface, the arrows indicating which\n\
      \032           direction changes are being propagated are printed\n\
      \032           differently when the user has overridded Unison's default\n\
      \032           recommendation (====> instead of ---->). This matches the\n\
      \032           behavior of the graphical interface, which displays such\n\
      \032           arrows in a different color.\n\
      \032         + Carriage returns (Control-M's) are ignored at the ends of\n\
      \032           lines in profiles, for Windows compatibility.\n\
      \032         + All preferences are now fully documented in the user manual.\n\
      \032      \n\
      \032  Changes since 2.3.12:\n\
      \032    * INCOMPATIBLE CHANGE: Archive format has changed. Make sure you\n\
      \032      synchronize your replicas before upgrading, to avoid spurious\n\
      \032      conflicts. The first sync after upgrading will be slow.\n\
      \032    * New/improved functionality:\n\
      \032         + A new preference -sortbysize controls the order in which\n\
      \032           changes are displayed to the user: when it is set to true,\n\
      \032           the smallest changed files are displayed first. (The default\n\
      \032           setting is false.)\n\
      \032         + A new preference -sortnewfirst causes newly created files to\n\
      \032           be listed before other updates in the user interface.\n\
      \032         + We now allow the ssh protocol to specify a port.\n\
      \032         + Incompatible change: The unison: protocol is deprecated, and\n\
      \032           we added file: and socket:. You may have to modify your\n\
      \032           profiles in the .unison directory. If a replica is specified\n\
      \032           without an explicit protocol, we now assume it refers to a\n\
      \032           file. (Previously \"//saul/foo\" meant to use SSH to connect to\n\
      \032           saul, then access the foo directory. Now it means to access\n\
      \032           saul via a remote file mechanism such as samba; the old\n\
      \032           effect is now achieved by writing ssh://saul/foo.)\n\
      \032         + Changed the startup sequence for the case where roots are\n\
      \032           given but no profile is given on the command line. The new\n\
      \032           behavior is to use the default profile (creating it if it\n\
      \032           does not exist), and temporarily override its roots. The\n\
      \032           manual claimed that this case would work by reading no\n\
      \032           profile at all, but AFAIK this was never true.\n\
      \032         + In all user interfaces, files with conflicts are always\n\
      \032           listed first\n\
      \032         + A new preference 'sshversion' can be used to control which\n\
      \032           version of ssh should be used to connect to the server. Legal\n\
      \032           values are 1 and 2. (Default is empty, which will make unison\n\
      \032           use whatever version of ssh is installed as the default 'ssh'\n\
      \032           command.)\n\
      \032         + The situation when the permissions of a file was updated the\n\
      \032           same on both side is now handled correctly (we used to report\n\
      \032           a spurious conflict)\n\
      \032    * Improvements for the Windows version:\n\
      \032         + The fact that filenames are treated case-insensitively under\n\
      \032           Windows should now be handled correctly. The exact behavior\n\
      \032           is described in the cross-platform section of the manual.\n\
      \032         + It should be possible to synchronize with Windows shares,\n\
      \032           e.g., //host/drive/path.\n\
      \032         + Workarounds to the bug in syncing root directories in\n\
      \032           Windows. The most difficult thing to fix is an ocaml bug:\n\
      \032           Unix.opendir fails on c: in some versions of Windows.\n\
      \032    * Improvements to the GTK user interface (the Tk interface is no\n\
      \032      longer being maintained):\n\
      \032         + The UI now displays actions differently (in blue) when they\n\
      \032           have been explicitly changed by the user from Unison's\n\
      \032           default recommendation.\n\
      \032         + More colorful appearance.\n\
      \032         + The initial profile selection window works better.\n\
      \032         + If any transfers failed, a message to this effect is\n\
      \032           displayed along with 'Synchronization complete' at the end of\n\
      \032           the transfer phase (in case they may have scrolled off the\n\
      \032           top).\n\
      \032         + Added a global progress meter, displaying the percentage of\n\
      \032           total bytes that have been transferred so far.\n\
      \032    * Improvements to the text user interface:\n\
      \032         + The file details will be displayed automatically when a\n\
      \032           conflict is been detected.\n\
      \032         + when a warning is generated (e.g. for a temporary file left\n\
      \032           over from a previous run of unison) Unison will no longer\n\
      \032           wait for a response if it is running in -batch mode.\n\
      \032         + The UI now displays a short list of possible inputs each time\n\
      \032           it waits for user interaction.\n\
      \032         + The UI now quits immediately (rather than looping back and\n\
      \032           starting the interaction again) if the user presses 'q' when\n\
      \032           asked whether to propagate changes.\n\
      \032         + Pressing 'g' in the text user interface will proceed\n\
      \032           immediately with propagating updates, without asking any more\n\
      \032           questions.\n\
      \032    * Documentation and installation changes:\n\
      \032         + The manual now includes a FAQ, plus sections on common\n\
      \032           problems and on tricks contributed by users.\n\
      \032         + Both the download page and the download directory explicitly\n\
      \032           say what are the current stable and beta-test version\n\
      \032           numbers.\n\
      \032         + The OCaml sources for the up-to-the-minute developers'\n\
      \032           version (not guaranteed to be stable, or even to compile, at\n\
      \032           any given time!) are now available from the download page.\n\
      \032         + Added a subsection to the manual describing cross-platform\n\
      \032           issues (case conflicts, illegal filenames)\n\
      \032    * Many small bug fixes and random improvements.\n\
      \032      \n\
      \032  Changes since 2.3.1:\n\
      \032    * Several bug fixes. The most important is a bug in the rsync module\n\
      \032      that would occasionally cause change propagation to fail with a\n\
      \032      'rename' error.\n\
      \032      \n\
      \032  Changes since 2.2:\n\
      \032    * The multi-threaded transport system is now disabled by default.\n\
      \032      (It is not stable enough yet.)\n\
      \032    * Various bug fixes.\n\
      \032    * A new experimental feature:\n\
      \032      The final component of a -path argument may now be the wildcard\n\
      \032      specifier *. When Unison sees such a path, it expands this path on\n\
      \032      the client into into the corresponding list of paths by listing\n\
      \032      the contents of that directory.\n\
      \032      Note that if you use wildcard paths from the command line, you\n\
      \032      will probably need to use quotes or a backslash to prevent the *\n\
      \032      from being interpreted by your shell.\n\
      \032      If both roots are local, the contents of the first one will be\n\
      \032      used for expanding wildcard paths. (Nb: this is the first one\n\
      \032      after the canonization step -- i.e., the one that is listed first\n\
      \032      in the user interface -- not the one listed first on the command\n\
      \032      line or in the preferences file.)\n\
      \032      \n\
      \032  Changes since 2.1:\n\
      \032    * The transport subsystem now includes an implementation by Sylvain\n\
      \032      Gommier and Norman Ramsey of Tridgell and Mackerras's rsync\n\
      \032      protocol. This protocol achieves much faster transfers when only a\n\
      \032      small part of a large file has been changed by sending just diffs.\n\
      \032      This feature is mainly helpful for transfers over slow links---on\n\
      \032      fast local area networks it can actually degrade performance---so\n\
      \032      we have left it off by default. Start unison with the -rsync\n\
      \032      option (or put rsync=true in your preferences file) to turn it on.\n\
      \032    * ``Progress bars'' are now diplayed during remote file transfers,\n\
      \032      showing what percentage of each file has been transferred so far.\n\
      \032    * The version numbering scheme has changed. New releases will now be\n\
      \032      have numbers like 2.2.30, where the second component is\n\
      \032      incremented on every significant public release and the third\n\
      \032      component is the ``patch level.''\n\
      \032    * Miscellaneous improvements to the GTK-based user interface.\n\
      \032    * The manual is now available in PDF format.\n\
      \032    * We are experimenting with using a multi-threaded transport\n\
      \032      subsystem to transfer several files at the same time, making much\n\
      \032      more effective use of available network bandwidth. This feature is\n\
      \032      not completely stable yet, so by default it is disabled in the\n\
      \032      release version of Unison.\n\
      \032      If you want to play with the multi-threaded version, you'll need\n\
      \032      to recompile Unison from sources (as described in the\n\
      \032      documentation), setting the THREADS flag in Makefile.OCaml to\n\
      \032      true. Make sure that your OCaml compiler has been installed with\n\
      \032      the -with-pthreads configuration option. (You can verify this by\n\
      \032      checking whether the file threads/threads.cma in the OCaml\n\
      \032      standard library directory contains the string -lpthread near the\n\
      \032      end.)\n\
      \032      \n\
      \032  Changes since 1.292:\n\
      \032    * Reduced memory footprint (this is especially important during the\n\
      \032      first run of unison, where it has to gather information about all\n\
      \032      the files in both repositories).\n\
      \032    * Fixed a bug that would cause the socket server under NT to fail\n\
      \032      after the client exits.\n\
      \032    * Added a SHIFT modifier to the Ignore menu shortcut keys in GTK\n\
      \032      interface (to avoid hitting them accidentally).\n\
      \032      \n\
      \032  Changes since 1.231:\n\
      \032    * Tunneling over ssh is now supported in the Windows version. See\n\
      \032      the installation section of the manual for detailed instructions.\n\
      \032    * The transport subsystem now includes an implementation of the\n\
      \032      rsync protocol, built by Sylvain Gommier and Norman Ramsey. This\n\
      \032      protocol achieves much faster transfers when only a small part of\n\
      \032      a large file has been changed by sending just diffs. The rsync\n\
      \032      feature is off by default in the current version. Use the -rsync\n\
      \032      switch to turn it on. (Nb. We still have a lot of tuning to do:\n\
      \032      you may not notice much speedup yet.)\n\
      \032    * We're experimenting with a multi-threaded transport subsystem,\n\
      \032      written by Jerome Vouillon. The downloadable binaries are still\n\
      \032      single-threaded: if you want to try the multi-threaded version,\n\
      \032      you'll need to recompile from sources. (Say make THREADS=true.)\n\
      \032      Native thread support from the compiler is required. Use the\n\
      \032      option -threads N to select the maximal number of concurrent\n\
      \032      threads (default is 5). Multi-threaded and single-threaded\n\
      \032      clients/servers can interoperate.\n\
      \032    * A new GTK-based user interface is now available, thanks to Jacques\n\
      \032      Garrigue. The Tk user interface still works, but we'll be shifting\n\
      \032      development effort to the GTK interface from now on.\n\
      \032    * OCaml 3.00 is now required for compiling Unison from sources. The\n\
      \032      modules uitk and myfileselect have been changed to use labltk\n\
      \032      instead of camltk. To compile the Tk interface in Windows, you\n\
      \032      must have ocaml-3.00 and tk8.3. When installing tk8.3, put it in\n\
      \032      c:\\Tcl rather than the suggested c:\\Program Files\\Tcl, and be sure\n\
      \032      to install the headers and libraries (which are not installed by\n\
      \032      default).\n\
      \032    * Added a new -addversionno switch, which causes unison to use\n\
      \032      unison-<currentversionnumber> instead of just unison as the remote\n\
      \032      server command. This allows multiple versions of unison to coexist\n\
      \032      conveniently on the same server: whichever version is run on the\n\
      \032      client, the same version will be selected on the server.\n\
      \032      \n\
      \032  Changes since 1.219:\n\
      \032    * INCOMPATIBLE CHANGE: Archive format has changed. Make sure you\n\
      \032      synchronize your replicas before upgrading, to avoid spurious\n\
      \032      conflicts. The first sync after upgrading will be slow.\n\
      \032    * This version fixes several annoying bugs, including:\n\
      \032         + Some cases where propagation of file permissions was not\n\
      \032           working.\n\
      \032         + umask is now ignored when creating directories\n\
      \032         + directories are create writable, so that a read-only\n\
      \032           directory and its contents can be propagated.\n\
      \032         + Handling of warnings generated by the server.\n\
      \032         + Synchronizing a path whose parent is not a directory on both\n\
      \032           sides is now flagged as erroneous.\n\
      \032         + Fixed some bugs related to symnbolic links and nonexistant\n\
      \032           roots.\n\
      \032              o When a change (deletion or new contents) is propagated\n\
      \032                onto a 'follow'ed symlink, the file pointed to by the\n\
      \032                link is now changed. (We used to change the link itself,\n\
      \032                which doesn't fit our assertion that 'follow' means the\n\
      \032                link is completely invisible)\n\
      \032              o When one root did not exist, propagating the other root\n\
      \032                on top of it used to fail, becuase unison could not\n\
      \032                calculate the working directory into which to write\n\
      \032                changes. This should be fixed.\n\
      \032    * A human-readable timestamp has been added to Unison's archive\n\
      \032      files.\n\
      \032    * The semantics of Path and Name regular expressions now correspond\n\
      \032      better.\n\
      \032    * Some minor improvements to the text UI (e.g. a command for going\n\
      \032      back to previous items)\n\
      \032    * The organization of the export directory has changed --- should be\n\
      \032      easier to find / download things now.\n\
      \032      \n\
      \032  Changes since 1.200:\n\
      \032    * INCOMPATIBLE CHANGE: Archive format has changed. Make sure you\n\
      \032      synchronize your replicas before upgrading, to avoid spurious\n\
      \032      conflicts. The first sync after upgrading will be slow.\n\
      \032    * This version has not been tested extensively on Windows.\n\
      \032    * Major internal changes designed to make unison safer to run at the\n\
      \032      same time as the replicas are being changed by the user.\n\
      \032    * Internal performance improvements.\n\
      \032      \n\
      \032  Changes since 1.190:\n\
      \032    * INCOMPATIBLE CHANGE: Archive format has changed. Make sure you\n\
      \032      synchronize your replicas before upgrading, to avoid spurious\n\
      \032      conflicts. The first sync after upgrading will be slow.\n\
      \032    * A number of internal functions have been changed to reduce the\n\
      \032      amount of memory allocation, especially during the first\n\
      \032      synchronization. This should help power users with very big\n\
      \032      replicas.\n\
      \032    * Reimplementation of low-level remote procedure call stuff, in\n\
      \032      preparation for adding rsync-like smart file transfer in a later\n\
      \032      release.\n\
      \032    * Miscellaneous bug fixes.\n\
      \032      \n\
      \032  Changes since 1.180:\n\
      \032    * INCOMPATIBLE CHANGE: Archive format has changed. Make sure you\n\
      \032      synchronize your replicas before upgrading, to avoid spurious\n\
      \032      conflicts. The first sync after upgrading will be slow.\n\
      \032    * Fixed some small bugs in the interpretation of ignore patterns.\n\
      \032    * Fixed some problems that were preventing the Windows version from\n\
      \032      working correctly when click-started.\n\
      \032    * Fixes to treatment of file permissions under Windows, which were\n\
      \032      causing spurious reports of different permissions when\n\
      \032      synchronizing between windows and unix systems.\n\
      \032    * Fixed one more non-tail-recursive list processing function, which\n\
      \032      was causing stack overflows when synchronizing very large\n\
      \032      replicas.\n\
      \032      \n\
      \032  Changes since 1.169:\n\
      \032    * The text user interface now provides commands for ignoring files.\n\
      \032    * We found and fixed some more non-tail-recursive list processing\n\
      \032      functions. Some power users have reported success with very large\n\
      \032      replicas.\n\
      \032    * INCOMPATIBLE CHANGE: Files ending in .tmp are no longer ignored\n\
      \032      automatically. If you want to ignore such files, put an\n\
      \032      appropriate ignore pattern in your profile.\n\
      \032    * INCOMPATIBLE CHANGE: The syntax of ignore and follow patterns has\n\
      \032      changed. Instead of putting a line of the form\n\
      \n\
      \032                ignore = <regexp>\n\
      \032      in your profile (.unison/default.prf), you should put:\n\
      \n\
      \032                ignore = Regexp <regexp>\n\
      \032      Moreover, two other styles of pattern are also recognized:\n\
      \n\
      \032                ignore = Name <name>\n\
      \032      matches any path in which one component matches <name>, while\n\
      \n\
      \032                ignore = Path <path>\n\
      \032      matches exactly the path <path>.\n\
      \032      Standard ``globbing'' conventions can be used in <name> and\n\
      \032      <path>:\n\
      \032         + a ? matches any single character except /\n\
      \032         + a * matches any sequence of characters not including /\n\
      \032         + [xyz] matches any character from the set {x, y, z }\n\
      \032         + {a,bb,ccc} matches any one of a, bb, or ccc.\n\
      \032      See the user manual for some examples.\n\
      \032      \n\
      \032  Changes since 1.146:\n\
      \032    * Some users were reporting stack overflows when synchronizing huge\n\
      \032      directories. We found and fixed some non-tail-recursive list\n\
      \032      processing functions, which we hope will solve the problem. Please\n\
      \032      give it a try and let us know.\n\
      \032    * Major additions to the documentation.\n\
      \032      \n\
      \032  Changes since 1.142:\n\
      \032    * Major internal tidying and many small bugfixes.\n\
      \032    * Major additions to the user manual.\n\
      \032    * Unison can now be started with no arguments -- it will prompt\n\
      \032      automatically for the name of a profile file containing the roots\n\
      \032      to be synchronized. This makes it possible to start the graphical\n\
      \032      UI from a desktop icon.\n\
      \032    * Fixed a small bug where the text UI on NT was raising a 'no such\n\
      \032      signal' exception.\n\
      \032      \n\
      \032  Changes since 1.139:\n\
      \032    * The precompiled windows binary in the last release was compiled\n\
      \032      with an old OCaml compiler, causing propagation of permissions not\n\
      \032      to work (and perhaps leading to some other strange behaviors we've\n\
      \032      heard reports about). This has been corrected. If you're using\n\
      \032      precompiled binaries on Windows, please upgrade.\n\
      \032    * Added a -debug command line flag, which controls debugging of\n\
      \032      various modules. Say -debug XXX to enable debug tracing for module\n\
      \032      XXX, or -debug all to turn on absolutely everything.\n\
      \032    * Fixed a small bug where the text UI on NT was raising a 'no such\n\
      \032      signal' exception.\n\
      \032      \n\
      \032  Changes since 1.111:\n\
      \032    * INCOMPATIBLE CHANGE: The names and formats of the preference files\n\
      \032      in the .unison directory have changed. In particular:\n\
      \032         + the file ``prefs'' should be renamed to default.prf\n\
      \032         + the contents of the file ``ignore'' should be merged into\n\
      \032           default.prf. Each line of the form REGEXP in ignore should\n\
      \032           become a line of the form ignore = REGEXP in default.prf.\n\
      \032    * Unison now handles permission bits and symbolic links. See the\n\
      \032      manual for details.\n\
      \032    * You can now have different preference files in your .unison\n\
      \032      directory. If you start unison like this\n\
      \n\
      \032            unison profilename\n\
      \032      (i.e. with just one ``anonymous'' command-line argument), then the\n\
      \032      file ~/.unison/profilename.prf will be loaded instead of\n\
      \032      default.prf.\n\
      \032    * Some improvements to terminal handling in the text user interface\n\
      \032    * Added a switch -killServer that terminates the remote server\n\
      \032      process when the unison client is shutting down, even when using\n\
      \032      sockets for communication. (By default, a remote server created\n\
      \032      using ssh/rsh is terminated automatically, while a socket server\n\
      \032      is left running.)\n\
      \032    * When started in 'socket server' mode, unison prints 'server\n\
      \032      started' on stderr when it is ready to accept connections. (This\n\
      \032      may be useful for scripts that want to tell when a socket-mode\n\
      \032      server has finished initalization.)\n\
      \032    * We now make a nightly mirror of our current internal development\n\
      \032      tree, in case anyone wants an up-to-the-minute version to hack\n\
      \032      around with.\n\
      \032    * Added a file CONTRIB with some suggestions for how to help us make\n\
      \032      Unison better.\n\
      \032      \n\
      "))
::
    ("", ("Junk", 
     "Junk\n\
      \032  ___________________________________\n\
      \032  \n\
      \032  [5]1\n\
      \032         If you are compiling Unison 2.7.7 or an earlier version, you\n\
      \032         need to\n\
      \032         \n\
      \032         + insert a line ``CAMLFLAGS+=-nolabels to the file named\n\
      \032           ``Makefile.OCaml'' in the source directory, and\n\
      \032         + install LablGtk 1.1.1 instead of the latest version.\n\
      \032           \n\
      \032  [6]2\n\
      \032         The Cygwin port (the section ``Installing Ssh on Windows'' ) of\n\
      \032         openssh includes a ssh server program for the Windows platform,\n\
      \032         but we have not yet tested Unison with this ssh server.\n\
      \032    _________________________________________________________________\n\
      \032  \n\
      \032    This document was translated from LATEX by [7]HEVEA. \n\
      \n\
      References\n\
      \n\
      \032  1. file://localhost/plclub/zheyang/unison/doc/temp.html#note1\n\
      \032  2. file://localhost/plclub/zheyang/unison/doc/temp.html#ssh-win\n\
      \032  3. file://localhost/plclub/zheyang/unison/doc/temp.html#click\n\
      \032  4. file://localhost/plclub/zheyang/unison/doc/temp.html#note2\n\
      \032  5. file://localhost/plclub/zheyang/unison/doc/temp.html#text1\n\
      \032  6. file://localhost/plclub/zheyang/unison/doc/temp.html#text2\n\
      \032  7. http://para.inria.fr/~maranget/hevea/index.html\n\
      "))
::
    [];;

