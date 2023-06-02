#!/bin/bash -l
#SBATCH --job-name=bare_all_setonix_GPU
#SBATCH --output=%x.out
#SBATCH --account=pawsey0012-gpu
#SBATCH --partition=gpu
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --threads-per-core=1
#SBATCH --gpus-per-node=8
#SBATCH --exclusive
#SBATCH --time=03:00:00
#SBATCH --export=NONE 

module load rocm/5.0.2
module load craype-accel-amd-gfx90a
export MPICH_GPU_SUPPORT_ENABLED=1

export OSU_INSTALL_DIR="/software/projects/pawsey0001/mdelapierre/setonix/manual/osu-7.1-ph2GPU"
export BARE_OSU="$OSU_INSTALL_DIR/libexec/osu-micro-benchmarks/mpi"

for t in bw latency ; do
 srun --exact -N 1 -n 2 --ntasks-per-node=2 --gpus-per-node=2 --gpu-bind=single:1 $BARE_OSU/../get_local_rank $BARE_OSU/pt2pt/osu_$t -m 2:4194304 D D > out_${t}_1nodes_rocm
 srun --exact -N 2 -n 2 --ntasks-per-node=1 --gpus-per-node=1 --gpu-bind=single:1 $BARE_OSU/../get_local_rank $BARE_OSU/pt2pt/osu_$t -m 2:4194304 D D > out_${t}_2nodes_rocm
done

for N in 2 4 ; do
 for nn in 1 2 4 8 ; do
  for t in bcast scatter allgather allreduce iallgather barrier ; do
   srun --exact -N $N -n $((N*nn)) --ntasks-per-node=$nn --gpus-per-node=$nn --gpu-bind=single:1 $BARE_OSU/../get_local_rank $BARE_OSU/collective/osu_$t -m 2:4194304 -d rocm > out_${t}_${N}nodes_$((N*nn))cores_rocm
  done
 done
done

