#!/bin/bash

# Nvidia DLI VM

nvc++ -std=c++20 -stdpar=multicore \
  -O4 -fast -march=native -Mllvm-fast -DNDEBUG \
  -o hello_stdpar_multicore.x hello_stdpar.cpp

nvc++ -std=c++20 -stdpar=gpu \
  -O4 -fast -march=native -Mllvm-fast -DNDEBUG \
  -o hello_stdpar_gpu.x hello_stdpar.cpp
