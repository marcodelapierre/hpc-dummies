#!/bin/bash

target="topaz-cpu"
binary_name="hello_kokkos"

if [ $target == "topaz-gpu" ] ; then
  kokkos_dir="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos/apps"
  module load cmake/3.18.0
  module load cuda/10.1
elif [ $target == "topaz-cpu" ] ; then
  kokkos_dir="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-cpu/apps"
  module load cmake/3.18.0
elif [ $target == "zeus" ] ; then
  kokkos_dir="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-zeus/apps"
  module load cmake/3.18.0
  module swap sandybridge broadwell
  module swap gcc gcc/8.3.0
else
  echo "Wrong target, exiting."
  exit 1
fi

rm -f ${binary_name}*.x
rm -rf build && mkdir build && cd build

cmake .. \
`#  -DCMAKE_CXX_COMPILER="g++"` \
  -DKokkos_ROOT="$kokkos_dir" \
  -DKokkos_DIR="$kokkos_dir/lib64/cmake/Kokkos"

make
cp -p ${binary_name}*.x ..
cd ..
rm -rf build
