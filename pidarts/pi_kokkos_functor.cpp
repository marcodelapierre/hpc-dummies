/* Compute pi using Kokkos */
#include <Kokkos_Core.hpp>
#include <Kokkos_Random.hpp>
#include <cstdio>

struct shoot_darts {
  // The GeneratorPool
  Kokkos::Random_XorShift64_Pool<> rand_pool;

  const double r = 1.0; // radius of circle
  const double r2 = r*r;

  // Initialize all members
//g  shoot_darts()
//      : {}

  KOKKOS_INLINE_FUNCTION
  void operator()(long i, long& Ncirctmp) const {
    // Get a random number state from the pool for the active thread
    typename Kokkos::Random_XorShift64_Pool<>::generator_type rand_gen = rand_pool.get_state();

    double x = rand_gen.urand64(1);
    double y = rand_gen.urand64(1);
    if ((x*x + y*y) <= r2)
      Ncirctmp++;

    // Give the state back, which will allow another thread to acquire it
    rand_pool.free_state(rand_gen);
  }
};
 

int main(int argc, char **argv) {

  Kokkos::initialize(argc, argv);
  Kokkos::Random_XorShift64_Pool<> rand_pool64(5374857);
  Kokkos::Random_XorShift64_Pool<> rand_pool;

  const long num_trials = 1000000;
  long Ncirc = 0;

  // Start timer
  Kokkos::Timer timer;
  // for loop with most of the compute
  Kokkos::parallel_reduce( "shoot_darts", num_trials, shoot_darts(), Ncirc);
  Kokkos::fence();
  // Get timer
  double clocktime = (double)timer.seconds();

  double pi = 4.0 * ((double)Ncirc)/((double)num_trials);

  printf("\n \t Computing pi using Kokkos: \n");
  printf("\t For %ld trials, pi = %f\n", num_trials, pi);
  printf("\tTime required [ms] = %f\n", clocktime*1000.);
  printf("\n");

  Kokkos::finalize();

  return 0;
}

