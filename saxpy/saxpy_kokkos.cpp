#include <Kokkos_Core.hpp>
#include <iostream>
#include <cmath>

using namespace std;


// Verify SAXPY result
float verify_saxpy( const float tot, const size_t n, const float* const y )
{
  float err = 0;
  for (size_t i = 0; i < n; i++) {
    err += fabs( y[i] - tot );
  }

  return err;
}


int main( int argc, char** argv ) {

Kokkos::initialize(argc, argv);
{

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

// Fill values
for ( size_t i = 0; i < N; i++ ) {
  x[i] = XVAL;
  y[i] = YVAL;
}

// Start timer
Kokkos::Timer timer;

// SAXPY
Kokkos::parallel_for( "saxpy", N, KOKKOS_LAMBDA (const int64_t i) {
  y[i] = AVAL * x[i] + y[i];
});
Kokkos::fence();

// Stop timer
clocktime = (float)timer.seconds();

// SAXPY verification
err = verify_saxpy( tot, N, y );

// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << endl;

// Deallocate arrays
delete [] y;
delete [] x;

}
Kokkos::finalize();
return 0;
}