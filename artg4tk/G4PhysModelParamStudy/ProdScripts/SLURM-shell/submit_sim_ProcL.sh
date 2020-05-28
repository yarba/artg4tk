#!/usr/bin/env bash
#
# cleanup logs/err from earlier rounds
#
# ---> not now ---> /bin/rm -f slurm*.out

### Intermediate energy range ---> total of 42 jobs 

nuni=${1}

if [ "x" == "x$nuni" ]; then
echo " You must supply the number of universes (variants) as the 1st input argument; bail out"
exit
fi

# HARP/ITEP771/Ishibshi part
#
# 3GeV/c p, pi-, or pi+ on C, Cu, or Pb 
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=3.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=3.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=3.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=3.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# 
# NOTE-1 (09/08/19): 5 files in 08/07 & 27 files in 08/08
# NOTE-2 (09/09/19): the 5 files from 08/07 have been also copied over to 08/08
#
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=3.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=3.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# 3.824Gev/c p on C, Fe, or Pb 
# NOTE: NO Ishibashi data on Cu; Fe is the closest
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=3.824,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Fe,momz=3.824,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=3.824,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# 5GeV/c p on C, Cu, or Pb 
#
# sbatch -p lq1csl -N1 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	sim_multiU_lq.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=5.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=5.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# sbatch -p lq1csl -N1 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	sim_multiU_lq.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=5.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=5.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# TRY NEW APPROACH (per Amitoj S.)
#
# NOTE: direct use or mpirun and/or parallel does NOT help 
#       as all jobs still land on one core (maybe two at best)
#
# sbatch --ntasks-per-node=40 --oversubscribe --exclusive -N 1 -p gpu --qos=normal -t 23:00:00 \
# 	--export="WORKDIR_TOP=${MRB_TOP},App=sim_multiU_lq.sh,proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=5.0,NUniv=${nuni},maxevents=12500" \
#	slurm_multiU_master_mpi.sh
#
# ... AND NOW SLIGHTLY DIFFERENT (per Krzysztof G.)
#
# Carbon (C) target nucleus
#
# sbatch --ntasks-per-node=40 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=5.0,NUniv=${nuni},maxevents=12500" \
#	slurm_multiU_master.sh sim_multiU_lq.sh
#
# Lead (Pb) target nucleus
#
# proton
# sbatch --ntasks-per-node=40 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=5.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
# pi+
# sbatch --ntasks-per-node=40 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=5.0,NUniv=${nuni},maxevents=25000" \
	slurm_multiU_master.sh sim_multiU_lq_update_1.sh
# pi+
# sbatch --ntasks-per-node=40 -p lq1csl --account=g4 --exclusive \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=5.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update_1.sh

#
#
# sbatch -p gpu --gres=gpu:2 --qos=normal -N1 -t 23:00:00 \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=5.0,NUniv=${nuni},nevtotal=500000" \
#	sim_multiU_lq.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=5.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=5.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# 7.5GeV/c proton on C, Cu, or Pb 
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=7.5,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00 \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=7.5,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=7.5,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# 8GeV/c p, pi-, or pi+ on C, Cu, or Pb 
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=8.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=8.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=8.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=8.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=8.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=8.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# 12GeV/c p, pi-, or pi+ on C, Cu, or Pb 
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
# 	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=12.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=12.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=12.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=12.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=12.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=12.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# NA61
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=31.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# SAS M6E
#
# NOTE: perhaps we need to do some of these in the amd32_g4val_slow
#       where the default CPU limit is 48hrs;
#       in order to get default, do NOT specify any time rqeurements; 
#       the list of node asssociated with amd32_g4val_slow:
#       tev0301,tev0302,tev0303,tev0304,tev0305,
#       tev0306,tev0307,tev0308,tev0309,tev0310,tev0311,
#       tev0404,tev0405
# Example usage of explicit node(s): --nodelist=tev0301
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=100.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=100.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

# NOTE: both jobs bail out in amd32_g4val_slow,
#       from tev0301 and tev0302 respectively
#       due to CPU limit
#       apparently the defaut CPU has been set 
#       to 8 hours everywhere, incl. this queue,
#       although in the past it used to be 48 hours;
#       submitting with -t 48:00:00 results in status
#       PD with reason "AssocMaxWallDurationPerJobLimit"
#
#       ... ehhhh, did the 2nd run in amd32_g4val_slow 
#       or just amd32 ????
#
#       all in all, we'll give it a try in amd32 
#       even for Pb target since FTF doesn't scale CPU
#       with the target's A as badly as Bertini does
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=100.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
#sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=100.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh

#sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=100.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
#
# all jobs OK 08-04
#
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=100.0,NUniv=${nuni},nevtotal=500000" \
#	-A g4p sim_multiU.sh


# NA49
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=158.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
