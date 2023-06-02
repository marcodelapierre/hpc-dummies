/* Compute pi using OpenMP */
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include "my_timer.h"
 
static long num_trials = 1000000;
 
int main(int argc, char **argv) {
  long i;
  long Ncirc = 0;
  double pi, x, y;
  double r = 1.0; // radius of circle
  double r2 = r*r;

  // Start timer
  my_timer timer;
#pragma omp parallel
{
  unsigned int seed=omp_get_thread_num();
#pragma omp for private(x,y) reduction(+:Ncirc)
  for (i = 0; i < num_trials; i++) {
    x = (double)rand_r(&seed)/RAND_MAX;
    y = (double)rand_r(&seed)/RAND_MAX;
    if ((x*x + y*y) <= r2)
      Ncirc++;
  }
}
  // Get timer
  double clocktime = (double)timer.elapsed();
 
  pi = 4.0 * ((double)Ncirc)/((double)num_trials);
  printf("\n \t Computing pi using OpenMP: \n");
  printf("\t For %ld trials, pi = %f\n", num_trials, pi);
  printf("\t Time required [ms] = %f\n", clocktime*1000.);
  printf("\n");
 
  return 0;
}
