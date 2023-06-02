#include "hip/hip_runtime.h"
#include <stdio.h>
 
 
__global__ void helloGPU() {
 
  int tid = threadIdx.x;
  int bid = blockIdx.x;
  printf("Hello from GPU thread %d in block %d\n",tid,bid);
 
}
 
 
int main(int argc, char *argv[]) {
 
  int no_blocks = 4;
  int no_threads = 5;
 
  hipLaunchKernelGGL(helloGPU, dim3(no_blocks), dim3(no_threads), 0, 0);
 
  hipDeviceSynchronize();
 
}
