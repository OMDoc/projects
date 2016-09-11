PREFIX          = ../..
include $(PREFIX)/lib/Makefile.vars
NEEDSFROMDIRS	= $(PREFIX)/examples/logics $(PREFIX)/examples/omstd

all:		html ps mml recurse
include $(PREFIX)/lib/Makefile.in

recurse:	
		if(cd lecture4 && $(MAKE) -$(MAKEFLAGS)); then true; else exit 1; fi
