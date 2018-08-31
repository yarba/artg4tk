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


# IAEA part
#
sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=C,momz=3.824,NUniv=100,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=Fe,momz=3.824,NUniv=100,maxevents=15625" \
	-A g4p simulate_multiU.sh
sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=Pb,momz=3.824,NUniv=100,maxevents=15625" \
	-A g4p simulate_multiU.sh

# HARP part
#
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=C,momz=5.0,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=Cu,momz=5.0,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=Pb,momz=5.0,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh

#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=C,momz=8.0,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=Cu,momz=8.0,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=Pb,momz=8.0,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh

# ITEP771 part to complement 8GeV HARP data with results on proton/neutron production 
#
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=C,momz=7.5,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=Cu,momz=7.5,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh
#sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=Bertini,beam=proton,pdgcode=2212,target=Pb,momz=7.5,NUniv=100,maxevents=15625" \
#	-A g4p simulate_multiU.sh

