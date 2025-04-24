#!/bin/bash -l
#SBATCH -J OSU
#SBATCH --time=00:10:00
#SBATCH --mem-per-cpu=2G
#SBATCH -n 2
#SBATCH --ntasks-per-node=1
#SBATCH -N 2

module load OSU-Micro-Benchmarks

srun osu_latency

srun osu_bw
