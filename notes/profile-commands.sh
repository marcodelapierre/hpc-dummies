# rocm
# open trace on https://ui.perfetto.dev
rocprof --stats --sys-trace --hip-trace --hsa-trace ./rocm.x


# cuda
nvprof ./ax.x &>out_nvprof
#nvprof --analysis-metrics -o metrics ./ax.x  # better to use nsys, with nsight gui

nsys profile -t cuda,nvtx,osrt -o rep_ax ./ax.x 
nsys stats rep_ax.qdrep &>rep_ax.txt
# one shot, however all output captured
nsys profile -t cuda,nvtx,osrt -o rep_ax --stats=true ./ax.x &>rep_ax.txt

nsys profile -t cuda,cublas,osrt -o rep_blas ./blas.x 
nsys stats rep_blas.qdrep &>rep_blas.txt


# cuda kernels
nvprof --kernels saxpy -e all -m all ./ax.x &>out_nvprof_kernel

ncu -k saxpy ./ax.x &>out_ncu_kernel  # from V100 onwards
# the following produces output for Nsight Compute
ncu -k saxpy -o rep_ncu_ax ./ax.x     # from V100 onwards


# Arm MAP
# Arm suggested compile flags (case by case): -O3 -g1 -fno-inline -fno-optimize-sibling-calls
map --profile ./ax.x


# kokkos-tools 
# see https://github.com/kokkos/kokkos-tutorials/blob/main/LectureSeries/KokkosTutorial_07_Tools.pdf
tools_dir="/group/pawsey0001/mdelapierre/VISCOUS/kokkos-setup/kokkos-tools"
#
# 1. kernel timer
export KOKKOS_PROFILE_LIBRARY="${tools_dir}/kp_kernel_timer.so"
alias kp_reader="${tools_dir}/kp_reader"
./ax_kk.x
kp_reader <datfile>.dat
#
# 2. space-time stack
export KOKKOS_PROFILE_LIBRARY="${tools_dir}/kp_space_time_stack.so"
./ax_kk.x
# 3.
export KOKKOS_PROFILE_LIBRARY="${tools_dir}/kp_nvprof_connector.so"
nsys profile -t cuda,nvtx,osrt -o rep_ax_kk ./ax.x
# 4.
export KOKKOS_PROFILE_LIBRARY="${tools_dir}/kp_roctx_connector.so"
rocprof --stats --sys-trace --roctx-trace -o rocprof_ax_kk.csv ./saxpy2_kokkos.x >log_ak_kk.txt

# caliper
# see https://software.llnl.gov/Caliper/CUDA.html
CALI_CONFIG=runtime-report,profile.cuda ./ax.x &>out_ax_cuda_api
CALI_CONFIG=cuda-activity-report ./ax.x &>out_ax_cuda_activity
CALI_CONFIG=cuda-activity-report,cuda.memcpy ./ax.x &>out_ax_cuda_mem

