cmake_minimum_required (VERSION 3.10)
project (Pi_Kokkos)

#set(Kokkos_DIR "$ENV{Kokkos_ROOT}" CACHE STRING "Kokkos root directory")
find_package(Kokkos REQUIRED)

if(Kokkos_ENABLE_CUDA)
  kokkos_check(OPTIONS CUDA_LAMBDA)
endif ()

add_executable(pi_kokkos.x pi_kokkos.cpp)
target_link_libraries(pi_kokkos.x Kokkos::kokkos)

#add_executable(pi_kokkos_functor.x pi_kokkos_functor.cpp)
#target_link_libraries(pi_kokkos_functor.x Kokkos::kokkos)
