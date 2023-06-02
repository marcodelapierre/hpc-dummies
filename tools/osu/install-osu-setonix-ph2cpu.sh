#!/bin/bash

#module switch PrgEnv-cray PrgEnv-gnu
export CRAYPE_LINK_TYPE=dynamic


OSU_BENCH_VERSION="5.4.2"

INSTALL_DIR="$(pwd)/osu-${OSU_BENCH_VERSION}-ph2cpu"

OSU_BENCH_CONFIGURE_OPTIONS="--prefix=$INSTALL_DIR CC=cc CXX=CC CFLAGS=-O3"
OSU_BENCH_MAKE_OPTIONS="-j8"

if [ ! -e osu-micro-benchmarks-${OSU_BENCH_VERSION}.tar.gz ] ; then
  wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OSU_BENCH_VERSION}.tar.gz
fi
tar xzvf osu-micro-benchmarks-${OSU_BENCH_VERSION}.tar.gz

mv osu-micro-benchmarks-${OSU_BENCH_VERSION} osu-micro-benchmarks-${OSU_BENCH_VERSION}-ofi-ph2cpu
cd osu-micro-benchmarks-${OSU_BENCH_VERSION}-ofi-ph2cpu

./configure ${OSU_BENCH_CONFIGURE_OPTIONS}
make ${OSU_BENCH_MAKE_OPTIONS}
make install


# to run
export OSU_INSTALL_DIR="/software/projects/pawsey0001/mdelapierre/setonix/manual/osu-5.4.2-ph2cpu"
export PATH="${OSU_INSTALL_DIR}/libexec/osu-micro-benchmarks/mpi/startup:${PATH}"
export PATH="${OSU_INSTALL_DIR}/libexec/osu-micro-benchmarks/mpi/pt2pt:${PATH}"
export PATH="${OSU_INSTALL_DIR}/libexec/osu-micro-benchmarks/mpi/one-sided:${PATH}"
export PATH="${OSU_INSTALL_DIR}/libexec/osu-micro-benchmarks/mpi/collective:${PATH}"
