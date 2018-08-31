#!/usr/bin/env bash
#

# pass it in via -v arg of qsub or --export arg of sbatch
#
# ---> WORKDIR_TOP=${1}
#
if [ "x" == "x$WORKDIR_TOP" ] ; then
   echo " env.var. WORKDIR_TOP is NOT set; bail out "
   exit 3
fi

# all through env.vars now via --export field of sbatch !!!
#
# proc_level=FTFP
# beam=proton
# pdgcode=2212
# NUniv=25
# maxevents=15625

FCL_BASENAME=multiU
FCL_INCLUDE=${FCL_BASENAME}_${proc_level}.fcl
echo " FCL_INCLUDE = ${FCL_INCLUDE} "

export EXTERNALS=/g4/yarba_j/scisoft-installs/externals

source ${EXTERNALS}/setup

setup art v2_11_02 -q e15:prof
setup cmake v3_10_1
# ---> use local build ---> setup geant4 v4_10_4 -q cl23:e15:prof
setup mrb v1_13_02
setup larcoreobj v1_24_00 -q e15:prof

# needed if using local G4 build !
# in lieu of UPS build of geant4 v4_10_4-whatever...
#
setup xerces_c v3_2_0 -q e15:prof

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
source ./geant4make-no-ups.sh geant4-10-04-ref-06

G4ParamTest=${MRB_SOURCE}/artg4tk/artg4tk/G4PhysModelParamStudy

cd ${G4ParamTest}/ProdScripts/SLURM-shell

if [ ! -e  ${FCL_INCLUDE} ]; then
echo " regenerating ${FCL_INCLUDE} "
# root -b -p -q ../HelperScripts/generate_universes.C\(\"${FCL_BASENAME}\"\,${NUniv}\,\"${proc_level}\"\)
root -b -p -q ${G4ParamTest}/ProdScripts/HelperScripts/generate_universes.C\(\"${FCL_BASENAME}\"\,${NUniv}\,\"${proc_level}\"\)
fi

. ${G4ParamTest}/ProdScripts/HelperScripts/art_input_sources.sh
. ${G4ParamTest}/ProdScripts/HelperScripts/art_services.sh
. ${G4ParamTest}/ProdScripts/HelperScripts/art_outputs.sh
. ${G4ParamTest}/ProdScripts/HelperScripts/art_producers.sh


rundirname=${proc_level}_${beam}${momz}GeV_${target}
if [ ! -d "${rundirname}" ]; then
/bin/mkdir ${rundirname}
fi

cd ${rundirname}
echo " I am in $PWD "

config_base=${proc_level}_${beam}${momz}GeV_${target}

config=${config_base}_Default.fcl

if [ -e ${config} ]; then
/bin/rm ${config}
fi

JobID=${SLURM_ARRAY_TASK_ID}
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

/usr/bin/printf "#include \"../${FCL_INCLUDE}\" \n" >> ${config}

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

art -c ${config}
# /bin/rm ${config}

pattern=0000

for (( i=1; i<=${NUniv}; ++i )) do
# ---> the construct works but it'll do as 1234, 1235, 1237, etc. ---> seed=$((${seed}+${i}))
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
#
/usr/bin/printf "#include \"../${FCL_INCLUDE}\" \n" >> ${config}

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
# /bin/rm ${config}

#
done

