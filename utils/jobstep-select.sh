#!/bin/bash -l
#SBATCH --job-name=jobstep-select
#SBATCH --output=%x.out
#SBATCH --account=pawsey0012-gpu
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --threads-per-core=1
#SBATCH --gpus-per-node=8
#SBATCH --exclusive
#SBATCH --time=00:01:00
#SBATCH --export=NONE 

module load rocm/5.0.2
module load craype-accel-amd-gfx90a

cat << EOF > select_gpu
#!/bin/bash

export ROCR_VISIBLE_DEVICES=\$SLURM_LOCALID
exec \$*
EOF

chmod +x ./select_gpu

for n in {1..8} ; do srun --exact -n $n --gpus-per-node=$n ./select_gpu ./hello_jobstep_hip.x ; echo " " ; done

rm -f ./select_gpu
