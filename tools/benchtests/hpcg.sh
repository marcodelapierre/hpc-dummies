#!/bin/bash -l
#SBATCH -J HPCG
#SBATCH --time=00:30:00
#SBATCH --mem-per-cpu=3000M
#SBATCH -n 128
#SBATCH --cpus-per-task=1

module load HPCG
export OMP_NUM_THREADS="$SLURM_CPUS_PER_TASK"

# Further details on parameters for AMD CPUs:
# https://www.amd.com/en/developer/zen-software-studio/applications/spack/hpcg-benchmark.html

# Size of 144 to occupy about 2GB of RAM per task
srun xhpcg 144 144 144  180
