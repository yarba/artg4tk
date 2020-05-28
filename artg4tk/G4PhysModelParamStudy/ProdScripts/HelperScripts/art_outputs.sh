#!/usr/bin/env bash
#

cfg_outputs () {

/usr/bin/printf " \n"
/usr/bin/printf "outputs: { \n"
/usr/bin/printf "   ${outlabel}: { \n"
/usr/bin/printf "      module_type: RootOutput \n"

if [ "x" == "x$SPLIT_OUTPUT" ]; then
/usr/bin/printf "      fileName: \"${outfile}.root\" \n" 
else
# NOTE: this will print as outfile_%#.root
#       it's the trick %% to make printf to print % 
/usr/bin/printf "      fileName: \"${outfile}_%%#.root\" \n" 
/usr/bin/printf "      fileProperties: { \n"
/usr/bin/printf "         maxEvents: ${NEVTSPLIT} \n"
/usr/bin/printf "         # --> maxInputFiles: 1 \n"
/usr/bin/printf "      } \n"      
fi

/usr/bin/printf "   } \n"
/usr/bin/printf "} \n"

}
