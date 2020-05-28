#!/usr/bin/env bash
#

if [ "x" == "x$WORKDIR_TOP" ] ; then
   echo " env.var. WORKDIR_TOP is NOT set; bail out "
   exit 3
fi

# define "experiment" (exp.dataset)
#
export experiment=ITEP

# in principle, we need to make sure that the number of jobs
# does not exceed the number of cores, or the jobs will
# compete for resources (as it happens in amd32_g4val_slow !);
# see commented out fragment down the script
#
# target_list=( C Cu Pb )
# momz_list=(  5.0 )
# if [ x"$beam" = x"proton" ]; then
# momz_list=( 5.0 7.5 )
# fi
target_list=( Pb )
momz_list=( 5.0 )

echo " I am in ${PWD}"

. ${PWD}/analysis_multiU_lq_func.sh

analysis_multiU_lq_func

exit
