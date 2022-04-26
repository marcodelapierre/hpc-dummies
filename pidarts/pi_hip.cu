/* Compute pi in serial */
#include <stdio.h>
#include <hip/hip_runtime.h>
#include <hiprand.h>
static long num_trials = 1000000;
 
__global__ void kernel(int* Ncirc_t_device,float *randnum)
{
  int i;
  double r = 1.0; // radius of circle
  double r2 = r*r;
  double x,y;
 
  i = blockDim.x * blockIdx.x + threadIdx.x;
  x=randnum[2*i];
  y=randnum[2*i+1];
   
  if ((x*x + y*y) <= r2)
      Ncirc_t_device[i]=1;
  else
      Ncirc_t_device[i]=0;
}
 
int main(int argc, char **argv) {
  int i;
  long Ncirc=0;
  int *Ncirc_t_device;
  int *Ncirc_t_host;
  float *randnum;
  int threads, blocks;
  double pi;
 
  // Allocate an array for the random numbers in GPU memory space
  hipMalloc((void**)&randnum,(2*num_trials)*sizeof(float));
 
  // Generate random numbers
  int status;
  hiprandGenerator_t randgen;
  status = hiprandCreateGenerator(&randgen, HIPRAND_RNG_PSEUDO_MRG32K3A);
  status |= hiprandSetPseudoRandomGeneratorSeed(randgen, 4294967296ULL^time(NULL));
  status |= hiprandGenerateUniform(randgen, randnum, (2*num_trials));
  status |= hiprandDestroyGenerator(randgen); 
 
  threads=1000;
  blocks=num_trials/threads;
 
  // Allocate hit array on host
  Ncirc_t_host=(int*)malloc(num_trials*sizeof(int));
  // Allocate hit array on device
  hipMalloc((void**)&Ncirc_t_device,num_trials*sizeof(int));
 
  hipLaunchKernelGGL(kernel, blocks, threads, 0, 0, Ncirc_t_device,randnum);
 
  // Synchronize host and device
  hipDeviceSynchronize();
 
  // Copy the hit array to host
  hipMemcpy(Ncirc_t_host,Ncirc_t_device,num_trials*sizeof(int),hipMemcpyDeviceToHost);
 
  // Count hits
  for(i=0; i<num_trials; i++)
    Ncirc+=Ncirc_t_host[i];
 
  pi = 4.0 * ((double)Ncirc)/((double)num_trials);
   
  printf("\n \t Computing pi using CUDA: \n");
  printf("\t For %ld trials, pi = %f\n", num_trials, pi);
  printf("\n");
 
  hipFree(randnum);
  hipFree(Ncirc_t_device);
  free(Ncirc_t_host);
 
  return 0;
}
