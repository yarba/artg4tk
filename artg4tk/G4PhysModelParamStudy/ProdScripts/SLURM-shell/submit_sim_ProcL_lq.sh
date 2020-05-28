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
# 3GeV/c proton on C, Cu, Pn
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=3.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=3.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=3.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#
# 3GeV/c pi+ on C, Cu, or Pb
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=3.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=3.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=3.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#
# 3GeV/c pi- on C, Cu, or Pb
#
# sbatch --ntasks-per-node=40 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=3.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=3.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=3.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh

# 3.824Gev/c p on C, Fe, or Pb 
# NOTE: NO Ishibashi data on Cu; Fe is the closest
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=3.824,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Fe,momz=3.824,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=3.824,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh

# 5GeV/c p on C, Cu, or Pb 
#
# 5GeV/c proton on C, Cu, Pb 
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=5.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=5.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=5.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#
# 5GeV/c pi+ on C, Cu, or Pb
#
# sbatch --ntasks-per-node=40 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=5.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=5.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=5.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh

# 5GeV/c pi- on C, Cu, or Pb
#
# sbatch --ntasks-per-node=40 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=5.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=5.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=5.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh

# 7.5GeV/c proton on C, Cu, Pb
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=7.5,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=7.5,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=7.5,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh

#
# 8GeV/c p, pi-, or pi+ on C, Cu, or Pb 
#
# 8GeV/c proton on C, Cu, Pb
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=8.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=8.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=8.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#
# 8GeV/c pi+ on C, Cu, or Pb
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=8.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=8.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=8.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#
# 8GeV/c pi- on C, Cu, or Pb
#
# sbatch --ntasks-per-node=40 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=8.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=8.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=8.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh

#
# 12GeV/c p, pi-, or pi+ on C, Cu, or Pb 
#
# 12GeV/c proton on C, Cu, Pb
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=12.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=12.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=12.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#
# 12GeV/c pi+ on C, Cu, or Pb
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=12.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=12.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=12.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#
# 12GeV/c pi- on C, Cu, or Pb
#
# sbatch --ntasks-per-node=40 --time=23:00:00 --gres=gpu:0 -p gpu --qos=normal --account=g4 --exclusive \
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=12.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=12.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=12.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh

# NA61
#
# 31GeV/c proton on C
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=31.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh

# SAS M6E 
#
# 100GeV/c proton, pi+ on C, Cu, Pb
#
# 100GeV/c proton on C, Cu, Pb
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=100.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Cu,momz=100.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=100.0,NUniv=${nuni},maxevents=18750" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
#
# 100GeV/c pi+ on C, Cu, Pb
#
sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=100.0,NUniv=${nuni},maxevents=25000" \
	slurm_multiU_master.sh sim_multiU_lq_update.sh
sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=100.0,NUniv=${nuni},maxevents=25000" \
	slurm_multiU_master.sh sim_multiU_lq_update.sh
sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=100.0,NUniv=${nuni},maxevents=18750" \
	slurm_multiU_master.sh sim_multiU_lq_update.sh

# NA49
#
# 158GeV/c proton on C
#
#sbatch --ntasks-per-node=40  -p lq1csl --account=g4 --exclusive \
# 	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=158.0,NUniv=${nuni},maxevents=25000" \
#	slurm_multiU_master.sh sim_multiU_lq_update.sh
