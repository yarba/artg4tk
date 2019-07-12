#!/usr/bin/env bash
#

g4sim_multiU() {

#
# JobID "env.var" is visible throughout; no need to pass it in, etc.
#
echo " JobID = ${JobID} "
echo " FCL_INCLUDE = ${FCL_INCLUDE} "

# Need to export because subsequently ProdScripts/HelperScripts
# will want it as an env.variable
# ... well, technically speaking I can do it in "master"...
#
export maxevents=${1}

rundirname=/scratch/${proc_level}_${beam}${momz}GeV_${target}_${JobID}
if [ ! -d "${rundirname}" ]; then
/bin/mkdir ${rundirname}
fi

cd ${rundirname}
echo " I am in $PWD "

echo " Copying over ${FCL_INCLUDE} from ${G4ParamTest}/ProdScripts/HelperScripts to ${rundirname}"
fcp -c /usr/bin/rcp ibtevnfsg4:${G4ParamTest}/ProdScripts/HelperScripts/${FCL_INCLUDE} ${rundirname}

#
# FIXME !!! Maybe copy them over to each rundir ???
#
. ${G4ParamTest}/ProdScripts/HelperScripts/art_input_sources.sh
. ${G4ParamTest}/ProdScripts/HelperScripts/art_services.sh
. ${G4ParamTest}/ProdScripts/HelperScripts/art_outputs.sh
. ${G4ParamTest}/ProdScripts/HelperScripts/art_producers.sh

config_base=${proc_level}_${beam}${momz}GeV_${target}

config=${config_base}_Default.fcl

if [ -e ${config} ]; then
/bin/rm ${config}
fi

# ---> ---> Different scenario now ---> JobID=${SLURM_ARRAY_TASK_ID}
process=G4SIM
seed=1234
outlabel=out${process}
outfile=Evt-${config_base}-Default
if [ ! "x" == "x$JobID" ]; then
# ---> seed=$((${seed}+${JobID}))
seed=$((1234+${JobID}))
config=${config_base}_Default-${JobID}.fcl
outfile=Evt-${config_base}-Default-${JobID}
fi

# NOTE: For SLURM jobs/runs, tt's essential to format the include 
#       as "./<your-include>.fcl"
#       If you do "<your-include.fcl", it's NOT guatanteed to work
#
/usr/bin/printf "#include \"./${FCL_INCLUDE}\" \n" >> ${config}

/usr/bin/printf "process_name: process${process} \n" >> ${config}
cfg_empty_source >> ${config}
cfg_services >> ${config}
cfg_outputs >> ${config}

/usr/bin/printf "physics: { \n" >> ${config}
/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "   producers: { \n" >> ${config}

cfg_generator >> ${config}

/usr/bin/printf "      ${proc_level}Default : @local::${proc_level}Default \n" >> ${config}


/usr/bin/printf "   } \n" >> ${config}

/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "   analyzers: { \n" >> ${config}
/usr/bin/printf " \n" >> ${config}
/usr/bin/printf "   } \n" >> ${config}
/usr/bin/printf " \n" >> ${config}
/usr/bin/printf "   path1: [ PrimaryGenerator,  ${proc_level}Default ] \n" >> ${config} 

/usr/bin/printf "   stream1: [ ${outlabel} ] \n" >> ${config}
/usr/bin/printf "   trigger_paths: [ path1 ] \n" >> ${config}
/usr/bin/printf "   end_paths: [ stream1 ] \n" >> ${config}

/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "} \n" >> ${config}

export LD_LIBRARY_PATH=${MRB_BUILDDIR}/artg4tk/lib:$LD_LIBRARY_PATH

echo " ***** ===== ***** "
echo "LD_LIBRARY_PATH = ${LD_LIBRARY_PATH}"
echo " ***** ===== ***** "

#
# It does NOT seem to work like this...
#
# LOGFILE=SIM_${proc_level}_${beam}${momz}GeV_${target}_${JobID}.log
# art -c ${config} >& ${LOGFILE} &
#
# But works like this...
# The output (log) will go to the one defined in the "master" part of the script
#
art -c ${config} 

# ---> remove later ---> /bin/rm ${config}

# DO UNIVERSES HERE (in a loop) !!!

pattern=0000

for (( i=1; i<=${NUniv}; ++i )) do

seed=$((1234+${i}))
pos=$((${#pattern}-${#i}))
# echo ${pattern:0:${pos}}
univ=${pattern:0:${pos}}${i}
input=${outfile}
outfile=Evt-${config_base}-add-Univ${univ}
outlabel=out${process}Univ${univ}
config=${config_base}_Univ${univ}.fcl
if [ ! "x" == "x$JobID" ]; then
# ---> see earlier comment --->  seed=$((${seed}+${JobID}))
offset=$((${JobID}*${JobID}))
seed=$((1234+${i}+${offset}))
config=${config_base}_Univ${univ}-${JobID}.fcl
outfile=Evt-${config_base}-add-Univ${univ}-${JobID}
fi

/usr/bin/printf "#include \"./${FCL_INCLUDE}\" \n" >> ${config}

/usr/bin/printf "process_name: process${process}${univ} \n" >> ${config}

#input source
/usr/bin/printf " \n"  >> ${config}
/usr/bin/printf "source: { \n" >> ${config}
/usr/bin/printf "   module_type: RootInput \n" >> ${config} 
/usr/bin/printf "   maxEvents: -1 \n"  >> ${config}
/usr/bin/printf "   fileNames: [ \"${input}.root\" ] \n"  >> ${config}
/usr/bin/printf "} \n"  >> ${config}


cfg_services >> ${config}
cfg_outputs >> ${config}

/usr/bin/printf "physics: { \n" >> ${config}
/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "   producers: { \n" >> ${config}

/usr/bin/printf "      ${proc_level}RandomUniv${univ} : @local::${proc_level}RandomUniv${univ} \n" >> ${config}

/usr/bin/printf "   } \n" >> ${config}

/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "   analyzers: { \n" >> ${config}
/usr/bin/printf " \n" >> ${config}
/usr/bin/printf "   } \n" >> ${config}
/usr/bin/printf " \n" >> ${config}
/usr/bin/printf "   path1: [ ${proc_level}RandomUniv${univ} ] \n" >> ${config} 

/usr/bin/printf "   stream1: [ ${outlabel} ] \n" >> ${config}
/usr/bin/printf "   trigger_paths: [ path1 ] \n" >> ${config}
/usr/bin/printf "   end_paths: [ stream1 ] \n" >> ${config}

/usr/bin/printf " \n" >> ${config}

/usr/bin/printf "} \n" >> ${config}

# NOTE: art == ${ART_FQ_DIR}/bin/art
#
art -c ${config}

/bin/rm ${input}.root
# ---> remove later ---> /bin/rm ${config}

done


TARFILE=${rundirname}/${proc_level}_${beam}${momz}GeV_${target}_${JobID}.tgz
# ---> tar zcf ${TARFILE} *.root *.fcl *.log
tar zcf ${TARFILE} *.root *.fcl 
# ---> tar zcf ${TARFILE} *.root

DATE=`date +"%m-%d-%y"`
if [ ! -d "/lfstev/g4p/yarba_j/g4studies/${DATE}" ]; then
/bin/mkdir /lfstev/g4p/yarba_j/g4studies/${DATE}
fi
if [ ! -d "/lfstev/g4p/yarba_j/g4studies/${DATE}/${proc_level}_${beam}${momz}GeV_${target}" ]; then
/bin/mkdir /lfstev/g4p/yarba_j/g4studies/${DATE}/${proc_level}_${beam}${momz}GeV_${target}
fi

fcp -c /usr/bin/rcp ${TARFILE} ibtevnfsg4:/lfstev/g4p/yarba_j/g4studies/${DATE}/${proc_level}_${beam}${momz}GeV_${target}

/bin/rm -rf ${rundirname}

} # end of function g4sim_multiU


# 
# main script ("master") that calls the g4sim_multiU function
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

# prepare  for copying (and unwind ?) whatever is needed (tarball, file, etc.)
#
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

# prepare include with Universes (for the specified NUniv number of them)
# because we make jobs sleep for a random number of seconds before start,
# hopes are that the jobs will NOT "collide" over generating the FCL include
#
export FCL_BASENAME=multiU_NUniv${NUniv}
export FCL_INCLUDE=${FCL_BASENAME}_${proc_level}.fcl
echo " FCL_INCLUDE = ${FCL_INCLUDE} "
export G4ParamTest=${MRB_SOURCE}/artg4tk/artg4tk/G4PhysModelParamStudy
# ---> GenUni=${G4ParamTest}/ProdScripts/HelperScripts/generate_universes.C
# --->fcp -c /usr/bin/rcp ibtevnfsg4:${GenUni} ${rundirname}
if [ ! -e ${G4ParamTest}/ProdScripts/HelperScripts/${FCL_INCLUDE} ]; then
echo " regenerating ${FCL_INCLUDE} "
cd ${G4ParamTest}/ProdScripts/HelperScripts
# ---> root -b -p -q ${PWD}/generate_universes.C\(\"${FCL_BASENAME}\"\,${NUniv}\,\"${proc_level}\"\)
root -b -p -q ${G4ParamTest}/ProdScripts/HelperScripts/generate_universes.C\(\"${FCL_BASENAME}\"\,${NUniv}\,\"${proc_level}\"\)
else
echo " ${FCL_INCLUDE} exists; do NOT regenerate "
fi

#
# After walking around for various setups, return to the submit dir
#
cd ${SLURM_SUBMIT_DIR}

coresPerNode=`cat /proc/cpuinfo | grep -c processor`
nodeName=`uname -n`
echo "number of cores on node ${nodeName} = ${coresPerNode}"

echo " nevtotal = ${nevtotal} "

nevt=$(( nevtotal/coresPerNode ))
echo " nevt = ${nevt} "

for JobID in $(seq ${coresPerNode}); do

# NOTE: **NO** need to pass is WORKDIR_TOP, proc_level, etc. !!!!! 
#       They're globally setup via --export field of sbatch
#
# NOTE: maybe stream each output output to a separate logfile ???
#       otherwise they'll all end up in one huge slurm-ID.out file...
#
# NOTE: If we stream like this, the log files will end up in the same
#       directory as slurm*.out files, i.e. where we launched the jobs from
#       Only a small part of output will go to slurm*.out then
#
#
# NOTE: JobID "env.var" is visible throughout; no need to pass it in, etc.
#
LOGFILE=LOG_SIM_${SLURM_JOB_ID}_${proc_level}_${beam}${momz}GeV_${target}_${JobID}.log
#echo " Lauching job ${JobID} in the background on ${nodeName} "
#echo " Output was supposed to ${LOGFILE} but we are not streaming to it at the moment "
g4sim_multiU ${nevt} >& ${LOGFILE} &
# g4sim_multiU ${nevt} &

done

# wait until all background jobs complete
wait

exit








