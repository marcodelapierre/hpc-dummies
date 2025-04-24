#!/bin/bash -l
#SBATCH -J STRESS
#SBATCH --time=18:10:00
#SBATCH --mem-per-cpu=3000M
#SBATCH -n 1
#SBATCH --cpus-per-task=128

srun stress-ng --cpu "$SLURM_CPUS_PER_TASK" --vm-bytes 3000M --timeout 18h
