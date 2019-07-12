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
# 3GeV/c p, pi-, or pi+ on C, Cu, or Pb (9jobs; 8 jobs OK, 1 messed up)
#
#sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
#sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
#sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=3.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# 3.824Gev/c p on C, Fe, or Pb (3 jobs; 2 jobs OK, 1 is of unknown fate, perhaps "hang")
# NOTE: NO Ishibashi data on Cu; Fe is the closest
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=3.824,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Fe,momz=3.824,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
#

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=3.824,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# 5GeV/c p on C, Cu, or Pb (9 jobs, 6 are good and 3 problematic)
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=5.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# 7.5GeV/c on C, Cu, or Pb (3 jobs, 2 of them OK and 1 problematic)
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

# 8GeV/c p, pi-, or pi+ on C, Cu, or Pb (9 jobs, 5 are OK and 4 problematic)
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=8.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# 12GeV/c p, pi-, or pi+ on C, Cu, or Pb (9 jobs; all 9 are OK !!!)
#
# sbatch -p amd32 -N1 -t 24:00:00 \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
# 	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
# sbatch -p amd32 -N1 -t 24:00:00  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=12.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# NA61
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=31.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

# SAS M6E
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
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=100.0,NUniv=${nuni},nevtotal=1000000" \
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
# sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=100.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh

#sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=100.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
#sbatch -p amd32_g4perf --qos=g4perf -N1 -t 47:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=100.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh


# NA49
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=158.0,NUniv=${nuni},nevtotal=1000000" \
#	-A g4p sim_multiU.sh
