#!/usr/bin/env bash
#
# cleanup logs/err from earlier rounds
#
# ---> /bin/rm -f slurm*.out

sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=3.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=3.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=3.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh

sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=5.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=5.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=5.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh

#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=5.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=5.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=5.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh

#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=C,momz=8.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Cu,momz=8.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,target=Pb,momz=8.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh

sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=3.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=3.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=3.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh

#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=5.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=5.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=5.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh

#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=8.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=8.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=8.0,experiment=HARP,NUniv=50" -A g4p analyze_multiU.sh

sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=3.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=3.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=3.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh

#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=C,momz=5.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh
#sbatch -p amd32_g4val_slow -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Cu,momz=5.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,target=Pb,momz=5.0,experiment=ITEP,NUniv=50" -A g4p analyze_multiU.sh



