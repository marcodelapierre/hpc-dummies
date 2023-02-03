#!/bin/bash

download_kokkos="1"
kokkos_version="3.5.00"

if [ "$download_kokkos" != "0" ] ; then
 rm -rf kokkos
 git clone git@github.com:kokkos/kokkos kokkos
fi

cd kokkos
git checkout $kokkos_version

mkdir build
cd build

cmake .. \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/../apps \
  -DCMAKE_CXX_COMPILER=g++-12 \
  -DKokkos_ENABLE_OPENMP=On \
  -DKokkos_ARCH_ARMV81=On \
  -DKokkos_ENABLE_EXAMPLES=On

make
make install
