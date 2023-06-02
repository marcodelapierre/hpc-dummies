/* Compute pi using the six basic MPI functions */
#include <mpi.h>
#include <stdio.h>
  
// Random number generator -- and not a very good one, either!
static long MULTIPLIER = 1366;
static long ADDEND = 150889;
static long PMOD = 714025;
long random_last = 0;
  
// This is not a thread-safe random number generator
double lcgrandom() {
  long random_next;
  random_next = (MULTIPLIER * random_last + ADDEND)%PMOD;
  random_last = random_next;
  
  return ((double)random_next/(double)PMOD);
}
 
static long num_trials = 1000000;
 
int main(int argc, char **argv) {
  long i;
  long Ncirc = 0;
  double pi, x, y;
  double r = 1.0; // radius of circle
  double r2 = r*r;
 
  int rank, size, manager = 0;
  MPI_Status status;
  long my_trials, temp;
  int j;
 
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  my_trials = num_trials/size;
  if (num_trials%(long)size > (long)rank) my_trials++;
  random_last = rank;
 
  for (i = 0; i < my_trials; i++) {
    x = lcgrandom();
    y = lcgrandom();
    if ((x*x + y*y) <= r2)
      Ncirc++;
  }
 
  if (rank == manager) {
    for (j = 1; j < size; j++) {
      MPI_Recv(&temp, 1, MPI_LONG, j, j, MPI_COMM_WORLD, &status);
      Ncirc += temp;
    }
    pi = 4.0 * ((double)Ncirc)/((double)num_trials);
    printf("\n \t Computing pi using six basic MPI functions: \n");
    printf("\t For %ld trials, pi = %f\n", num_trials, pi);
    printf("\n");
  } else {
    MPI_Send(&Ncirc, 1, MPI_LONG, manager, rank, MPI_COMM_WORLD);
  }
  MPI_Finalize();
  return 0;
}
