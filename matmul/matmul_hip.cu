#include "hip/hip_runtime.h"
#include <hip/hip_runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define CUDA_ERROR_CHECK(X)({\
    if((X) != hipSuccess){\
      printf("CUDA ERROR %s: %s\n", (X), hipGetErrorString((X)));\
      exit(1);\
    }\
})


// Verify MATMUL result
float verify_matmul( const float tot, const size_t n2, const float* const C )
{
  float err = 0.;
  for (size_t i = 0; i < n2; i++) {
    err += fabs( C[i] - tot );
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

// Perform MATMUL
__global__ void matmul( const size_t n, const float* const A, 
            const float* const B, float* const C )
{
  int index_x = blockIdx.x * blockDim.x + threadIdx.x;
  int stride_x = blockDim.x * gridDim.x;
  int index_y = blockIdx.y * blockDim.y + threadIdx.y;
  int stride_y = blockDim.y * gridDim.y;

  for ( int tx = index_x ; tx < n ; tx += stride_x) {
    for ( int ty = index_y ; ty < n ; ty += stride_y) {
      double sum = 0.;
      for ( size_t k = 0; k < n; k++ ) {
        double a = A[tx * n + k];
        double b = B[k * n + ty];
        sum += a * b;
      }
      C[tx * n + ty] = (float)sum;
    }
  }
}


int main( int argc, char** argv ) {

int device;
struct hipDeviceProp_t devprop;
CUDA_ERROR_CHECK(hipGetDevice( &device ));
CUDA_ERROR_CHECK(hipGetDeviceProperties( &devprop, device ));
printf("Device name: %s\n",devprop.name);

// Size of problem
const int N = 500;
const int N2 = N * N;
// Random values
const float AVAL = 30.;
const float BVAL = 40.;
const float tot = AVAL * BVAL * N;
// Allocate arrays
const size_t Nsize = N * sizeof(float);
const size_t Nsize2 = Nsize * Nsize;
float *A, *B, *C, *C_host;
CUDA_ERROR_CHECK(hipMalloc( (void**)&A, Nsize2 ));
CUDA_ERROR_CHECK(hipMalloc( (void**)&B, Nsize2 ));
CUDA_ERROR_CHECK(hipMalloc( (void**)&C, Nsize2 ));
CUDA_ERROR_CHECK(hipHostMalloc( (void**)&C_host, Nsize2 ));
// More definitions
float clocktime, err;
clock_t start, watch;

const int gridDim = 4 * devprop.multiProcessorCount;
const int blockDim = 8 * devprop.warpSize;
// Fill values
hipLaunchKernelGGL(init_array, dim3(gridDim), dim3(blockDim ), 0, 0, N2, AVAL, A);
CUDA_ERROR_CHECK(hipGetLastError());
hipLaunchKernelGGL(init_array, dim3(gridDim), dim3(blockDim ), 0, 0, N2, BVAL, B);
CUDA_ERROR_CHECK(hipGetLastError());
hipLaunchKernelGGL(init_array, dim3(gridDim), dim3(blockDim ), 0, 0, N2, 0., C);
CUDA_ERROR_CHECK(hipGetLastError());
CUDA_ERROR_CHECK(hipDeviceSynchronize());

// Start timer
start = clock();

// MATMUL
const dim3 gridDim2D(32, 32); // just putting a value
const dim3 blockDim2D(16, 16);
hipLaunchKernelGGL(matmul, dim3(gridDim2D), dim3(blockDim2D ), 0, 0, N, A, B, C);
CUDA_ERROR_CHECK(hipGetLastError());
CUDA_ERROR_CHECK(hipDeviceSynchronize());

// Stop timer
watch = clock() - start;
clocktime = ((float)watch)/CLOCKS_PER_SEC;

// MATMUL verification
CUDA_ERROR_CHECK(hipMemcpy(C_host, C, Nsize2, hipMemcpyDeviceToHost));
err = verify_matmul( tot, N2, C_host );

// Print stuff
printf("N: %i; Err: %f; Clock[ms]: %f;\n", N, err, clocktime*1000.);

// Deallocate arrays
CUDA_ERROR_CHECK(hipHostFree( C_host ));
CUDA_ERROR_CHECK(hipFree( C ));
CUDA_ERROR_CHECK(hipFree( B ));
CUDA_ERROR_CHECK(hipFree( A ));

return 0;
}