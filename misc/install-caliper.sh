#!/bin/bash -l
#SBATCH --account=pawsey0001
#SBATCH --partition=gpuq-dev
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:20:00
#SBATCH --output=%x.out

#echo $SLURM_JOB_NAME

download_caliper="0"
caliper_version="v2.7.0"

module load cuda/11.4.2
module load openmpi-ucx-gpu/4.0.2
module load cmake/3.18.0

if [ "$download_caliper" != "0" ] ; then
 git clone git@github.com:llnl/caliper
fi

cd caliper
git checkout $caliper_version

mkdir build
cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/../apps \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DCMAKE_C_COMPILER=mpicc \
  -DCMAKE_Fortran_COMPILER=mpif90 \
  -DWITH_FORTRAN=on \
  -DWITH_MPI=on \
  -DWITH_NVTX=on \
  -DWITH_CUPTI=on \
  -DWITH_KOKKOS=on

make -j $SLURM_CPUS_PER_TASK
sg pawsey0001 -c 'make install'

