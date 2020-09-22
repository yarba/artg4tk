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

SLEEP_TIME=$((${RANDOM}%60+1))
echo " JobID = ${JobID} --> will sleep ${SLEEP_TIME} seconds"
/usr/bin/sleep ${SLEEP_TIME}

# define "experiment" (exp.dataset)
#
export experiment=HARP

# in principle, we need to make sure that the number of jobs
# does not exceed the number of cores, or the jobs will
# compete for resources (as it happens in amd32_g4val_slow !)
#
# target_list=( C Cu Pb )
# momz_list=( 3.0 5.0 8.0 12.0 )
target_list=( C Ta )
momz_list=( 8.0 )

ntgts=${#target_list[@]}
nmoms=${#momz_list[@]}

njobsmax=$((${ntgts}*${nmoms}))

if [ ${JobID} -gt ${njobsmax} ]; then
exit
fi

# Note: see earlier that JobID = SLURM_PROCID + 1
#
itgt=$((${SLURM_PROCID}/${nmoms}))
imom=$((${SLURM_PROCID} % ${nmoms}))
target=${target_list[$itgt]}
momz=${momz_list[$imom]}

#
# beam and momz "env.vars" are visible throughout; no need to pass them in, etc.
#
echo " beam = ${beam} "
echo " pdgcode = ${pdgcode} "
echo " momentum(z) = ${momz} "

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
# -->fcp -c /usr/bin/rcp ibtevnfsg4:${G4ParamTest}/ProdScripts/HelperScripts/art_services.sh ${rundirname}/HelperScripts
rsync -h --progress ${G4ParamTest}/ProdScripts/HelperScripts/art_services.sh ${rundirname}/HelperScripts
/bin/chmod +x ${rundirname}/HelperScripts/art_services.sh
# --> fcp -c /usr/bin/rcp ibtevnfsg4:${G4ParamTest}/ProdScripts/exp_data_includes/exp_data.sh ${rundirname}/HelperScripts
rsync -h --progress ${G4ParamTest}/ProdScripts/exp_data_includes/exp_data.sh ${rundirname}/HelperScripts
/bin/chmod +x ${rundirname}/HelperScripts/exp_data.sh

#
# Now copy over JSON files (exp.data)
#
JSONDIR=${rundirname}/json
if [ ! -d "${JSONDIR}" ]; then
/bin/mkdir ${JSONDIR}
fi 
# --> fcp -c /usr/bin/rcp ibtevnfsg4:/lfstev/g4p/yarba_j/g4studies/dossier-json/ExpDataJSON.tgz ${JSONDIR}
rsync -h --progress /home/yarba_j/dossier-json/ExpDataJSON.tgz ${JSONDIR}
cd ${JSONDIR}
tar -xzf ${JSONDIR}/ExpDataJSON.tgz
cd ${rundirname}

. ${rundirname}/HelperScripts/art_services.sh
. ${rundirname}//HelperScripts/exp_data.sh

# define path to input simulated event files
# Note: PATH2EVT is set via env.var. on input to sbatch
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

# start_transfer_root_files=`date`
#
# NOTE: for now, do NOT transter event files to WN
#       instead try to read directly from /lustre1
#
#tarfile_list=`/bin/ls -alF ${evtfiledir}/*.tgz | awk '{print $NF}'`
##   ntarfiles=`/bin/ls -alF ../${evtfiledir}/*.tgz | wc -l`
#for tar in ${tarfile_list}; do
## ---> fcp -c /usr/bin/rcp ibtevnfsg4:${tar} ${rundirname}
## ---> rsync -z -h --progress ${tar} ${rundirname}
#rsync -z  ${tar} ${rundirname}
#tt=`basename "${tar}"`
#/bin/tar -xzf ${tt}
#/bin/rm -rf *.fcl
#/bin/rm ${tt}
## would be nice to ensure that the *root files are there !
#done
#
# end_transfer_root_files=`date`
#
# echo " Transer of root file started: ${start_transfer_root_files} " 
# echo " Transer of root file ended: ${end_transfer_root_files} " 


#
# NO need to untar since we're now transfering Root files
#
#cd ${evtfiledir}
#echo " I am in ${PWD} "
#
#start_untaring=`date`
#
#tarfile_list=`/bin/ls -alF ${PWD}/*.tgz | awk '{print $NF}'`
#for tar in ${tarfile_list}; do
#/bin/tar xzf ${tar}
#/bin/rm -rf *fcl
#done
#
#end_untaring=`date`
#
#echo " Started untaring: ${start_untaring} "
#echo " Ended untaring: ${end_untaring} "
#
#cd ${rundirname}
#echo " I am in ${PWD} "

# 
# NOTE: obvioulsy, it wont work if the evtfiledir is empty or doesn't exist
#       alternatively one may compose files names explicitly (e.g. from 0 to 31)
#
# ---> nfiles=`/bin/ls -alF ${rundirname}/*.root | wc -l`
# NOTE: Or maybe just as follows ???
# nfiles=`/bin/ls -alF ${rundirname}/*.root | wc -l`
#
nfiles=`/bin/ls -alF ${evtfiledir}/*.root | wc -l`

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
# ---> evtrootfile_list=`/bin/ls -alF ${rundirname}/*.root | awk '{print $NF}'`
evtrootfile_list=`/bin/ls -alF ${evtfiledir}/*.root | awk '{print $NF}'`
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

LOGDIR=${G4ParamTest}/ProdScripts/SLURM-shell
LOGFILE=${LOGDIR}/LOG_ANA_${SLURM_JOB_ID}_${proc_level}_${beam}${momz}GeV_${target}.log
art -c ${config} >& ${LOGFILE}

# NOW NEED TO 
# --> TAR OUTPUT
# --> TRANSFERE OUTPUT TO /lfstev
# --> CLEANUP

TARFILE=${rundirname}/analysis_${proc_level}_${beam}${momz}GeV_${target}.tgz
tar zcf ${TARFILE} ${ts_filename}.root *.fcl


DATE=`date +"%m-%d-%y"`
G4VMP_OUT="/lustre1/g4/yarba_j/g4vmp-study"
if [ ! -d "${G4VMP_OUT}/${DATE}" ]; then
mkdir ${G4VMP_OUT}/${DATE}
fi
if [ ! -d "${G4VMP_OUT}/${DATE}/analysis_${proc_level}_${beam}_${experiment}" ]; then
mkdir ${G4VMP_OUT}/${DATE}/analysis_${proc_level}_${beam}_${experiment}
fi

# --> fcp -c /usr/bin/rcp ${TARFILE} ibtevnfsg4:/lfstev/g4p/yarba_j/g4studies/${CURRENTDATE}/analysis_${proc_level}_${beam}_HARP
rsync -h -z --progress ${TARFILE} ${G4VMP_OUT}/${DATE}/analysis_${proc_level}_${beam}_${experiment}

/bin/rm -rf ${rundirname}

exit


