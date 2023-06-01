#!/bin/bash -l
#SBATCH --account=pawsey0001
#SBATCH --partition=gpuq-dev
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:20:00
#SBATCH --output=%x.out

#echo $SLURM_JOB_NAME

download_kernels="0"
kokkos_version="3.5.00"

module load cuda/11.4.2
module load cmake/3.18.0

if [ "$download_kernels" != "0" ] ; then
 rm -rf kokkos-kernels
 git clone git@github.com:kokkos/kokkos-kernels
fi

cd kokkos-kernels
git checkout $kokkos_version

mkdir build
cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/../apps \
  -DCMAKE_CXX_COMPILER=g++ \
  -DCMAKE_PREFIX_PATH=$(pwd)/../../kokkos/apps/lib64/cmake/Kokkos \
  -DKokkos_ROOT=$(pwd)/../../kokkos/apps

make -j $SLURM_CPUS_PER_TASK
sg pawsey0001 -c 'make install'

