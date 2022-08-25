#!/bin/bash

target="topaz-gpu"
verbose_make="0"
cmake_cxx="g++"
cmake_cxx_flags="-g -O3"
cmake_build_type="Release"
#cmake_build_type="RelWithDebInfo"

binary_name="saxpy2_kokkos"

if [ $target == "topaz-gpu" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos/apps"
  Caliper_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/caliper/apps"
  module load cmake/3.18.0
  module load cuda/11.4.2
elif [ $target == "topaz-cpu" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-cpu/apps"
  Caliper_ROOT=""
  module load cmake/3.18.0
elif [ $target == "mulan-gpu" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-mulan/apps"
  Caliper_ROOT=""
  cmake_cxx="hipcc"
  . /pawsey/mulan/bin/init-cmake-3.21.4.sh
  module unload gcc/9.3.0
  module load craype-accel-amd-gfx908
  module load rocm/4.5.0
elif [ $target == "mulan-cpu" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-mulan-cpu/apps"
  Caliper_ROOT=""
  . /pawsey/mulan/bin/init-cmake-3.21.4.sh
  module unload gcc/9.3.0
elif [ $target == "zeus" ] ; then
  Kokkos_ROOT="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-zeus/apps"
  Caliper_ROOT=""
  module load cmake/3.18.0
  module swap sandybridge broadwell
  module swap gcc gcc/8.3.0
else
  echo "Wrong target, exiting."
  exit 1
fi

if [ $verbose_make != "0" ] ; then
  verbose_make_string="VERBOSE=1"
else
  verbose_make_string=""
fi

rm -f ${binary_name}*.x
rm -rf build && mkdir build && cd build

cmake .. \
  -DCMAKE_CXX_COMPILER="${cmake_cxx}" \
  -DCMAKE_CXX_FLAGS="${cmake_cxx_flags}" \
  -DCMAKE_BUILD_TYPE="${cmake_build_type}" \
  -DCMAKE_PREFIX_PATH="${Kokkos_ROOT}" \
  -DCaliper_DIR="${Caliper_ROOT}" #\
#  -DKokkos_DIR="$Kokkos_ROOT/lib64/cmake/Kokkos"

make ${verbose_make_string}
cp -p ${binary_name}*.x ..
cd ..
rm -rf build
