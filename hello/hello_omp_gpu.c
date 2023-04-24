/* Copyright (c) 2019 CSC Training */
/* Copyright (c) 2021 ENCCS */
#include <stdio.h>
#include <omp.h>

int main() 
{
  int num_devices = omp_get_num_devices();
  printf("Number of available devices %d\n", num_devices);

  #pragma omp target 
  #pragma omp teams num_teams(4) thread_limit(5)
  #pragma omp parallel
  {
      if ( omp_is_initial_device() ) {
        printf("Running on host\n");
      } else {
        int thid = omp_get_thread_num();
        int nthreads= omp_get_num_threads();
        int teid = omp_get_team_num();
        int nteams= omp_get_num_teams(); 
        printf("Hello from GPU thread %d (out of %d) in team %d (out of %d)\n",thid,nthreads,teid,nteams);
      }
  }

}
