#!/bin/bash -l
#SBATCH --job-name=install-kokkos-setonix-cpu
#SBATCH --account=pawsey0001
#SBATCH --partition=debug
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --threads-per-core=1
#SBATCH --time=00:30:00
#SBATCH --output=out-%x

download_kokkos="0"
kokkos_version="3.7.02"
suffix="-setonix-cpu"

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
  -DCMAKE_CXX_COMPILER=CC \
  -DKokkos_ENABLE_OPENMP=On \
  -DKokkos_ARCH_ZEN3=On \
  -DKokkos_ENABLE_EXAMPLES=On

make -j $SLURM_CPUS_PER_TASK
sg pawsey0001 -c 'make install'


