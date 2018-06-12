#!/usr/bin/env bash
#
# cleanup logs/err from earlier rounds
#
/bin/rm -f slurm*.out

sbatch -p amd32_g4val_slow -N1 --array=0-31 -t 24:00:00 --export="WORKDIR_TOP=${MRB_TOP},target=C,momz=5.0,maxevents=50000" -A g4p FTFP_multiU.sh
