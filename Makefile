#######################################################################
# $I1: Unison file synchronizer: src/Makefile $
# $I2: Last modified by zheyang on Thu, 11 Apr 2002 00:39:31 -0400 $
# $I3: Copyright 1999-2002 (see COPYING for details) $
#######################################################################
## User Settings

# User interface style: 
#   Legal values are
#     UISTYLE=text
#   or
#     UISTYLE=tk
#   of
#     UISTYLE=gtk
UISTYLE=gtk

# Set NATIVE=false if you are not using the native code compiler (ocamlopt)
# This is not advised, though: Unison runs much slower when byte-compiled.
#
# If you set NATIVE=false, then make sure that the THREADS option below is
# also set to false unless your OCaml installation has true posix-compliant
# threads (i.e., -with-pthreads was given as an option to the config script).
NATIVE=true

# Use THREADS=false if your OCaml installation is not configured with the
# -with-pthreads option.  (Unison will crash when compiled with THREADS=true
# if the -with-pthreads configuration option was not used.)
THREADS=false

########################################################################
########################################################################
#     (There should be no need to change anything from here on)       ##
########################################################################
########################################################################

## Miscellaneous developer-only switches
DEBUGGING=true
PROFILING=false
STATIC=false

########################################################################
### Project name

# $Format: "NAME=$Project$"$
NAME=unison

########################################################################
### Compilation rules

include Makefile.OCaml

######################################################################
# Building installation instructions

all:: strings.ml buildexecutable

all:: INSTALL 

INSTALL: $(NAME)$(EXEC_EXT)
	./$(NAME) -doc install > INSTALL

######################################################################
# Installation

INSTALLDIR = $(HOME)/bin/

install: $(NAME)$(EXEC_EXT)
	-mv $(INSTALLDIR)/$(NAME)$(EXEC_EXT) /tmp/$(NAME)-$(shell echo $$$$)
	cp $(NAME)$(EXEC_EXT) $(INSTALLDIR)
	cp $(NAME)$(EXEC_EXT) $(INSTALLDIR)$(NAME)-$(VERSION)$(EXEC_EXT)
	@# If we're running at Penn, install a public version too
	if [ -d /plclub/bin ]; then cp $(NAME)$(EXEC_EXT) /plclub/bin/$(NAME)-$(VERSION)$(EXEC_EXT); fi


######################################################################
# Demo

setupdemo-old: all
	-mkdir alice.tmp bob.tmp
	-touch alice.tmp/letter alice.tmp/curriculum
	-mkdir bob.tmp/curriculum
	-touch bob.tmp/curriculum/french
	-touch bob.tmp/curriculum/german
	-mkdir bob.tmp/good_friends
	-mkdir bob.tmp/good_friends/addresses
	-mkdir alice.tmp/good_friends
	-touch alice.tmp/good_friends/addresses
	-touch bob.tmp/good_friends/addresses/alice
	-mkdir alice.tmp/book
	-mkdir bob.tmp/book
	echo "first name:alice \n 2234 Chesnut Street \n Philadelphia" \
	   > bob.tmp/good_friends/addresses/alice
	echo "ADDRESS 1 : BOB \n firstName : bob \n 2233 Walnut Street" \
	   > alice.tmp/good_friends/addresses
	echo "Born in Paris in 1976 ..." > alice.tmp/curriculum
	echo "Ne a Paris en 1976 ..." > bob.tmp/curriculum/french
	echo "Geboren in Paris im jahre 1976 ..." > bob.tmp/curriculum/german
	echo "Dear friend, I received your letter ..."    > alice.tmp/letter
	echo "And then the big bad wolf" > bob.tmp/book/page3
	echo "Title : three little pigs" > alice.tmp/book/page1
	echo "there was upon a time ..." > alice.tmp/book/page2 

setupdemo: 
	rm -rf a.tmp b.tmp
	mkdir a.tmp 
	touch a.tmp/a a.tmp/b a.tmp/c 
	mkdir a.tmp/d
	touch a.tmp/d/f
	touch a.tmp/d/g
	cp -r a.tmp b.tmp

modifydemo: 
	-rm a.tmp/a
	echo "Hello" > a.tmp/b
	echo "Hello" > b.tmp/b
	date > b.tmp/c
	echo "Hi there" > a.tmp/d/h
	echo "Hello there" > b.tmp/d/h

