#include <iostream>
#include <cmath>
#include <ctime>
#include "my_timer.h"
#ifdef MKL
 #include "mkl.h"
#else
 #include "cblas.h"
#endif

using namespace std;


// Verify MATMUL result
float verify_matmul( const float tot, const size_t n2, const float* const C )
{
  float err = 0.;
  for (size_t i = 0; i < n2; i++) {
    err += fabs( C[i] - tot );
  }

  return err;
}


int main( int argc, char** argv ) {

// Size of problem
const int N = 500;
const int N2 = N * N;
// Random values
const float AVAL = 30.;
const float BVAL = 40.;
const float tot = AVAL * BVAL * N;
// Allocate arrays
float* A = new float [ N2 ];
float* B = new float [ N2 ];
float* C = new float [ N2 ];
// More definitions
float clocktime, err;

// Fill values
for ( size_t i = 0; i < N2; i++ ) {
  A[i] = AVAL;
  B[i] = BVAL;
  C[i] = 0.;
}

// Start timer
//clock_t start = clock();
my_timer timer;
// MATMUL
cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
            N,N,N, 1., A,N, B,N, 0., C,N);
// Stop timer
//clock_t watch = clock() - start;
//const float clocktime = ((float)watch)/CLOCKS_PER_SEC;
clocktime = (float)timer.elapsed();

// MATMUL verification
err = verify_matmul( tot, N2, C );

// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << endl;

// Deallocate arrays
delete [] C;
delete [] B;
delete [] A;

return 0;
}
