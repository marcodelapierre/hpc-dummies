#!/bin/bash

# serial with vectorisation off
CPATH=$(pwd)/../include:$CPATH icpx -O3 -fno-vectorize -fno-slp-vectorize  -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial_novec.x saxpy_serial.cpp
mv saxpy_serial.optrpt saxpy_serial_novec.optrpt

# serial with no arch (avx default)
CPATH=$(pwd)/../include:$CPATH icpx -O3   -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial.x saxpy_serial.cpp 
mv saxpy_serial.optrpt saxpy_serial_std.optrpt

# serial with avx2 arch
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=core-avx2  -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial_avx2.x saxpy_serial.cpp 
mv saxpy_serial.optrpt saxpy_serial_avx2.optrpt

# serial with avx512 arch
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=common-avx512  -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial_avx512.x saxpy_serial.cpp
mv saxpy_serial.optrpt saxpy_serial_avx512.optrpt


# serial with aligned allocation and avx2 arch
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=core-avx2  -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial_aligned_avx2.x saxpy_serial_aligned.cpp
mv saxpy_serial_aligned.optrpt saxpy_serial_aligned_avx2.optrpt


# avx2 intrinsics with aligned allocation
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=core-avx2  -qopt-report=3 -qopt-report-phase=vec -o saxpy_avx2.x saxpy_avx2.cpp 


# avx512 intrinsics with aligned allocation
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=common-avx512  -qopt-report=3 -qopt-report-phase=vec -o saxpy_avx512.x saxpy_avx512.cpp 

