#include <iostream>
#include <cmath>
#include <ctime>
#include "my_timer.h"

using namespace std;


// Verify SAXPY result
float verify_saxpy( const float tot, const size_t n, const float* const y )
{
  float err = 0.;
  for (size_t i = 0; i < n; i++) {
    err += fabs( y[i] - tot );
  }

  return err;
}

// Perform SAXPY
void saxpy( const size_t n, const float a, 
            const float* __restrict__ const x, float* __restrict__ const y )
{
  # pragma vector aligned
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
//float* x = (float*)aligned_alloc(16*sizeof(float), N * sizeof(float));
//float* y = (float*)aligned_alloc(16*sizeof(float), N * sizeof(float));
float* x;
float* y;
posix_memalign((void**)&x, 16*sizeof(float), N * sizeof(float));
posix_memalign((void**)&y, 16*sizeof(float), N * sizeof(float));
// More definitions
float clocktime, err;

// Fill values
for ( size_t i = 0; i < N; i++ ) {
  x[i] = XVAL;
  y[i] = YVAL;
}

// Start timer
//clock_t start = clock();
my_timer timer;
// SAXPY
saxpy( N, AVAL, x, y );
// Stop timer
//clock_t watch = clock() - start;
//const float clocktime = ((float)watch)/CLOCKS_PER_SEC;
clocktime = (float)timer.elapsed();

// SAXPY verification
err = verify_saxpy( tot, N, y );

// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << endl;

// Deallocate arrays
//delete [] y;
//delete [] x;
free(y);
free(x);

return 0;
}
