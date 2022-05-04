#include <hip/hip_runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define HIP_ERROR_CHECK(X)({\
    if((X) != hipSuccess){\
      printf("HIP ERROR %s: %s\n", (X), hipGetErrorString((X)));\
      exit(1);\
    }\
})


// Verify SAXPY result
float verify_saxpy( const float tot, const size_t n, const float* const y )
{
  float err = 0;
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
struct hipDeviceProp_t devprop;
HIP_ERROR_CHECK(hipGetDevice( &device ));
HIP_ERROR_CHECK(hipGetDeviceProperties( &devprop, device ));
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
HIP_ERROR_CHECK(hipMalloc( (void**)&x, Nsize ));
HIP_ERROR_CHECK(hipMalloc( (void**)&y, Nsize ));
HIP_ERROR_CHECK(hipMallocHost( (void**)&y_host, Nsize ));
// More definitions
float clocktime, err;
clock_t start, watch;

const int gridDim = 4 * devprop.multiProcessorCount;
const int blockDim = 8 * devprop.warpSize;
// Fill values
hipLaunchKernelGGL(init_array, dim3(gridDim), dim3(blockDim ), 0, 0, N, XVAL, x);
HIP_ERROR_CHECK(hipGetLastError());
hipLaunchKernelGGL(init_array, dim3(gridDim), dim3(blockDim ), 0, 0, N, YVAL, y);
HIP_ERROR_CHECK(hipGetLastError());
HIP_ERROR_CHECK(hipDeviceSynchronize());

// Start timer
start = clock();

// SAXPY
hipLaunchKernelGGL(saxpy, dim3(gridDim), dim3(blockDim ), 0, 0, N, AVAL, x, y);
HIP_ERROR_CHECK(hipGetLastError());
HIP_ERROR_CHECK(hipDeviceSynchronize());

// Stop timer
watch = clock() - start;
clocktime = ((float)watch)/CLOCKS_PER_SEC;

// SAXPY verification
HIP_ERROR_CHECK(hipMemcpy(y_host, y, Nsize, hipMemcpyDeviceToHost));
err = verify_saxpy( tot, N, y_host );

// Print stuff
printf("N: %i; Err: %f; Clock[ms]: %f;\n", N, err, clocktime*1000.);

// Deallocate arrays
HIP_ERROR_CHECK(hipFreeHost( y_host ));
HIP_ERROR_CHECK(hipFree( y ));
HIP_ERROR_CHECK(hipFree( x ));

return 0;
}