#!/bin/bash -l
#SBATCH -J IOR
#SBATCH --time=01:15:00
#SBATCH --ntasks=128
#SBATCH --mem-per-cpu=4513M

module load IOR

# Options
BLOCK_SIZE=400m  # Set the block size for I/O operations to 400MB
WORKDIR=$(pwd)/work_ior
mkdir -p $WORKDIR

#Multi-stream Throughput Benchmark
srun ior -wr -i5 -t2m -b ${BLOCK_SIZE} -g -F -e -o $WORKDIR/ior_multi_stream_throughput.txt

#Shared File Throughput Benchmark
srun ior -wr -i5 -t1m -b ${BLOCK_SIZE} -g -e -o $WORKDIR/ior_share_file_throughput.txt

# IOPS Benchmark
srun ior -w -i5 -t4k -b ${BLOCK_SIZE} -F -z -g -o $WORKDIR/ior_iops.txt
