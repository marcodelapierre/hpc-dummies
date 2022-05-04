cmake_minimum_required (VERSION 3.10)
project (Saxpy_Kokkos)

set(Kokkos_DIR "$ENV{Kokkos_ROOT}" CACHE STRING "Kokkos root directory")
find_package(Kokkos REQUIRED)

add_executable(saxpy_kokkos.x saxpy_kokkos.cpp)
target_link_libraries(saxpy_kokkos.x Kokkos::kokkos)
