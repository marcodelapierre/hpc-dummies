cmake_minimum_required (VERSION 3.10)
project (Matmul_Kokkos)

#set(Kokkos_DIR "$ENV{Kokkos_ROOT}" CACHE STRING "Kokkos root directory")
find_package(Kokkos REQUIRED)

if(Kokkos_ENABLE_CUDA)
  kokkos_check(OPTIONS CUDA_LAMBDA)
endif ()

add_executable(matmul_kokkos.x matmul_kokkos.cpp)
target_link_libraries(matmul_kokkos.x Kokkos::kokkos)
