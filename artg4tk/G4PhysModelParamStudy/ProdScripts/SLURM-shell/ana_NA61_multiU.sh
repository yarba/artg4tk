#!/usr/bin/env bash
#

g4ana_multiU() {

#
# beam and momz "env.vars" are visible throughout; no need to pass them in, etc.
#
echo " beam = ${beam} "
echo " pdgcode = ${pdgcode} "
echo " momentum(z) = ${momz} "

##
## ESSENTIAL !!!
## Otherwise connection to DoSSiER will fail 
## because Wilson/SLURM is a private netwok !!!
##
## NOTE: As of April 25, 2019, DoSSiER is having problems
##       retrieving exp.data records through the WebAPI
##       although dictionaries seem to be working fine.
##       For this reason we'll use "local" ASCII copies
##       of the JSON files, and thus the http_proxy
##       isn't critical at this point.
##       But let's keep it here as a reminder.
##
## ---> old one ---> export http_proxy=http://192.168.76.79:3128
##
## The one below works as of Apr 23, 2019
##
#export http_proxy=http://192.168.76.26:3128
#
# double check...
#
echo " http_proxy = ${http_proxy} "

rundirname=/scratch/analysis_${proc_level}_${beam}${momz}GeV_${target}
if [ ! -d "${rundirname}" ]; then
/bin/mkdir ${rundirname}
fi

cd ${rundirname}
echo " I am in $PWD "

#
# Copy over common-use scripts
#
G4ParamTest=${MRB_SOURCE}/artg4tk/artg4tk/G4PhysModelParamStudy
/bin/mkdir ${rundirname}/HelperScripts
fcp -c /usr/bin/rcp ibtevnfsg4:${G4ParamTest}/ProdScripts/HelperScripts/art_services.sh ${rundirname}/HelperScripts
/bin/chmod +x ${rundirname}/HelperScripts/art_services.sh
fcp -c /usr/bin/rcp ibtevnfsg4:${G4ParamTest}/ProdScripts/exp_data_includes/exp_data.sh ${rundirname}/HelperScripts
/bin/chmod +x ${PWD}/HelperScripts/exp_data.sh

#
# Now copy over JSON files (exp.data)
#
JSONDIR=${rundirname}/json
if [ ! -d "${JSONDIR}" ]; then
/bin/mkdir ${JSONDIR}
fi 
fcp -c /usr/bin/rcp ibtevnfsg4:/lfstev/g4p/yarba_j/g4studies/dossier-json/ExpDataJSON.tgz ${JSONDIR}
cd ${JSONDIR}
tar -xzf ${JSONDIR}/ExpDataJSON.tgz
cd ${rundirname}

. ${rundirname}/HelperScripts/art_services.sh
. ${rundirname}//HelperScripts/exp_data.sh

# define path to input simulated event files
#
evtfiledir=${PATH2EVT}/${proc_level}_${beam}${momz}GeV_${target}

# OK, this scenario works although it's a bit slow since it copies one by one.
#
# Alternative could be tar-ing all tarballes into a single "big one", 
# then transfering the "bin one" to the worker node, untar, then untar
# individual tarballs. But tar-ing individual tarballs that are already
# of a large size into the "big one" also takes quite some time, and it'll
# have to be done "over network" so it's unclear if it's safe, besides also
# been CPU expensive.
#
tarfile_list=`/bin/ls -alF ${evtfiledir}/*.tgz | awk '{print $NF}'`
#   ntarfiles=`/bin/ls -alF ../${evtfiledir}/*.tgz | wc -l`
for tar in ${tarfile_list}; do
fcp -c /usr/bin/rcp ibtevnfsg4:${tar} ${rundirname}
tt=`basename "${tar}"`
/bin/tar -xzf ${tt}
/bin/rm -rf *.fcl
/bin/rm ${tt}
# would be nice to ensure that the *root files are there !
done

# 
# NOTE: obvioulsy, it wont work if the evtfiledir is empty or doesn't exist
#       alternatively one may compose files names explicitly (e.g. from 0 to 31)
#
nfiles=`/bin/ls -alF ${rundirname}/*.root | wc -l`
# NOTE: Or maybe just as follows ???
# nfiles=`/bin/ls -alF ${rundirname}/*.root | wc -l`

config_base=analysis_${proc_level}_${beam}${momz}GeV_${target}_${experiment}

config=${config_base}.fcl

ts_filename=${proc_level}_${beam}${momz}GeV_${target}-ProcL_${experiment}

/usr/bin/printf "process_name: processANALYSIS \n" >> ${config}

#input source
/usr/bin/printf " \n"  >> ${config}
/usr/bin/printf "source: { \n" >> ${config}
/usr/bin/printf "   module_type: RootInput \n" >> ${config} 
/usr/bin/printf "   maxEvents: -1 \n"  >> ${config}
/usr/bin/printf "   fileNames: [ \n " >> ${config}
icount=0
evtrootfile_list=`/bin/ls -alF ${rundirname}/*.root | awk '{print $NF}'`
for ff in ${evtrootfile_list}; do
/usr/bin/printf "               \"${ff}\"" >> ${config}
icount=$((${icount}+1))
if [ "${icount}" -lt "${nfiles}" ]; then
/usr/bin/printf ", \n " >> ${config}
fi
done
/usr/bin/printf " \n              ] \n"  >> ${config}
/usr/bin/printf "} \n"  >> ${config}

cfg_services_analysis >> ${config}

/usr/bin/printf " \n" >> ${config}
/usr/bin/printf "physics: { \n" >> ${config}
/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "   producers: { \n" >> ${config}
/usr/bin/printf "   } \n" >> ${config}
/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "   analyzers: { \n" >> ${config}

# now the chain of analyzers...
#
# first of all, default
#
/usr/bin/printf "      ${proc_level}Default${experiment}: \n" >> ${config}
/usr/bin/printf "      { \n" >> ${config}
/usr/bin/printf "         module_type: Analyzer${experiment} \n" >> ${config}
/usr/bin/printf "         ProductLabel: \"${proc_level}Default\" \n" >> ${config}
/usr/bin/printf "         IncludeExpData: \n" >> ${config}
/usr/bin/printf "         { \n" >> ${config}
/usr/bin/printf "            UseASCIIRecords: true \n " >> ${config}
/usr/bin/printf "            Path2Records : \"${JSONDIR}\" \n " >>  ${config}
exp_data_${beam}${momz}GeV_${target}_${experiment} >> ${config} 
/usr/bin/printf "\n         } \n" >> ${config}
/usr/bin/printf "      } \n" >> ${config}
#
# now variants
#
pattern=0000
for (( i=1; i<=${NUniv}; ++i )) do
pos=$((${#pattern}-${#i}))
# echo ${pattern:0:${pos}}
univ=${pattern:0:${pos}}${i}
/usr/bin/printf "      ${proc_level}Univ${univ}${experiment}: \n" >> ${config}
/usr/bin/printf "      { \n" >> ${config}
/usr/bin/printf "         module_type: Analyzer${experiment} \n" >> ${config}
/usr/bin/printf "         ProductLabel: \"${proc_level}RandomUniv${univ}\" \n" >> ${config}
/usr/bin/printf "         IncludeExpData: \n" >> ${config}
/usr/bin/printf "         { \n" >> ${config}
/usr/bin/printf "            UseASCIIRecords: true \n " >> ${config}
/usr/bin/printf "            Path2Records : \"${JSONDIR}\" \n " >>  ${config}
exp_data_${beam}${momz}GeV_${target}_${experiment} >> ${config}
/usr/bin/printf "\n         } \n" >> ${config}
/usr/bin/printf "      } \n" >> ${config}
done

/usr/bin/printf " \n" >> ${config}
/usr/bin/printf "   } \n" >> ${config} # this is the end of analyzers-block

/usr/bin/printf " \n" >> ${config}

# schedule analyzers for the run
/usr/bin/printf "   path2: [ \n" >> ${config}
/usr/bin/printf "            ${proc_level}Default${experiment} \n" >> ${config}
pattern=0000
for (( i=1; i<=${NUniv}; ++i )) do
pos=$((${#pattern}-${#i}))
# echo ${pattern:0:${pos}}
univ=${pattern:0:${pos}}${i}
/usr/bin/printf "          , ${proc_level}Univ${univ}${experiment} \n" >> ${config}
done
/usr/bin/printf "          ] \n" >> ${config} 

/usr/bin/printf "   end_paths: [ path2 ] \n" >> ${config}

/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "} \n" >> ${config}

art -c ${config}

# NOW NEED TO 
# --> TAR OUTPUT
# --> TRANSFERE OUTPUT TO /lfstev
# --> CLEANUP

TARFILE=${rundirname}/analysis_${proc_level}_${beam}${momz}GeV_${target}.tgz
tar zcf ${TARFILE} ${ts_filename}.root *.fcl

# this part has moved to "master"
#
# CURRENTDATE=`date +"%m-%d-%y"`
# if [ ! -d "/lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}" ]; then
# /bin/mkdir /lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}
# fi
# if [ ! -d "/lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}/analysis_${proc_level}_${target}" ]; then
# /bin/mkdir /lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}/analysis_${proc_level}_${target}
# fi

fcp -c /usr/bin/rcp ${TARFILE} ibtevnfsg4:/lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}/analysis_${proc_level}_${beam}_NA61

# ---> /bin/rm -rf ${rundirname}

} # end of function g4ana_multiU

# 
# main script that calls the g4sim_multiU function
#

# We need "sleep time" such that multiple "master" jobs (on different nodes)
# don't collide over preparing the (same) ExpDataJSON tarball
#
SLEEP_TIME=$((${RANDOM}%60+1))
echo " Will sleep ${SLEEP_TIME} seconds"
/bin/sleep ${SLEEP_TIME}

# pass in the WORKDIR_TOP env.var. via -v arg of qsub or --export arg of sbatch
#
# ---> WORKDIR_TOP=${1}
#
if [ "x" == "x$WORKDIR_TOP" ] ; then
   echo " env.var. WORKDIR_TOP is NOT set; bail out "
   exit 3
fi

#copy (and unwind ?) whatever is needed (tarball, file, etc.)
source  /fnal/ups/etc/setups.sh
setup fcp

# setups for core packages
#
export EXTERNALS=/g4/yarba_j/scisoft-installs/externals
source ${EXTERNALS}/setup
setup art v2_11_02 -q e17:prof
setup cmake v3_10_1
# ---> use local build ---> setup geant4 v4_10_4 -q cl23:e15:prof
setup mrb v1_14_00
# needed if using local G4 build !
# in lieu of UPS build of geant4 v4_10_4-whatever...
#
setup xerces_c v3_2_0a -q e17:prof
cd ${WORKDIR_TOP}
source ./localProducts*/setup
# mrbsetenv is an alias for the complete command below; 
# it will NOT work if issued from a script - one has to "source" it explicitly
# and this should be done AFTER source-ing this ./localProducts...../setup thing
# such deps on MRB are NOT super convenient, and at some point we might want
# to explore alternatives ^_^
#
source ${MRB_DIR}/bin/mrbSetEnv
# needed if using local G4 build !
# in lieu of UPS build of geant4 v4_10_4-whatever...
#
cd ${MRB_SOURCE}/artg4tk
source ./geant4make-no-ups.sh geant4-10-05-ref-01

#
# ESSENTIAL !!!
# Otherwise connection to DoSSiER will fail 
# because Wilson/SLURM is a private netwok !!!
# We can do it here only once per "master" job
# since we're exporting the env.var.
#
# NOTE: As of April 25, 2019, DoSSiER is having problems
#       retrieving exp.data records through the WebAPI
#       although dictionaries seem to be working fine.
#       For this reason we'll use "local" ASCII copies
#       of the JSON files, and thus the http_proxy
#       isn't critical at this point.
#       But let's keep it here as a reminder.
#
# ---> old one ---> export http_proxy=http://192.168.76.79:3128
#
# The one below works as of Apr 23, 2019
#
export http_proxy=http://192.168.76.26:3128

#
# After walking around for various setups, return to the submit dir
#
cd ${SLURM_SUBMIT_DIR}

# reserve output directory
#
export CURRENTDATE=`date +"%m-%d-%y"`
if [ ! -d "/lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}" ]; then
/bin/mkdir /lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}
fi
if [ ! -d "/lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}/analysis_${proc_level}_${beam}_NA61" ]; then
/bin/mkdir /lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}/analysis_${proc_level}_${beam}_NA61
fi

# define how many parallel jobs we can launch (one per core)
#
coresPerNode=`cat /proc/cpuinfo | grep -c processor`
nodeName=`uname -n`
echo "number of cores on node ${nodeName} = ${coresPerNode}"

#
# Prepare tarball with exp.data in JSON format (if not there yet)
#
if [ ! -e /lfstev/g4p/yarba_j/g4studies/dossier-json/ExpDataJSON.tgz ]; then
echo " Prepare tarball with exp.data in JSON format "
cd /lfstev/g4p/yarba_j/g4studies/dossier-json
# tar zcf /lfstev/g4p/yarba_j/g4studies/dossier-json/ExpDataJSON.tgz /lfstev/g4p/yarba_j/g4studies/dossier-json/*.json
tar zcf ExpDataJSON.tgz *.json
cd ${SLURM_SUBMIT_DIR}
else
echo " Tarball with exp.data in JSON format exists: /lfstev/g4p/yarba_j/g4studies/dossier-json/ExpDataJSON.tgz "
fi

# define "experiment" (exp.dataset)
#
export experiment=NA61

# in principle, we need to make sure that the number of jobs
# does not exceed the number of cores, or the jobs will
# compete for resources (as it happens in amd32_g4val_slow !)
#
target_list=( C )
momz_list=( 31.0 )

#if [ ${#beam_list[@]} -ge ${coresPerNode} ]; then
#  echo "number of beam particles is ${#beam_list[@]}, and exceeds number of cores which is ${coresPerNode} on ${nodeName}" 
#fi


for target in ${target_list[@]}; do
for momz in ${momz_list[@]}; do
echo " submitting analysis for ${beam} of ${momz}GeV on ${target} " 
LOGFILE=LOG_ANA_${SLURM_JOB_ID}_${proc_level}_${beam}${momz}GeV_${target}.log
g4ana_multiU  >& ${LOGFILE} &
done
done

# wait until all background jobs complete
wait

exit