demo: all setupdemo
	@$(MAKE) run
	@$(MAKE) modifydemo
	@$(MAKE) run

run: all
	-mkdir a.tmp b.tmp
	-date > a.tmp/x
	-date > b.tmp/y
	./$(NAME) default a.tmp b.tmp 

runbatch: all
	-mkdir a.tmp b.tmp
	-date > a.tmp/x
	-date > b.tmp/y
	./$(NAME) default a.tmp b.tmp -batch

runt: all
	-mkdir a.tmp b.tmp
	-date > a.tmp/x
	-date > b.tmp/y
	./$(NAME) default a.tmp b.tmp -timers

rundebug: all
	-date > a.tmp/x
	-date > b.tmp/y
	./$(NAME) a.tmp b.tmp -debug all  -ui text

runp: all
	-echo cat > a.tmp/cat
	-echo cat > b.tmp/cat
	-chmod 765 a.tmp/cat
	-chmod 700 b.tmp/cat
	./$(NAME) a.tmp b.tmp 

runtext: all
	-mkdir a.tmp b.tmp
	-date > a.tmp/x
	-date > b.tmp/y
	./$(NAME) -ui text a.tmp b.tmp 

runsort: all
	-mkdir a.tmp b.tmp
	-date > a.tmp/b
	-date > b.tmp/m
	-date > b.tmp/z
	-date > b.tmp/f
	-date >> b.tmp/f
	-date > b.tmp/c.$(shell echo $$$$)
	-date > b.tmp/y.$(shell echo $$$$)
	./$(NAME) default a.tmp b.tmp -debug sort

runprefer: all
	-mkdir a.tmp b.tmp
	-date > a.tmp/b
	-date > b.tmp/m
	-date > b.tmp/z
	-echo Hello > a.tmp/z
	-date > b.tmp/f
	-date >> b.tmp/f
	-date > b.tmp/c.$(shell echo $$$$)
	-date > b.tmp/y.$(shell echo $$$$)
	./$(NAME) default a.tmp b.tmp -force b.tmp

prefsdocs: all
	./$(NAME) -prefsdocs 2> prefsdocsjunk.tmp
	mv -f prefsdocsjunk.tmp prefsdocs.tmp

# For developers at Penn
runsaul: all
	-date > a.tmp/x
	./$(NAME) -servercmd current/unison/src/unison \
	          -debug all -debugtimes \
                  a.tmp ssh://saul/$(HOME)/current/unison/src/b.tmp

runlocal: all
	-date > a.tmp/x
	./$(NAME) -servercmd current/unison/src/unison \
                  test1 a.tmp ssh://localhost/$(HOME)/current/unison/src/b.tmp \
	          -debug gc

rshsaul: all
	-date > a.tmp/x
	./$(NAME) a.tmp rsh://saul/$(HOME)/current/unison/src/b.tmp 

byte:
	$(MAKE) all NATIVE=false

runtest: 
	$(MAKE) all NATIVE=false DEBUG=true
	./unison test 

runbare: 
	$(MAKE) all NATIVE=false DEBUG=true
	./unison 

runtesttext: 
	$(MAKE) all NATIVE=false DEBUG=true UISTYLE=text
	./unison test -ui text -batch

runjunk: byte
	./unison current -debug all

######################################################################
# Tags

# In Windows, tags and TAGS are the same, so make tags stops working
# after the first invocation.  The .PHONY declaration makes it work
# again.
.PHONY: tags

tags:
	-$(ETAGS) {*,*/*}.mli {*,*/*}.ml *.txt 

all:: TAGS

TAGS: 
	$(MAKE) tags

######################################################################
# Misc

clean::
	-$(RM) -rf *.log *.aux *.log *.dvi *.out obsolete *.bak
	-$(RM) -rf $(NAME) $(NAME).exe

clean::
	$(MAKE) -C ubase clean
	$(MAKE) -C lwt clean

checkin:
	$(MAKE) -C .. checkin

####################################################################
# Documentation strings

# Cons up a fake strings.ml if necessary (the real one is generated when
# we build the documentation, but we need to be able to compile the 
# executable here to do that!)
strings.ml: 
	echo "(* Dummy strings.ml *)" > strings.ml
	echo "let docs = []" >> strings.ml

