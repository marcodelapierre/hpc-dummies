#!/bin/bash

# Nvidia DLI VM

nvc++ -std=c++20 -stdpar=multicore \
  -O4 -fast -march=native -Mllvm-fast -DNDEBUG \
  -o saxpy_stdpar_multicore.x saxpy_stdpar.cpp

nvc++ -std=c++20 -stdpar=gpu \
  -O4 -fast -march=native -Mllvm-fast -DNDEBUG \
  -o saxpy_stdpar_gpu.x saxpy_stdpar.cpp
