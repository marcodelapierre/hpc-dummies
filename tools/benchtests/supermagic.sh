#!/bin/bash -l
#SBATCH -J SuperMagic
#SBATCH --time=02:00:00
#SBATCH --mem-per-cpu=800M
#SBATCH -n 512
#SBATCH --ntasks-per-node=128
#SBATCH -N 4

module load supermagic

workdir=$(pwd)/work_supermagic
mkdir -p $workdir

srun supermagic -a -m 100k -w $workdir -n 1
