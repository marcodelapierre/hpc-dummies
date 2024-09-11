#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <omp.h>





// Verify SAXPY result
float verify_saxpy( const float tot, const size_t n, const float* const y )
{
  float err = 0.;
  #pragma omp parallel for
  for (size_t i = 0; i < n; i++) {
    err += fabs( y[i] - tot );
  }

  return err;
}

// Perform SAXPY
void saxpy( const size_t n, const float a, 
            const float* const x, float* const y )
{
  #pragma omp parallel for
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
const size_t Nsize = N * sizeof(float);
float* x = (float*)malloc(Nsize);
float* y = (float*)malloc(Nsize);
// More definitions
float err;
struct timespec start, finish;
double elapsed;

// Fill values
#pragma omp parallel for
for ( size_t i = 0; i < N; i++ ) {
  x[i] = XVAL;
  y[i] = YVAL;
}

// Start timer
clock_gettime(CLOCK_MONOTONIC, &start);
// SAXPY
saxpy( N, AVAL, x, y );
// Stop timer
clock_gettime(CLOCK_MONOTONIC, &finish);
elapsed = (finish.tv_sec - start.tv_sec) * 1000.0;
elapsed += (finish.tv_nsec - start.tv_nsec) / 1000000.0;

// SAXPY verification
err = verify_saxpy( tot, N, y );

// Print stuff
printf("N: %i; Err: %f; Clock[ms]: %f;\n", N, err, elapsed);

// Deallocate arrays
free(y);
free(x);

return 0;
}
