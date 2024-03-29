#include <iostream>
#include <cmath>
#include <ctime>
#include "my_timer.h"
#include <mpi.h>

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
void saxpy_mpi( const size_t n0, const size_t n_per_call, 
            const size_t ntot, const float a, 
            const float* const x, float* const y )
{
  for ( size_t i = n0 * n_per_call; i < n0 * n_per_call + n_per_call; i++ ) {
    if ( i >= ntot ) break;
    const unsigned i_rank = i % n_per_call;
    y[i_rank] = a * x[i_rank] + y[i_rank];
  }
}


int main( int argc, char** argv ) {

// MPI initialisation
MPI_Init( &argc, &argv );
int rank, size, manager = 0;
MPI_Comm_size( MPI_COMM_WORLD, &size );
MPI_Comm_rank( MPI_COMM_WORLD, &rank );

// More definitions
float clocktime, err;
// Size of problem
const unsigned N = (1 << 26);
const unsigned n_per_rank = (N - 1)/size + 1;
// Parameters
float vals[4];
if ( rank == manager ) {
  vals[0] = rand() % 1000000;
  vals[1] = rand() % 1000000;
  vals[2] = rand() % 1000000;
  vals[3]  = vals[0] * vals[1] + vals[2];
}
// Send parameters from manager rank to all others
MPI_Bcast( vals, 4, MPI_FLOAT, manager, MPI_COMM_WORLD );

// Allocate arrays
float* x = new float [ n_per_rank ];
float* y = new float [ n_per_rank ];
float* ytot;
if ( rank == manager ) {
  ytot = new float [ N ];
}

// Fill values
for ( size_t i = rank * n_per_rank; i < rank * n_per_rank + n_per_rank; i++ ) {
  if ( i >= N ) break;
  const unsigned i_rank = i % n_per_rank;
  x[i_rank] = vals[1];
  y[i_rank] = vals[2];
}

// Start timer
//clock_t start = clock();
MPI_Barrier(MPI_COMM_WORLD);
my_timer timer;
// SAXPY
saxpy_mpi( rank, n_per_rank, N, vals[0], x, y );
// Stop timer
//clock_t watch = clock() - start;
//const float clocktime = ((float)watch)/CLOCKS_PER_SEC;
MPI_Barrier(MPI_COMM_WORLD);
clocktime = (float)timer.elapsed();

// Get all elements back to manager rank
MPI_Gather( y, n_per_rank, MPI_FLOAT, ytot, n_per_rank, MPI_FLOAT, manager, MPI_COMM_WORLD );

if ( rank == manager ) {
// SAXPY verification
  err = verify_saxpy( vals[3], N, ytot );

// Print stuff
  cout << "N: " << N << "; ";
  cout << "Err: " << err << "; ";
  cout << "Clock[ms]: " << clocktime*1000. << "; ";
  cout << endl;
}

// Deallocate arrays
if ( rank == manager ) {
  delete [] ytot;
}
delete [] y;
delete [] x;

MPI_Finalize();
return 0;
}
