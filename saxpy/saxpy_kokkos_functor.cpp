#include <Kokkos_Core.hpp>
#include <iostream>
#include <cmath>

using namespace std;


// Kokkos implementation using functors

// Verify SAXPY result
struct verify_saxpy {
  const float tot;
  Kokkos::View<const float*> const y;

  verify_saxpy( const float tot_, Kokkos::View<const float*> const y_ )
    : tot(tot_), y(y_) {}

  KOKKOS_INLINE_FUNCTION
  void operator()( const int64_t i, float& tmperr ) const { 
    tmperr += fabs( y(i) - tot );
  }
};

// Perform SAXPY
struct saxpy {
  const float a;
  Kokkos::View<const float*> const x;
  Kokkos::View<float*> const y;

  saxpy( const float a_, Kokkos::View<const float*> const x_, Kokkos::View<float*> const y_ )
    : a(a_), x(x_), y(y_) {}

  KOKKOS_INLINE_FUNCTION
  void operator()( const int64_t i ) const { 
    y(i) = a * x(i) + y(i); 
  }
};


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
Kokkos::View<float*> x("X", N);
Kokkos::View<float*> y("Y", N);
// More definitions
float clocktime, err;

// Fill values
Kokkos::parallel_for( "fill_values", N, 
  KOKKOS_LAMBDA ( const int64_t i ) {
  x(i) = XVAL;
  y(i) = YVAL;
});

// Start timer
Kokkos::Timer timer;

// SAXPY
Kokkos::parallel_for( "saxpy", N, saxpy( AVAL, x, y ) );
Kokkos::fence();

// Stop timer
clocktime = (float)timer.seconds();

// SAXPY verification
err = 0.;
Kokkos::parallel_reduce( "verify_saxpy", N, verify_saxpy( tot, y ), err);

// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << endl;

}
Kokkos::finalize();
return 0;
}