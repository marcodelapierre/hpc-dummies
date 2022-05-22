cmake_minimum_required (VERSION 3.10)
project (Saxpy_Kokkos)

#set(Kokkos_DIR "$ENV{Kokkos_ROOT}" CACHE STRING "Kokkos root directory")
find_package(Kokkos REQUIRED)

if(Kokkos_ENABLE_CUDA)
  kokkos_check(OPTIONS CUDA_LAMBDA)
endif ()

add_executable(saxpy_kokkos_profile.x saxpy_kokkos_profile.cpp)
target_link_libraries(saxpy_kokkos_profile.x Kokkos::kokkos)

add_executable(saxpy_kokkos_kktools.x saxpy_kokkos_kktools.cpp)
target_link_libraries(saxpy_kokkos_kktools.x Kokkos::kokkos)

if( NOT ${Caliper_DIR} STREQUAL "" )
  add_executable(saxpy_kokkos_caliper.x saxpy_kokkos_caliper.cpp)
  target_link_directories(saxpy_kokkos_caliper.x PUBLIC ${Caliper_DIR}/lib64)
  target_include_directories(saxpy_kokkos_caliper.x PRIVATE ${Caliper_DIR}/include)
  target_link_libraries(saxpy_kokkos_caliper.x Kokkos::kokkos caliper)
endif()
