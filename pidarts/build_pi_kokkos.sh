#!/bin/bash

target="topaz-cpu"
binary_name="pi_kokkos"
cmake_cxx="g++"

if [ $target == "topaz-gpu" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos/apps"
  module load cmake/3.18.0
  module load cuda/10.1
elif [ $target == "topaz-cpu" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-cpu/apps"
  module load cmake/3.18.0
elif [ $target == "zeus" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-zeus/apps"
  module load cmake/3.18.0
  module swap sandybridge broadwell
  module swap gcc gcc/8.3.0
elif [ $target == "topaz-cpu-mac" ] ; then
  Kokkos_ROOT="$HOME/software/kokkos/apps"
  cmake_cxx="g++-12"
else
  echo "Wrong target, exiting."
  exit 1
fi

rm -f ${binary_name}*.x
rm -rf build && mkdir build && cd build

cmake .. \
  -DCMAKE_CXX_COMPILER="$cmake_cxx" \
  -DCMAKE_PREFIX_PATH="$Kokkos_ROOT" #\
#  -DKokkos_ROOT="$kokkos_dir/lib64/cmake/Kokkos"

make
cp -p ${binary_name}*.x ..
cd ..
rm -rf build
