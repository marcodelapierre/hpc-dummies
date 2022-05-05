#include <Kokkos_Core.hpp>
#include <iostream>
#include <cmath>

using namespace std;


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
Kokkos::View<float*>::HostMirror y_host = Kokkos::create_mirror_view( y );
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
Kokkos::parallel_for( "saxpy", N, 
  KOKKOS_LAMBDA ( const int64_t i ) {
    y(i) = AVAL * x(i) + y(i);
});
Kokkos::fence();

// Stop timer
clocktime = (float)timer.seconds();

// SAXPY verification
Kokkos::deep_copy( y_host, y );
err = 0.;
Kokkos::parallel_reduce( "verify_saxpy", 
  Kokkos::RangePolicy< Kokkos::DefaultHostExecutionSpace >( 0, N ), 
  KOKKOS_LAMBDA (const int64_t i, float& tmperr) {
    tmperr += fabs( y_host(i) - tot );
}, 
err);

// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << endl;

}
Kokkos::finalize();
return 0;
}