#!/bin/bash -l
#SBATCH --job-name=bare_all_setonix
#SBATCH --output=%x.out
#SBATCH --account=pawsey0001
#SBATCH --partition=debug
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --threads-per-core=1
#SBATCH --exclusive
#SBATCH --time=01:00:00
#SBATCH --export=NONE 

#module switch PrgEnv-cray PrgEnv-gnu

export OMP_NUM_THREADS=1
BARE_OSU="/software/projects/pawsey0001/mdelapierre/setonix/manual/osu-5.4.2-ph2cpu/libexec/osu-micro-benchmarks/mpi"

N=1
for t in bw latency ; do
 srun --exact -c 1 -N $N -n 2 --ntasks-per-socket=1 \
  $BARE_OSU/pt2pt/osu_$t -m 2:4194304 > out_${t}_${N}nodes
done

N=2
for t in bw latency ; do
 srun --exact -c 1 -N $N -n 2 --ntasks-per-node=1 \
  $BARE_OSU/pt2pt/osu_$t -m 2:4194304 > out_${t}_${N}nodes
done

N=1
nn=2
for t in bcast scatter ibcast iscatter allgather allreduce iallgather barrier ; do
 srun --exact -c 1 -N $N -n $((N*nn)) --ntasks-per-socket=1 \
  $BARE_OSU/collective/osu_$t -m 2:4194304 > out_${t}_${N}nodes_$((N*nn))tasks
done

N=4
nn=1
for t in bcast scatter ibcast iscatter allgather allreduce iallgather barrier ; do
 srun --exact -c 1 -N $N -n $((N*nn)) --ntasks-per-node=1 \
  $BARE_OSU/collective/osu_$t -m 2:4194304 > out_${t}_${N}nodes_$((N*nn))tasks
done

N=1
nn=24
for t in bcast scatter ibcast iscatter allgather allreduce iallgather barrier ; do
 srun --exact -c 1 -N $N -n $((N*nn)) --ntasks-per-socket=12 \
  $BARE_OSU/collective/osu_$t -m 2:4194304 > out_${t}_${N}nodes_$((N*nn))tasks
done

N=4
nn=24
for t in bcast scatter ibcast iscatter allgather allreduce iallgather barrier ; do
 srun --exact -c 1 -N $N -n $((N*nn)) --ntasks-per-socket=12 --ntasks-per-node=24 \
  $BARE_OSU/collective/osu_$t -m 2:4194304 > out_${t}_${N}nodes_$((N*nn))tasks
done

