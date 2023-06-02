#!/bin/bash -l
#SBATCH --job-name=bare
#SBATCH --output=%x.out
#SBATCH --account=pawsey0012
#SBATCH --partition=work
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --threads-per-core=1
#SBATCH --exclusive
#SBATCH --time=00:30:00
#SBATCH --export=NONE 

export OMP_NUM_THREADS=1
BARE_OSU="/software/projects/pawsey0001/mdelapierre/setonix/manual/osu-5.4.2-ph2cpu/libexec/osu-micro-benchmarks/mpi"

srun --export=all --exact -c 1 -n 1 -N 1 ldd $BARE_OSU/collective/osu_allgather

echo " "
echo " "

srun --export=all --exact -c 1 -n 2 -N 2 $BARE_OSU/collective/osu_allgather -m 2:4194304

echo " "
echo " "

srun --export=all --exact -c 1 -n 2 -N 2 $BARE_OSU/collective/osu_allreduce -m 2:4194304

echo " "
echo " "

srun --export=all --exact -c 1 -n 2 -N 1 $BARE_OSU/pt2pt/osu_latency -m 2:4194304

