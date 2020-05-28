#!/usr/bin/env bash
#

node_name=`uname -n`

echo " node name = ${node_name} "

echo " App = ${App}"

module load intel
module load impi

# NOTE: unfortunately, the env.var. maxevents does NOT get exported this way
#       i.e. each individual job does NOT see it
#       instead I'll have to pass it through --export="..." field of sbatch
#       alternatively, I can pass it as an input argument to the run script,
#       and export from there for each job individually
#
# coresPerNode=`cat /proc/cpuinfo | grep -c processor`
# export maxevents==$(( nevtotal/coresPerNode ))
# export maxevents=$(( nevtotal/${SLURM_TASKS_PER_NODE} ))

echo " maxevents per core = ${maxevents}"

echo " WORKDIR_TOP = ${WORKDIR_TOP}"
echo " SLURM_SUBMIT_DIR = ${SLURM_SUBMIT_DIR}"

srun --mpi=pmi2 ${SLURM_SUBMIT_DIR}/${App}
# sun --mpi=pmi2 ${WORKDIR_TOP}/srcs/artg4tk/artg4tk/G4PhysModelParamStudy/ProdScripts/SLURM-shell/${App}

