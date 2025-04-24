#!/bin/bash -l
#SBATCH -J MDTEST
#SBATCH --time=01:00:00
#SBATCH --ntasks=128
#SBATCH --mem-per-cpu=4513M

module load IOR

# Options
NUM_DIRS=16
NUM_PROCS=$SLURM_NTASKS
FILES_PER_DIR=$((128*1024 / ${NUM_DIRS} / ${NUM_PROCS}))
WORKDIR=$(pwd)/work_mdtest
mkdir -p $WORKDIR

srun mdtest -d ${WORKDIR} -b ${NUM_DIRS} -z 2 -i 5 -I ${FILES_PER_DIR}
