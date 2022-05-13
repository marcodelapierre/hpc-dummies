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
            const float* const x, float* const y )
{
  for ( size_t i = 0; i < n; i++ ) {
    y[i] = a * x[i] + y[i];
  }
}
// just a duplicate to artificially have more functions in the profiling output
void saxpy2( const size_t n, const float a, 
            const float* const x, float* const y )
{
  for ( size_t i = 0; i < n; i++ ) {
    y[i] = a * x[i] + y[i];
  }
}
// just a duplicate to artificially have more functions in the profiling output
void saxpy3( const size_t n, const float a, 
            const float* const x, float* const y )
{
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
float err;
float clocktime = 0.;
float clocktime2 = 0.;
float clocktime3 = 0.;
my_timer timer;


int nrepeat = 10;
int nrepeat2 = 50;
int nrepeat3 = 100;

for ( int repeat = 0; repeat < nrepeat; repeat++) {
  // Fill values
  for ( size_t i = 0; i < N; i++ ) {
    x[i] = XVAL;
    y[i] = YVAL;
  }

  timer.reset();
  // SAXPY
  saxpy( N, AVAL, x, y );
  clocktime += (float)timer.elapsed();

  // SAXPY verification
  err = verify_saxpy( tot, N, y );
}

for ( int repeat = 0; repeat < nrepeat2; repeat++) {
  // Fill values
  for ( size_t i = 0; i < N; i++ ) {
    x[i] = XVAL;
    y[i] = YVAL;
  }

  timer.reset();
  // SAXPY
  saxpy2( N, AVAL, x, y );
  clocktime2 += (float)timer.elapsed();

  // SAXPY verification
  err = verify_saxpy( tot, N, y );
}

for ( int repeat = 0; repeat < nrepeat3; repeat++) {
  // Fill values
  for ( size_t i = 0; i < N; i++ ) {
    x[i] = XVAL;
    y[i] = YVAL;
  }

  timer.reset();
  // SAXPY
  saxpy3( N, AVAL, x, y );
  clocktime3 += (float)timer.elapsed();

  // SAXPY verification
  err = verify_saxpy( tot, N, y );
}


// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << "Clock2[ms]: " << clocktime2*1000. << "; ";
cout << "Clock3[ms]: " << clocktime3*1000. << "; ";
cout << endl;

// Deallocate arrays
delete [] y;
delete [] x;

return 0;
}