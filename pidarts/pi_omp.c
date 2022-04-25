/* Compute pi using OpenMP */
#include <omp.h>
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
#pragma omp parallel
{
#pragma omp for private(x,y) reduction(+:Ncirc)
  for (i = 0; i < num_trials; i++) {
#pragma omp critical (randoms)
{
    x = lcgrandom();
    y = lcgrandom();
}
    if ((x*x + y*y) <= r2)
      Ncirc++;
  }
}
 
  pi = 4.0 * ((double)Ncirc)/((double)num_trials);
  printf("\n \t Computing pi using OpenMP: \n");
  printf("\t For %ld trials, pi = %f\n", num_trials, pi);
  printf("\n");
 
  return 0;
}
