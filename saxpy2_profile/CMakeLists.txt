cmake_minimum_required (VERSION 3.10)
project (Saxpy_Kokkos)

#set(Kokkos_DIR "$ENV{Kokkos_ROOT}" CACHE STRING "Kokkos root directory")
find_package(Kokkos REQUIRED)

if(Kokkos_ENABLE_CUDA)
  kokkos_check(OPTIONS CUDA_LAMBDA)
endif ()

add_executable(saxpy_kokkos_lambda_profile.x saxpy_kokkos_lambda_profile.cpp)
target_link_libraries(saxpy_kokkos_lambda_profile.x Kokkos::kokkos)
