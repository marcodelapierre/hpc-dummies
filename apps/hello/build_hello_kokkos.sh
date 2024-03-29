#!/bin/bash

target="${target:-setonix-gpu}"
cmake_cxx="g++"

binary_name="hello_kokkos"

if [ $target == "setonix-gpu" ] ; then
  Kokkos_ROOT="/software/projects/pawsey0001/mdelapierre/setonix/manual/kokkos-setonix-gpu/apps"
  module load rocm/5.0.2
  module load craype-accel-amd-gfx90a
  module load cmake/3.21.4
  export CRAYPE_LINK_TYPE="dynamic"
  export cmake_cxx="hipcc"
elif [ $target == "setonix-cpu" ] ; then
  Kokkos_ROOT="/software/projects/pawsey0001/mdelapierre/setonix/manual/kokkos-setonix-cpu/apps"
  module load cmake/3.21.4
  export CRAYPE_LINK_TYPE="dynamic"
  export cmake_cxx="CC"
elif [ $target == "topaz-gpu" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos/apps"
  module load cmake/3.18.0
  module load cuda/11.4.2
elif [ $target == "topaz-cpu" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-cpu/apps"
  module load cmake/3.18.0
elif [ $target == "zeus" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-zeus/apps"
  module load cmake/3.18.0
  module swap sandybridge broadwell
  module swap gcc gcc/8.3.0
elif [ $target == "mac-cpu" ] ; then
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
