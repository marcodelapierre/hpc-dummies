#include <stdio.h>
 
 
__global__ void helloGPU() {
 
  int tid = threadIdx.x;
  int bid = blockIdx.x;
  printf("Hello from GPU thread %d in block %d\n",tid,bid);
 
}
 
 
int main(int argc, char *argv[]) {
 
  int no_blocks = 4;
  int no_threads = 5;
 
  helloGPU<<<no_blocks,no_threads>>>();
 
  cudaDeviceSynchronize();
 
}
