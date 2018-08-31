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

# all are in via env.vars now, via --export field of sbatch !!!
#
#proc_level=FTFP
#beam=proton
#pdgcode=2212
#experiment=IAEA
#NUniv=25

export EXTERNALS=/g4/yarba_j/scisoft-installs/externals

source ${EXTERNALS}/setup

setup art v2_11_02 -q e15:prof
setup cmake v3_10_1
# ---> geant4 v4_10_4 -q cl23:e15:prof
setup mrb v1_13_02
setup larcoreobj v1_24_00 -q e15:prof

# needed if using local G4 build !
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
cd ${MRB_SOURCE}/artg4tk
source ./geant4make-no-ups.sh geant4-10-04-ref-06

#
# ESSENTIAL !!!
# Otherwise connection to DoSSiER will fail 
# because Wilson/SLURM is a private netwok !!!
#
# ---> export http_proxy=http://192.168.76.79:3128
export http_proxy=http://192.168.76.26:3128

G4ParamTest=${MRB_SOURCE}/artg4tk/artg4tk/G4PhysModelParamStudy

cd ${G4ParamTest}/ProdScripts/SLURM-shell

. ${G4ParamTest}/ProdScripts/HelperScripts/art_services.sh
. ${G4ParamTest}/ProdScripts/exp_data_includes/exp_data.sh

rundirname=analysis_${proc_level}
if [ ! -d "${rundirname}" ]; then
/bin/mkdir ${rundirname}
fi

evtfiledir=${proc_level}_${beam}${momz}GeV_${target}

cd ${rundirname}
echo " I am in $PWD "

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
# 
# NOTE: obvioulsy, it wont work if the evtfiledir is empty or doesn't exist
#       alternatively one may compose files names explicitly (from 0 to 31)
#
nfiles=`/bin/ls -alF ../${evtfiledir}/*.root | wc -l`
icount=0
for ff in ../${evtfiledir}/*.root; do
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


