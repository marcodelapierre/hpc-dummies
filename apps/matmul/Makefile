# Makefile for matmul_blas.cpp - BLAS implementation

.PHONY: all build run clean
all: build

CCFLAGS = -I../include
arch = UNKNOWN
include Make.$(arch)

build: matmul_blas$(SUF).x

matmul_blas$(SUF).x: matmul_blas.cpp
	$(CC) $(CCFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

run:
	time OMP_NUM_THREADS=1 ./matmul_blas$(SUF).x

clean:
	rm -f matmul_blas$(SUF).x
