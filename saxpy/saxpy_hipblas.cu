#include <hip/hip_runtime.h>
#include <iostream>
#include <hipblas.h>
#include "my_timer.h"

#define CE(op) if ((status = op) != HIPBLAS_STATUS_SUCCESS) { std::cerr << "Error: " #op << " [status=" << status << "]\n"; return 1; }


// Verify SAXPY result
float verify_saxpy( const float tot, const size_t n, const float* const y )
{
  float err = 0.;
  for (size_t i = 0; i < n; i++) {
    err += fabs( y[i] - tot );
  }

  return err;
}


int main()
{
   const unsigned N = (1 << 26);
   const float XVAL = rand() % 1000000;
   const float YVAL = rand() % 1000000;
   const float AVAL = rand() % 1000000;
   const float tot = AVAL * XVAL + YVAL;

   hipblasStatus_t status;
   hipblasHandle_t h = nullptr;
   float *host_x, *host_y;

   host_x = new float[N];
   host_y = new float[N];

   //cublasInit();
   CE( hipblasCreate(&h) );

   for (int i=0; i<N; ++i) {
      host_x[i] = XVAL;
      host_y[i] = YVAL;
   }
   float *dev_x, *dev_y;
   hipMalloc( (void**)&dev_x, N*sizeof(float));
   hipMalloc( (void**)&dev_y, N*sizeof(float));

   CE( hipblasSetVector(N, sizeof(host_x[0]), host_x, 1, dev_x, 1) );
   CE( hipblasSetVector(N, sizeof(host_y[0]), host_y, 1, dev_y, 1) );

   hipDeviceSynchronize();

   my_timer timer;
   hipblasSaxpy(h, N, &AVAL, dev_x, 1, dev_y, 1);
   hipDeviceSynchronize();
   float clocktime = (float)timer.elapsed();

   hipblasGetVector(N, sizeof(host_y[0]), dev_y, 1, host_y, 1);
   float err = verify_saxpy( tot, N, host_y );

   std::cout << "N: " << N << "; ";
   std::cout << "Err: " << err << "; ";
   std::cout << "Clock[ms]: " << clocktime*1000. << "; ";
   std::cout << std::endl;

   if (h)
      hipblasDestroy(h);
   hipFree(dev_y);
   hipFree(dev_x);
   delete [] host_y;
   delete [] host_x;

   return 0;
}
