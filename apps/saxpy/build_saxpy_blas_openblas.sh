#!/bin/bash

OPENBLAS_HOME=/home/mdelapierre/apps/spack/opt/spack/linux-ubuntu24.04-zen3/gcc-13.2.0/openblas-0.3.28-5znjgitwfndvafu4krxygunohyoiwa2r

CPATH=$(pwd)/../include

g++ -O3 -funroll-loops -march=native \
  -L$OPENBLAS_HOME/lib -Wl,--disable-new-dtags,-rpath,$OPENBLAS_HOME/lib \
  saxpy_blas.cpp -o saxpy_blas.x \
  -lopenblas
