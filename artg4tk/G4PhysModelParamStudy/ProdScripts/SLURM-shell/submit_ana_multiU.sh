#!/usr/bin/env bash
#

nuni=${1}

if [ "x" == "x$nuni" ]; then
echo " You must supply the number of universes (variants) as the 1st input argument; bail out"
exit
fi

# NOTE: Perhaps it'd be more efficient to make PATH2EVT an input arg...

# HARP
#
# LQ1
#
# Note (03-12-2020): already running for 100 variants... 
#
# proton
sbatch --ntasks-per-node=2 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lustre1/g4/yarba_j/g4vmp-study/09-10-20,NUniv=${nuni}" \
	slurm_multiU_master.sh ana_HARP_multiU_lq.sh
# pi+
# ---> sbatch --ntasks-per-node=1 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 \
#sbatch --ntasks-per-node=12 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,PATH2EVT=/lustre1/g4/yarba_j/g4vmp-study/04-14-20-sim-combined,NUniv=${nuni}" \
#	slurm_multiU_master.sh ana_HARP_multiU_lq.sh
# pi-
#sbatch --ntasks-per-node=12 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive  \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,PATH2EVT=/lustre1/g4/yarba_j/g4vmp-study/04-14-20-sim-combined,NUniv=${nuni}" \
#	slurm_multiU_master.sh ana_HARP_multiU_lq.sh
#
# Wilson/SLURM
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv=${nuni}" \
#	-A g4p ana_HARP_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-18-19,NUniv=${nuni}" \
#	-A g4p ana_HARP_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-18-19,NUniv=${nuni}" \
#	-A g4p ana_HARP_multiU.sh

# ITEP771
#
# LQ1
#
# proton
#sbatch --ntasks-per-node=6 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lustre1/g4/yarba_j/g4vmp-study/07-09-20-sim-combined,NUniv=${nuni}" \
#	slurm_multiU_master.sh ana_ITEP_multiU_lq.sh
# pi+
#sbatch --ntasks-per-node=1 -p lq1csl --account=g4 \
#sbatch --ntasks-per-node=3 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,PATH2EVT=/lustre1/g4/yarba_j/g4vmp-study/04-14-20-sim-combined,NUniv=${nuni}" \
#	slurm_multiU_master.sh ana_ITEP_multiU_lq.sh
# pi-
#sbatch --ntasks-per-node=1 -p lq1csl --account=g4 \
#sbatch --ntasks-per-node=3 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,PATH2EVT=/lustre1/g4/yarba_j/g4vmp-study/04-14-20-sim-combined,NUniv=${nuni}" \
#	slurm_multiU_master.sh ana_ITEP_multiU_lq.sh

#
# Wilson/SLURM
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv=${nuni}" \
#	-A g4p ana_ITEP_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-18-19,NUniv=${nuni}" \
#	-A g4p ana_ITEP_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-18-19,NUniv=${nuni}" \
#	-A g4p ana_ITEP_multiU.sh

# IAEA/Ishibashi
#
# proton
#
#
#  LQ1
#
#sbatch --ntasks-per-node=3 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lustre1/g4/yarba_j/g4vmp-study/07-09-20-sim-combined,NUniv=${nuni}" \
#	slurm_multiU_master.sh ana_IAEA_multiU_lq.sh
#
# Wilson/SLURM
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv=${nuni}" \
#	-A g4p ana_IAEA_multiU.sh


# NA61
#
# LQ1
#
sbatch --ntasks-per-node=1 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lustre1/g4/yarba_j/g4vmp-study/09-10-20,NUniv=${nuni}" \
	slurm_multiU_master.sh ana_NA61_multiU_lq.sh
#
# Wislon/SLURM
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv=${nuni}" \
#	-A g4p ana_NA61_multiU.sh

# NA49
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv={$nuni}" \
#	-A g4p ana_NA49_multiU.sh

# SAS M6E
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv=${nuni}" \
#	-A g4p ana_SASM6E_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-10-19-sim-combined,NUniv=${nuni}" \
#	-A g4p ana_SASM6E_multiU.sh
