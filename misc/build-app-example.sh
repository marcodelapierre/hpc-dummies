#!/bin/bash -l
#SBATCH --account=pawsey0001
#SBATCH --partition=gpuq-dev
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:20:00
#SBATCH --output=%x.out

#echo $SLURM_JOB_NAME

download_tutorials="0"
kokkos_dir="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos/apps"

module load cuda/11.4.2
module load openmpi-ucx-gpu/4.0.2
module load cmake/3.18.0

if [ "$download_tutorials" != "0" ] ; then
 git clone git:kokkos/kokkos-tutorials
fi

cd kokkos-tutorials
cd Exercises/01/Begin

mkdir build
cd build

cmake .. \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DKokkos_ROOT="$kokkos_dir" \
  -DKokkos_DIR="$kokkos_dir/lib64/cmake/Kokkos"

make

