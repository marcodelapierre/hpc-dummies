#!/bin/bash -l
#SBATCH --account=pawsey0001
#SBATCH --partition=gpuq-dev
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --output=%x.out

#echo $SLURM_JOB_NAME

download_tools="0"
tools_commit="c901382c4c76b108e4e6d190e9236848dc764526" # 5 April 2022

# just to be consistent with the rest of the relevant tools/application
module load cuda/11.4.2
module load openmpi-ucx-gpu/4.0.2

if [ "$download_tools" != "0" ] ; then
 git clone git@github.com:kokkos/kokkos-tools
fi

cd kokkos-tools
git checkout $tools_commit

rm -f kp_json_writer kp_reader kp_*.so probes.o profiling/systemtap-connector/probes.h

sed -i '/papi-connector/ s/^make/#make/' build-all.sh 
sed -i '/DUSE_MPI=0/ s/^#CFLAGS/CFLAGS/' profiling/space-time-stack/Makefile
sed -i '/DUSE_MPI=0/ s/^#CFLAGS/CFLAGS/' profiling/chrome-tracing/Makefile

bash build-all.sh
