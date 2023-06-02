## HPC-dummies

Small codes for HPC testing:

* `apps/`:
  * `hello/`: hello worlds
  * `pidarts/`: MonteCarlo Pi codes
  * `saxpy/`: SAXPY codes
  * `saxpy2_profile/`: SAXPY codes for profiling tests (artifical loops)
  * `matmul/`: matrix multiply codes
* `tools/`:
  * `affinity/cpuid`: get CPU ID
  * `affinity/xthi`: get task and thread affinities
  * `affinity/hello_jobstep_hip`: HIP enabled affinities
  * `kokkos/`: Kokkos installation scripts
  * `osu/`: OSU MPI Benchmark tests
  * Caliper installation script
* `notes/`: text notes

Adopted paradigms include:
* Serial
* Serial with AVX2
* OpenMP
* OpenMP with target offloading
* CUDA
* HIP
* Kokkos (including Kernels and RNG)
* MPI

