#!/bin/bash

#module swap PrgEnv-gnu/8.3.3 PrgEnv-cray
module load rocm/5.0.2
module load craype-accel-amd-gfx90a
export CRAYPE_LINK_TYPE=dynamic
export MPICH_GPU_SUPPORT_ENABLED=1

OSU_BENCH_VERSION="7.1"  #"5.6.3"

INSTALL_DIR="$(pwd)/osu-${OSU_BENCH_VERSION}-ph2GPU"

if [ ! -e osu-micro-benchmarks-${OSU_BENCH_VERSION}.tar.gz ] ; then
  wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OSU_BENCH_VERSION}.tar.gz
fi
tar xzvf osu-micro-benchmarks-${OSU_BENCH_VERSION}.tar.gz

mv osu-micro-benchmarks-${OSU_BENCH_VERSION} osu-micro-benchmarks-${OSU_BENCH_VERSION}-ofi-ph2GPU
cd osu-micro-benchmarks-${OSU_BENCH_VERSION}-ofi-ph2GPU

#./configure ${OSU_BENCH_CONFIGURE_OPTIONS}
./configure --prefix=$INSTALL_DIR CC=hipcc CXX=hipcc \
  CPPFLAGS=-I${MPICH_DIR}/include \
  LDFLAGS="-L${MPICH_DIR}/lib -L${CRAY_MPICH_ROOTDIR}/gtl/lib" \
  LIBS="-lmpi -lmpi_gtl_hsa" \
  CFLAGS=-O3 \
  --enable-rocm --with-rocm=$ROCM_PATH

make -j8

make install


# to run
export MPICH_GPU_SUPPORT_ENABLED=1
export OSU_INSTALL_DIR="/software/projects/pawsey0001/mdelapierre/setonix/manual/osu-7.1-ph2GPU"
export PATH="${OSU_INSTALL_DIR}/libexec/osu-micro-benchmarks/mpi/startup:${PATH}"
export PATH="${OSU_INSTALL_DIR}/libexec/osu-micro-benchmarks/mpi/pt2pt:${PATH}"
export PATH="${OSU_INSTALL_DIR}/libexec/osu-micro-benchmarks/mpi/one-sided:${PATH}"
export PATH="${OSU_INSTALL_DIR}/libexec/osu-micro-benchmarks/mpi/collective:${PATH}"
