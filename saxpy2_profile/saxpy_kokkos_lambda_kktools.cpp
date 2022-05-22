#include <Kokkos_Core.hpp>
#include <iostream>
#include <cmath>

using namespace std;


// Kokkos implementation using lambda functions

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
float err;
float clocktime = 0.;
float clocktime2 = 0.;
float clocktime3 = 0.;
Kokkos::Timer timer;


int nrepeat = 10;
int nrepeat2 = 50;
int nrepeat3 = 100;

for ( int repeat = 0; repeat < nrepeat; repeat++) {
  // Fill values
  Kokkos::parallel_for( "fill_values", N, 
    KOKKOS_LAMBDA ( const int64_t i ) {
    x(i) = XVAL;
    y(i) = YVAL;
  });
  
  Kokkos::Profiling::pushRegion("Iterate");
  // Start timer
  timer.reset();
  // SAXPY
  Kokkos::parallel_for( "saxpy", N, 
    KOKKOS_LAMBDA ( const int64_t i ) {
      y(i) = AVAL * x(i) + y(i);
  });
  Kokkos::fence();
  // Stop timer
  clocktime += (float)timer.seconds();
  Kokkos::Profiling::popRegion();
  
  // SAXPY verification
  err = 0.;
  Kokkos::parallel_reduce( "verify_saxpy", N, 
    KOKKOS_LAMBDA ( const int64_t i, float& tmperr ) {
      tmperr += fabs( y(i) - tot );
  }, 
  err);
}

for ( int repeat = 0; repeat < nrepeat2; repeat++) {
  // Fill values
  Kokkos::parallel_for( "fill_values", N, 
    KOKKOS_LAMBDA ( const int64_t i ) {
    x(i) = XVAL;
    y(i) = YVAL;
  });
  
  Kokkos::Profiling::pushRegion("Iterate2");
  // Start timer
  timer.reset();
  // SAXPY
  Kokkos::parallel_for( "saxpy2", N, 
    KOKKOS_LAMBDA ( const int64_t i ) {
      y(i) = AVAL * x(i) + y(i);
  });
  Kokkos::fence();
  // Stop timer
  clocktime2 += (float)timer.seconds();
  Kokkos::Profiling::popRegion();
  
  // SAXPY verification
  err = 0.;
  Kokkos::parallel_reduce( "verify_saxpy", N, 
    KOKKOS_LAMBDA ( const int64_t i, float& tmperr ) {
      tmperr += fabs( y(i) - tot );
  }, 
  err);
}

for ( int repeat = 0; repeat < nrepeat3; repeat++) {
  // Fill values
  Kokkos::parallel_for( "fill_values", N, 
    KOKKOS_LAMBDA ( const int64_t i ) {
    x(i) = XVAL;
    y(i) = YVAL;
  });
  
  Kokkos::Profiling::pushRegion("Iterate3");
  // Start timer
  timer.reset();
  // SAXPY
  Kokkos::parallel_for( "saxpy3", N, 
    KOKKOS_LAMBDA ( const int64_t i ) {
      y(i) = AVAL * x(i) + y(i);
  });
  Kokkos::fence();
  // Stop timer
  clocktime3 += (float)timer.seconds();
  Kokkos::Profiling::popRegion();
  
  // SAXPY verification
  err = 0.;
  Kokkos::parallel_reduce( "verify_saxpy", N, 
    KOKKOS_LAMBDA ( const int64_t i, float& tmperr ) {
      tmperr += fabs( y(i) - tot );
  }, 
  err);
}


// Print stuff
cout << "N: " << N << "; ";
cout << "Err: " << err << "; ";
cout << "Clock[ms]: " << clocktime*1000. << "; ";
cout << "Clock2[ms]: " << clocktime2*1000. << "; ";
cout << "Clock3[ms]: " << clocktime3*1000. << "; ";
cout << endl;

}
Kokkos::finalize();
return 0;
}