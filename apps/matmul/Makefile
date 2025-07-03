# Makefile for matmul_blas.cpp - BLAS implementation

.PHONY: all buildrun build run clean
all: build

CCFLAGS = -I../include
arch = UNKNOWN
include Make.$(arch)

buildrun: build run

build: matmul_blas$(SUF).x

matmul_blas$(SUF).x: matmul_blas.cpp
	$(CC) $(CCFLAGS) $(LDFLAGS) -o $@ $< $(LDLIBS)

run:
	export OMP_NUM_THREADS="1"
	time ./matmul_blas$(SUF).x

clean:
	rm -f matmul_blas$(SUF).x
