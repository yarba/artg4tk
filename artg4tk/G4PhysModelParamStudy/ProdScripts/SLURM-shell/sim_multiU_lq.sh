#!/usr/bin/env bash
#

if [ "x" == "x$WORKDIR_TOP" ] ; then
   echo " env.var. WORKDIR_TOP is NOT set; bail out "
   exit 3
fi

# the following two will work only if launched with MPI (--mpi=pmi2)
# JobID=${PMI_RANK})
# JobID=$((1+${PMI_RANK}))
#
# this one (hopefully) works if launched as follows:
# srun -l simulate_multiU_mpi.sh
# or (hopefully) when launcehed with MPI
JobID=$((1+${SLURM_PROCID}))

echo " JobID = ${JobID} --> maxevents = ${maxevents} "

SLEEP_TIME=$((${RANDOM}%60+1))
echo " JobID = ${JobID} --> will sleep ${SLEEP_TIME} seconds"
/usr/bin/sleep ${SLEEP_TIME}

# all through env.vars now via --export field of sbatch !!!
#
# proc_level=FTFP
# beam=proton
# pdgcode=2212
# NUniv=25
# maxevents=15625
# momz=5.0
# target=Pb

# more "uniform" approach as CVMFS is mounted on both Wilson & LQ1 
#
source  /cvmfs/larsoft.opensciencegrid.org/products/setup

setup cmake v3_10_1
# ---> use local build ---> setup geant4 v4_10_4 -q cl23:e15:prof
setup mrb v1_14_00

setup art v2_11_03 -q e17:prof
# needed if using local G4 build !
# in lieu of UPS build of geant4 v4_10_4-whatever...
#
setup xerces_c v3_2_2 -q e17:prof

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
source ./geant4make-no-ups.sh geant4-10-06-ref-01 /home/yarba_j/geant4-local-builds/gcc-7.3.0

# prepare include with Universes (for the specified NUniv number of them)
# because we make jobs sleep for a random number of seconds before start,
# hopes are that the jobs will NOT "collide" over generating the FCL include
#
FCL_BASENAME=multiU_NUniv${NUniv}
FCL_INCLUDE=${FCL_BASENAME}_${proc_level}.fcl
echo " FCL_INCLUDE = ${FCL_INCLUDE} "
G4ParamTest=${MRB_SOURCE}/artg4tk/artg4tk/G4PhysModelParamStudy

if [ ! -e ${G4ParamTest}/ProdScripts/HelperScripts/${FCL_INCLUDE} ]; then
echo " regenerating ${FCL_INCLUDE} "
cd ${G4ParamTest}/ProdScripts/HelperScripts
root -b -p -q ${G4ParamTest}/ProdScripts/HelperScripts/generate_universes.C\(\"${FCL_BASENAME}\"\,${NUniv}\,\"${proc_level}\"\)
else
echo " ${FCL_INCLUDE} exists; do NOT regenerate "
fi

rundirname=/scratch/${proc_level}_${beam}${momz}GeV_${target}_${JobID}
if [ ! -d "${rundirname}" ]; then
/bin/mkdir ${rundirname}
fi

cd ${rundirname}
echo " I am in $PWD "

echo " Copying over ${FCL_INCLUDE} from ${G4ParamTest}/ProdScripts/HelperScripts to ${rundirname}"
rsync -h --progress ${G4ParamTest}/ProdScripts/HelperScripts/${FCL_INCLUDE} ${rundirname}

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

# NOTE: For SLURM jobs/runs, it's essential to format the include 
#       as "./<your-include>.fcl"
#       If you do "<your-include.fcl>", it's NOT guatanteed to work
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

# echo " ***** ===== ***** "
# echo "LD_LIBRARY_PATH = ${LD_LIBRARY_PATH}"
# echo " ***** ===== ***** "

LOGDIR=${G4ParamTest}/ProdScripts/SLURM-shell
LOGFILE=${LOGDIR}/LOG_SIM_${SLURM_JOB_ID}_${proc_level}_${beam}${momz}GeV_${target}-Default-${JobID}.log

art -c ${config} >& ${LOGFILE}
# --> later --> /bin/rm ${config}

pattern=0000

for (( i=1; i<=${NUniv}; ++i )) do
# ---> the construct works but it'll do as 1234, 1235, 1237, etc. ---> seed=$((${seed}+${i}))
seed=$((1234+${i}))
pos=$((${#pattern}-${#i}))
# echo ${pattern:0:${pos}}
univ=${pattern:0:${pos}}${i}
#
# try to split job outputs into smaller files
#
# --> input=${outfile}
#
nfiles=`/bin/ls -alF ${rundirname}/Evt-*.root | wc -l`
evtrootfile_list=`/bin/ls -alF ${rundirname}/Evt-*.root | awk '{print $NF}'`
#
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
#
/usr/bin/printf "#include \"./${FCL_INCLUDE}\" \n" >> ${config}

/usr/bin/printf "process_name: process${process}${univ} \n" >> ${config}

#input source
/usr/bin/printf " \n"  >> ${config}
/usr/bin/printf "source: { \n" >> ${config}
/usr/bin/printf "   module_type: RootInput \n" >> ${config} 
/usr/bin/printf "   maxEvents: -1 \n"  >> ${config}
# --> /usr/bin/printf "   fileNames: [ \"${input}.root\" ] \n"  >> ${config}
icount=0
/usr/bin/printf "   fileNames: [ \n"  >> ${config}
for ff in ${evtrootfile_list}; do
/usr/bin/printf "               \"${ff}\"" >> ${config}
icount=$((${icount}+1))
if [ "${icount}" -lt "${nfiles}" ]; then
/usr/bin/printf ", \n " >> ${config}
fi
done
/usr/bin/printf " \n              ] \n"  >> ${config}
/usr/bin/printf "} \n"  >> ${config}

cfg_services >> ${config}

# FIXME !!! Maybe it's better to pass it in as env.vars...
# --> SPLIT_OUTPUT=yes
# --> NEVTSPLIT=2500
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

LOGFILE=${LOGDIR}/LOG_SIM_${SLURM_JOB_ID}_${proc_level}_${beam}${momz}GeV_${target}-Univ${univ}-${JobID}.log
# NOTE: art == ${ART_FQ_DIR}/bin/art
#
art -c ${config} >& ${LOGFILE}

# --> /bin/rm ${input}.root
for ff in in ${evtrootfile_list}; do
/bin/rm ${ff}
done

# /bin/rm ${config}

#
done

TARFILE=${rundirname}/${proc_level}_${beam}${momz}GeV_${target}_${JobID}.tgz
tar zcf ${TARFILE} *.root *.fcl 

DATE=`date +"%m-%d-%y"`
G4VMP_OUT="/lustre1/g4/yarba_j/g4vmp-study"
if [ ! -d "${G4VMP_OUT}/${DATE}" ]; then
mkdir ${G4VMP_OUT}/${DATE}
fi
if [ ! -d "${G4VMP_OUT}/${DATE}/${proc_level}_${beam}${momz}GeV_${target}" ]; then
mkdir ${G4VMP_OUT}/${DATE}/${proc_level}_${beam}${momz}GeV_${target}
fi

rsync -h -z --progress ${TARFILE} ${G4VMP_OUT}/${DATE}/${proc_level}_${beam}${momz}GeV_${target}

# --> later --> /bin/rm -rf ${rundirname}

