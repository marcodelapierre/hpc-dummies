#!/bin/bash -l
#SBATCH --account=pawsey0001
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --threads-per-core=1
#SBATCH --time=00:20:00
#SBATCH --output=%x.out

#echo $SLURM_JOB_NAME

download_tools="0"
tools_commit="c901382c4c76b108e4e6d190e9236848dc764526" # 5 April 2022

module unload gcc/9.3.0
module load craype-accel-amd-gfx908
module load rocm/4.5.0

if [ "$download_tools" != "0" ] ; then
 git clone git@github.com:kokkos/kokkos-tools kokkos-tools-mulan
fi

cd kokkos-tools-mulan
git checkout $tools_commit

rm -f kp_json_writer kp_reader kp_*.so probes.o profiling/systemtap-connector/probes.h

sed -i '/papi-connector/ s/^make/#make/' build-all.sh 
sed -i '/memory-hwm-mpi/ s/^make/#make/' build-all.sh 
sed -i '/nvprof-/ s/^make/#make/' build-all.sh 
sed -i '/nvprof-focused-connector/a make -f $ROOT_DIR/profiling/roctx-connector/Makefile' build-all.sh
sed -i '/DUSE_MPI=0/ s/^#CFLAGS/CFLAGS/' profiling/space-time-stack/Makefile
sed -i '/DUSE_MPI=0/ s/^#CFLAGS/CFLAGS/' profiling/chrome-tracing/Makefile
sed -i 's/CXX *= *mpicxx/CXX=g++/g' profiling/*/Makefile

bash build-all.sh
