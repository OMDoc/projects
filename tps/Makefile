PREFIX          = ../../branches/omdoc-1.3
COLLFILES       = 
BUTFILES	= prefixed.omdoc

include $(PREFIX)/lib/Makefile.vars
include $(PREFIX)/lib/Makefile.test.vars

JOMDOCXSLPARAM   =  -X

#NTNDIR = $(PREFIX)/examples/logics
#NTNS = sthol pl0 lambda-calc indeq truthval truthtables simpletypes
#NTN = $(NTNS:%=-f $(NTNDIR)/%.ntn)

all:		pres
include $(PREFIX)/lib/Makefile.in
include $(PREFIX)/lib/Makefile.test.in

echo:	
	echo $(NTN)


