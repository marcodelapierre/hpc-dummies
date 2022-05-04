#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define CUDA_ERROR_CHECK(X)({\
    if((X) != cudaSuccess){\
      printf("CUDA ERROR %s: %s\n", (X), cudaGetErrorString((X)));\
      exit(1);\
    }\
})


// Verify SAXPY result
float verify_saxpy( const float tot, const size_t n, const float* const y )
{
  float err = 0.;
  for (size_t i = 0; i < n; i++) {
    err += fabs( y[i] - tot );
  }

  return err;
}

// Initisalise array
__global__ void init_array( const size_t n, const float val, 
                            float* const v )
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;

  for ( int tid = index ; tid < n ; tid += stride) {
    v[tid] = val;
  }
}

// Perform SAXPY
__global__ void saxpy( const size_t n, const float a, 
                       const float* const x, float* const y )
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;

  for ( int tid = index ; tid < n ; tid += stride) {
    y[tid] = a * x[tid] + y[tid];
  }
}


int main( int argc, char** argv ) {

int device;
struct cudaDeviceProp devprop;
CUDA_ERROR_CHECK(cudaGetDevice( &device ));
CUDA_ERROR_CHECK(cudaGetDeviceProperties( &devprop, device ));
printf("Device name: %s\n",devprop.name);

// Size of problem
const unsigned N = (1 << 26);
// Random values
const float XVAL = rand() % 1000000;
const float YVAL = rand() % 1000000;
const float AVAL = rand() % 1000000;
const float tot = AVAL * XVAL + YVAL;
// Allocate arrays
const size_t Nsize = N * sizeof(float);
float *x, *y, *y_host;
CUDA_ERROR_CHECK(cudaMalloc( (void**)&x, Nsize ));
CUDA_ERROR_CHECK(cudaMalloc( (void**)&y, Nsize ));
CUDA_ERROR_CHECK(cudaMallocHost( (void**)&y_host, Nsize ));
// More definitions
float clocktime, err;
clock_t start, watch;

const int gridDim = 4 * devprop.multiProcessorCount;
const int blockDim = 8 * devprop.warpSize;
// Fill values
init_array<<< gridDim, blockDim >>>(N, XVAL, x);
CUDA_ERROR_CHECK(cudaGetLastError());
init_array<<< gridDim, blockDim >>>(N, YVAL, y);
CUDA_ERROR_CHECK(cudaGetLastError());
CUDA_ERROR_CHECK(cudaDeviceSynchronize());

// Start timer
start = clock();

// SAXPY
saxpy<<< gridDim, blockDim >>>(N, AVAL, x, y);
CUDA_ERROR_CHECK(cudaGetLastError());
CUDA_ERROR_CHECK(cudaDeviceSynchronize());

// Stop timer
watch = clock() - start;
clocktime = ((float)watch)/CLOCKS_PER_SEC;

// SAXPY verification
CUDA_ERROR_CHECK(cudaMemcpy(y_host, y, Nsize, cudaMemcpyDeviceToHost));
err = verify_saxpy( tot, N, y_host );

// Print stuff
printf("N: %i; Err: %f; Clock[ms]: %f;\n", N, err, clocktime*1000.);

// Deallocate arrays
CUDA_ERROR_CHECK(cudaFreeHost( y_host ));
CUDA_ERROR_CHECK(cudaFree( y ));
CUDA_ERROR_CHECK(cudaFree( x ));

return 0;
}