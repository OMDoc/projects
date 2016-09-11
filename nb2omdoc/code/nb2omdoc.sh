#!/bin/csh -f
#
# :File:        nb2omdoc.sh
#
# :Purpose:     run the nb to omdoc conversion program using 'math'
#               
#
#

set progname = `basename $0`

set usage = "Usage: ${progname}  notebook (no extension)"

if( $#argv != 1 ) then
   echo "${usage}"
   exit 1
endif

set TARG = runmath.$$
set LOGF = logmath.$$

cat > $TARG << ENDENDEND

<<nb2om.m;
\$omsystem = "omdoc.dtd";
\$omtitle = "Conversion Test";
\$celltrace = False;
NB2OMDoc["$1"];
Exit[]

ENDENDEND

math -initfile $TARG >& $LOGF

tail +4 $LOGF

rm -f $TARG $LOGF

# eof






