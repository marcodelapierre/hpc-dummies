my_include=$(pwd)
my_include=${my_include%/*}/include
export CPATH="$my_include:$CPATH"

g++-11 -fopt-info-vec-loop -o saxpy.x saxpy_serial.cpp 
g++-11 -O2 -fopt-info-vec-loop -o saxpy_o2.x saxpy_serial.cpp 
g++-11 -O2 -funroll-loops -fopt-info-vec-loop -o saxpy_o2_unroll.x saxpy_serial.cpp 
g++-11 -O2 -ftree-vectorize -fopt-info-vec-loop -o saxpy_o2_vec.x saxpy_serial.cpp 
g++-11 -O2 -funroll-loops -ftree-vectorize -fopt-info-vec-loop -o saxpy_o2_unroll_vec.x saxpy_serial.cpp 
g++-11 -O3 -fopt-info-vec-loop -o saxpy_o3.x saxpy_serial.cpp 
g++-11 -O3 -funroll-loops -ftree-vectorize  -fopt-info-vec-loop -o saxpy_o3_unroll_vec.x saxpy_serial.cpp 
g++-11 -Ofast -funroll-loops -ftree-vectorize  -fopt-info-vec-loop -o saxpy_ofast_unroll_vec.x saxpy_serial.cpp 

g++-11 -fopenmp -O2 -fopt-info-vec-loop -o saxpy_simd_o2.x saxpy_simd.cpp 

g++-11 -fopenmp -O2 -fopt-info-vec-loop -o saxpy_omp_o2.x saxpy_omp.cpp
g++-11 -fopenmp -O2 -funroll-loops -ftree-vectorize -fopt-info-vec-loop -o saxpy_omp_o2_unroll_vec.x saxpy_omp.cpp 
g++-11 -fopenmp -O3 -fopt-info-vec-loop -o saxpy_omp_o3.x saxpy_omp.cpp

md@rivendell-kf:saxpy$ for i in 1 2 3 ; do ./saxpy_o2.x  ; done
N: 67108864; Err: 0; Clock[ms]: 58.535; 
N: 67108864; Err: 0; Clock[ms]: 40.244; 
N: 67108864; Err: 0; Clock[ms]: 39.871; 
md@rivendell-kf:saxpy$ for i in 1 2 3 ; do ./saxpy_o2_unroll.x  ; done
N: 67108864; Err: 0; Clock[ms]: 27.806; 
N: 67108864; Err: 0; Clock[ms]: 27.318; 
N: 67108864; Err: 0; Clock[ms]: 27.616; 
md@rivendell-kf:saxpy$ for i in 1 2 3 ; do ./saxpy_o2_vec.x  ; done
N: 67108864; Err: 0; Clock[ms]: 20.177; 
N: 67108864; Err: 0; Clock[ms]: 20.234; 
N: 67108864; Err: 0; Clock[ms]: 20.298; 
md@rivendell-kf:saxpy$ for i in 1 2 3 ; do ./saxpy_o2_unroll_vec.x  ; done
N: 67108864; Err: 0; Clock[ms]: 19.743; 
N: 67108864; Err: 0; Clock[ms]: 19.65; 
N: 67108864; Err: 0; Clock[ms]: 19.626; 
md@rivendell-kf:saxpy$ for i in 1 2 3 ; do ./saxpy_o3.x  ; done
N: 67108864; Err: 0; Clock[ms]: 20.366; 
N: 67108864; Err: 0; Clock[ms]: 20.216; 
N: 67108864; Err: 0; Clock[ms]: 20.425; 
md@rivendell-kf:saxpy$ for i in 1 2 3 ; do ./saxpy_simd_o2.x  ; done
N: 67108864; Err: 0; Clock[ms]: 22.401; 
N: 67108864; Err: 0; Clock[ms]: 20.729; 
N: 67108864; Err: 0; Clock[ms]: 20.776; 

md@rivendell-kf:saxpy$ for t in 1 2 4 ; do for i in 1 2 3 ; do OMP_NUM_THREADS=$t ./saxpy_omp_o2.x ; done ; done
N: 67108864; Err: 0; Clock[ms]: 57.941; 
N: 67108864; Err: 0; Clock[ms]: 39.028; 
N: 67108864; Err: 0; Clock[ms]: 38.769; 
N: 67108864; Err: 0; Clock[ms]: 21.765; 
N: 67108864; Err: 0; Clock[ms]: 21.543; 
N: 67108864; Err: 0; Clock[ms]: 21.61; 
N: 67108864; Err: 0; Clock[ms]: 16.922; 
N: 67108864; Err: 0; Clock[ms]: 16.467; 
N: 67108864; Err: 0; Clock[ms]: 17.106; 
md@rivendell-kf:saxpy$ for t in 1 2 4 ; do for i in 1 2 3 ; do OMP_NUM_THREADS=$t ./saxpy_omp_o2_unroll_vec.x ; done ; done
N: 67108864; Err: 0; Clock[ms]: 20.65; 
N: 67108864; Err: 0; Clock[ms]: 20.335; 
N: 67108864; Err: 0; Clock[ms]: 20.219; 
N: 67108864; Err: 0; Clock[ms]: 16.37; 
N: 67108864; Err: 0; Clock[ms]: 18.291; 
N: 67108864; Err: 0; Clock[ms]: 16.241; 
N: 67108864; Err: 0; Clock[ms]: 16.386; 
N: 67108864; Err: 0; Clock[ms]: 16.616; 
N: 67108864; Err: 0; Clock[ms]: 15.817; 

