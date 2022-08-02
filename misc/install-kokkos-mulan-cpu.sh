#!/bin/bash -l
#SBATCH --account=pawsey0001
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --threads-per-core=1
#SBATCH --time=00:20:00
#SBATCH --output=%x.out

#echo $SLURM_JOB_NAME

download_kokkos="0"
kokkos_version="3.5.00"

module unload gcc/9.3.0
. /pawsey/mulan/bin/init-cmake-3.21.4.sh

if [ "$download_kokkos" != "0" ] ; then
 rm -rf kokkos
 git clone git:kokkos/kokkos kokkos-mulan-cpu
fi

cd kokkos-mulan-cpu
git checkout $kokkos_version

mkdir build
cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/../apps \
  -DCMAKE_CXX_COMPILER=g++ \
  -DKokkos_ENABLE_OPENMP=On \
  -DKokkos_ARCH_ZEN=On \
  -DKokkos_ENABLE_EXAMPLES=On

make -j $SLURM_CPUS_PER_TASK
sg pawsey0001 -c 'make install'

