#!/bin/bash -l
#SBATCH --account=pawsey0001
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --threads-per-core=1
#SBATCH --time=00:20:00
#SBATCH --output=%x.out

#echo $SLURM_JOB_NAME

download_kokkos="0"
kokkos_version="3.5.00"

# using Cray compiler
module unload gcc/9.3.0
module load craype-accel-amd-gfx908
module load rocm/4.5.0
. /pawsey/mulan/bin/init-cmake-3.21.4.sh

if [ "$download_kokkos" != "0" ] ; then
 rm -rf kokkos
 git clone git:kokkos/kokkos kokkos-mulan
fi

cd kokkos-mulan
git checkout $kokkos_version

mkdir build
cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/../apps \
  -DCMAKE_CXX_COMPILER=hipcc \
  -DKokkos_ENABLE_OPENMP=On \
  -DKokkos_ENABLE_HIP=On \
  -DKokkos_ARCH_ZEN2=On \
  -DKokkos_ARCH_VEGA908=On \
  -DKokkos_ENABLE_EXAMPLES=On
# Requires Kokkos 3.6.00
# -DKokkos_ENABLE_HIP_MULTIPLE_KERNEL_INSTANTIATIONS=On

make -j $SLURM_CPUS_PER_TASK
sg pawsey0001 -c 'make install'

