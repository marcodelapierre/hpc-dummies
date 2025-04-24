#!/bin/bash -l
#SBATCH -J STREAM
#SBATCH --time=00:30:00
#SBATCH --mem-per-cpu=9025M
#SBATCH -n 1 
#SBATCH --cpus-per-task=8

ml STREAM/5.10-GCC-13.3.0
export OMP_NUM_THREADS="$SLURM_CPUS_PER_TASK"

# Further details on parameters for AMD CPUs:
# https://www.amd.com/en/developer/zen-software-studio/applications/spack/stream-benchmark.html

# Choose one command from:
# stream_1Kx200M  stream_1Kx100M  stream_1Kx10M  stream_1Kx1B  stream_1Kx2.5B  stream_1Kx5B
srun stream_1Kx200M
