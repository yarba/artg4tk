#!/usr/bin/env bash
#
# cleanup logs/err from earlier rounds
#
# ---> not now ---> /bin/rm -f slurm*.out

#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=C,momz=5.0,NUniv=25,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,target=Pb,momz=5.0,nUniv=25,maxevents=15625" \
#	-A g4p simulate_multiU.sh


# HARP part
#
#sbatch -p amd32_g4val_slow -N1 --array=0-31  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=5.0,NUniv=50,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=5.0,NUniv=50,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=5.0,NUniv=50,maxevents=15625" \
#	-A g4p simulate_multiU.sh

#sbatch -p amd32_g4val_slow -N1 --array=0-31  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=8.0,NUniv=50,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=8.0,NUniv=50,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31  \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=8.0,NUniv=50,maxevents=15625" \
#	-A g4p simulate_multiU.sh

sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=3.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=3.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=3.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh

sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=3.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=3.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=3.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh

sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=5.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=5.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=5.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh

sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=8.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=8.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31  \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=8.0,NUniv=50,maxevents=15625" \
	-A g4p simulate_multiU.sh



