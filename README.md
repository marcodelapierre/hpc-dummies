## HPC-dummies

Small codes for HPC testing:

* `hello/`: hello worlds
* `pidarts/`: MonteCarlo Pi codes
* `saxpy/`: SAXPY codes
* `saxpy2_profile/`: SAXPY codes for profiling tests (artifical loops)
* `matmul/`: matrix multiply codes
* `misc/`: utilities
  * `cpuid`: get CPU ID
  * `xthi`: get task and thread affinities
  * Kokkos installation scripts
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

