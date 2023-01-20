#include <iostream>
#include <cmath>
#include <ctime>
#include "my_timer.h"
#include <omp.h>

using namespace std;


// Verify SAXPY result
float verify_saxpy( const float tot, const size_t n, const float* const y )
{
  float err = 0.;
  #pragma omp target data map(err)
  {
  #pragma omp target teams distribute parallel for
  for (size_t i = 0; i < n; i++) {
    err += fabs( y[i] - tot );
  }
  }

  return err;
}

// Perform SAXPY
void saxpy( const size_t n, const float a, 
            const float* const x, float* const y )
{
  #pragma omp target teams distribute parallel for
  for ( size_t i = 0; i < n; i++ ) {
    y[i] = a * x[i] + y[i];
  }
}


int main( int argc, char** argv ) {

// Size of problem
const unsigned N = (1 << 26);
// Random values
const float XVAL = rand() % 1000000;
const float YVAL = rand() % 1000000;
const float AVAL = rand() % 1000000;
const float tot = AVAL * XVAL + YVAL;
// Allocate arrays
float* x = new float [ N ];
float* y = new float [ N ];
// More definitions
float clocktime, err;

#pragma omp target data map(alloc:x[0:N]) map(alloc:y[0:N])
{
// Fill values
#pragma omp target teams distribute parallel for
for ( size_t i = 0; i < N; i++ ) {
  x[i] = XVAL;
  y[i] = YVAL;
}

// Start timer
//clock_t start = clock();
my_timer timer;

// SAXPY
//#pragma omp target data map(x[0:N]) map(y[0:N])
//{
  saxpy( N, AVAL, x, y );
//  #pragma omp target teams distribute parallel for
//  for ( size_t i = 0; i < N; i++ ) {
//  y[i] = AVAL * x[i] + y[i];
//  }
//}

// Stop timer
//clock_t watch = clock() - start;
//const float clocktime = ((float)watch)/CLOCKS_PER_SEC;
clocktime = (float)timer.elapsed();

// SAXPY verification
err = verify_saxpy( tot, N, y );
}

// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << endl;

// Deallocate arrays
delete [] y;
delete [] x;

return 0;
}