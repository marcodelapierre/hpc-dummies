#!/bin/bash -l
#SBATCH --job-name=jobstep
#SBATCH --output=%x.out
#SBATCH --account=pawsey0012-gpu
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --threads-per-core=1
#SBATCH --gpus-per-node=8
#SBATCH --exclusive
#SBATCH --time=00:01:00
#SBATCH --export=NONE 

module load rocm/5.0.2
module load craype-accel-amd-gfx90a

for n in {1..8} ; do srun --exact -n $n --gpus-per-node=$n --gpu-bind=closest  ./hello_jobstep_hip.x ; echo " " ; done
