#include <Kokkos_Core.hpp>
#include<KokkosBlas3_gemm.hpp>
#include <iostream>
#include <cmath>

using namespace std;


// Kokkos implementation using lambda functions

int main( int argc, char** argv ) {

Kokkos::initialize(argc, argv);
{

// Size of problem
const int N = 500;
//const int N2 = N * N;
// Random values
const float AVAL = 30.;
const float BVAL = 40.;
const float tot = AVAL * BVAL * N;
// Typdefs
typedef Kokkos::View<float*>   ViewVectorType;
typedef Kokkos::View<float**>  ViewMatrixType;
typedef Kokkos::MDRangePolicy< Kokkos::Rank<2> > mdrange_policy;
// Allocate arrays
ViewMatrixType A("A", N, N);
ViewMatrixType B("B", N, N);
ViewMatrixType C("C", N, N);
// More definitions
float clocktime, err;

// Fill values
Kokkos::parallel_for( "initA", mdrange_policy({0,0}, {N,N}), KOKKOS_LAMBDA ( const int i , const int j ) {
    A(i,j) = AVAL;
  }
);
Kokkos::parallel_for( "initB", mdrange_policy({0,0}, {N,N}), KOKKOS_LAMBDA ( const int i , const int j ) {
    B(i,j) = BVAL;
  }
);
Kokkos::parallel_for( "initC", mdrange_policy({0,0}, {N,N}), KOKKOS_LAMBDA ( const int i , const int j ) {
    C(i,j) = 0.;
  }
);

// Start timer
Kokkos::Timer timer;

// MATMUL
KokkosBlas::gemm("N","N",1.,A,B,1.,C);
Kokkos::fence();

// Stop timer
clocktime = (float)timer.seconds();

// MATMUL verification
err = 0.;
Kokkos::parallel_reduce( "verify_matmul", mdrange_policy({0,0}, {N,N}), 
  KOKKOS_LAMBDA ( const int i , const int j, float& tmperr ) {
    tmperr += fabs( C(i,j) - tot );
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