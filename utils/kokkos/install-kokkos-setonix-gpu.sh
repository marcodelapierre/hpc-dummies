#!/bin/bash -l
#SBATCH --job-name=install-kokkos-setonix-gpu
#SBATCH --account=pawsey0001-gpu
#SBATCH --partition=gpu-dev
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --threads-per-core=1
#SBATCH --gpus-per-node=8
#SBATCH --time=00:30:00
#SBATCH --output=out-%x

download_kokkos="0"
kokkos_version="3.7.02"
suffix="-setonix-gpu"

module load rocm/5.0.2
module load craype-accel-amd-gfx90a
module load cmake/3.21.4
export CRAYPE_LINK_TYPE="dynamic"

if [ "$download_kokkos" != "0" ] ; then
 rm -rf kokkos-cpu
 git clone git@github.com:kokkos/kokkos kokkos$suffix
fi

cd kokkos$suffix
git checkout $kokkos_version

mkdir build
cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/../apps \
  -DCMAKE_CXX_COMPILER=hipcc \
  -DKokkos_ENABLE_OPENMP=On \
  -DKokkos_ENABLE_HIP=On \
  -DKokkos_ARCH_ZEN3=On \
  -DKokkos_ARCH_VEGA90A=On \
  -DKokkos_ENABLE_HIP_MULTIPLE_KERNEL_INSTANTIATIONS=On \
  -DKokkos_ENABLE_EXAMPLES=On

make -j $SLURM_CPUS_PER_TASK
sg pawsey0001 -c 'make install'


