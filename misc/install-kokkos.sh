#!/bin/bash -l
#SBATCH --account=pawsey0001
#SBATCH --partition=gpuq-dev
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:20:00
#SBATCH --output=%x.out

#echo $SLURM_JOB_NAME

download_kokkos="0"
kokkos_version="3.5.00"

module load cmake/3.18.0
module load cuda/11.1

if [ "$download_kokkos" != "0" ] ; then
 rm -rf kokkos
 git clone git:kokkos/kokkos
fi

cd kokkos
git checkout $kokkos_version

mkdir build
cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/../apps \
  -DCMAKE_CXX_COMPILER=$(pwd)/../bin/nvcc_wrapper \
  -DKokkos_ENABLE_OPENMP=On \
  -DKokkos_ENABLE_CUDA=On \
  -DKokkos_ARCH_SKX=On \
  -DKokkos_ARCH_VOLTA70=On \
  -DKokkos_ENABLE_CUDA_LAMBDA=On \
  -DKokkos_ENABLE_EXAMPLES=On

make -j $SLURM_CPUS_PER_TASK
sg pawsey0001 -c 'make install'

