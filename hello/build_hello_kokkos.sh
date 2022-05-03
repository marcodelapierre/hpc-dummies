#!/bin/bash

# Topaz
#kokkos_dir="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos/apps"
#module load cmake/3.18.0
#module load openmpi-ucx-gpu/4.0.2

# Zeus
kokkos_dir="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-zeus/apps"
module swap sandybridge broadwell
module load cmake/3.18.0
module swap gcc gcc/8.3.0
module load openmpi/2.1.2

rm -f hello_kokkos*.x
rm -rf build && mkdir build && cd build

cmake .. \
  -DCMAKE_CXX_COMPILER=mpicxx \
  -DKokkos_ROOT="$kokkos_dir" \
  -DKokkos_DIR="$kokkos_dir/lib64/cmake/Kokkos"

make
cp -p hello_kokkos*.x ..
cd ..

