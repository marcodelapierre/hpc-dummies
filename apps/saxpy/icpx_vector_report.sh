#!/bin/bash

# serial with vectorisation off
CPATH=$(pwd)/../include:$CPATH icpx -O3 -fno-vectorize -fno-slp-vectorize  -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial.x saxpy_serial.cpp
mv saxpy_serial.optrpt saxpy_serial.optrpt_novec

# serial with no arch (avx default)
CPATH=$(pwd)/../include:$CPATH icpx -O3   -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial.x saxpy_serial.cpp 
mv saxpy_serial.optrpt saxpy_serial.optrpt_std

# serial with avx2 arch
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=core-avx2  -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial.x saxpy_serial.cpp 
mv saxpy_serial.optrpt saxpy_serial.optrpt_avx2

# serial with avx512 arch
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=common-avx512  -qopt-report=3 -qopt-report-phase=vec -o saxpy_serial.x saxpy_serial.cpp
mv saxpy_serial.optrpt saxpy_serial.optrpt_avx512


# avx2 intrinsics
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=core-avx2  -qopt-report=3 -qopt-report-phase=vec -o saxpy_avx2.x saxpy_avx2.cpp 


# avx512 intrinsics
CPATH=$(pwd)/../include:$CPATH icpx -O3 -march=common-avx512  -qopt-report=3 -qopt-report-phase=vec -o saxpy_avx512.x saxpy_avx512.cpp 

