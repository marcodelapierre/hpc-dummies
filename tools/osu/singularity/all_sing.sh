#!/bin/bash -l
#SBATCH --job-name=sing
#SBATCH --output=%x.out
#SBATCH --account=pawsey0012
#SBATCH --partition=work
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --threads-per-core=1
#SBATCH --exclusive
#SBATCH --time=02:00:00
#SBATCH --export=NONE 

export OMP_NUM_THREADS=1

BARE_OSU="/usr/local/libexec/osu-micro-benchmarks/mpi"
IMAGE="mpich-base_3.4.3_ubuntu20.04.sif"

module load singularity/3.8.6-mpi

for N in 1 2 ; do
 for t in bw latency ; do
  srun --export=all --exact -c 1 -N $N -n 2 singularity exec $IMAGE $BARE_OSU/pt2pt/osu_$t -m 2:4194304 > out_${t}_${N}nodes
 done
done

for N in 1 3 ; do
 for nn in 1 32 128 ; do
  if [ $N -eq 1 -a $nn -eq 1  ] ; then
   continue
  fi
  if [ $N -eq 3 -a $nn -eq 128  ] ; then
   continue
  fi
  for t in bcast scatter allgather allreduce iallgather barrier ; do
   srun --export=all --exact -c 1 -N $N -n $((N*nn)) singularity exec $IMAGE $BARE_OSU/collective/osu_$t -m 2:4194304 > out_${t}_${N}nodes_$((N*nn))cores
  done
 done
done

