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
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv=${nuni}" \
#	-A g4p ana_HARP_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-18-19,NUniv=${nuni}" \
	-A g4p ana_HARP_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-18-19,NUniv=${nuni}" \
	-A g4p ana_HARP_multiU.sh

# ITEP771
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv=${nuni}" \
#	-A g4p ana_ITEP_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piminus,pdgcode=-211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-18-19,NUniv=${nuni}" \
	-A g4p ana_ITEP_multiU.sh
sbatch -p amd32 -N1 -t 24:00:00 \
	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=piplus,pdgcode=211,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/09-18-19,NUniv=${nuni}" \
	-A g4p ana_ITEP_multiU.sh

# IAEA/Ishibashi
#
# sbatch -p amd32 -N1 -t 24:00:00 \
#	--export="WORKDIR_TOP=${MRB_TOP},proc_level=FTFP,beam=proton,pdgcode=2212,PATH2EVT=/lfstev/g4p/yarba_j/g4studies/06-13-19,NUniv=${nuni}" \
#	-A g4p ana_IAEA_multiU.sh


# NA61
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
