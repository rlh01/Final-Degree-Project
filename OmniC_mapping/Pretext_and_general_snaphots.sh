#! /bin/bash

## Getting PreText Contact Map and Snapshots (inside out folder)

# Enter the folder
cd out

# Set up environment
module purge; 
module load CONDA/4.10.1_PYTHON3.8 ; 
source /apps/CONDA/4.10.1_PYTHON3.8/etc/profile.d/conda.sh ;
conda activate /home/devel/fcruz/.conda/envs/pretext-suite-2022.01.17;
export PATH=/home/devel/fcruz/.conda/envs/pretext-suite-2022.01.17/bin/:$PATH;

## 1. Generate contact map keeping mapping quality filter at 10 (default)
samtools view -h mapped.PT.name_sorted.bam | PretextMap -o assembly.pretext --sortby length --sortorder descend --mapq 10 

# Plot SnapShots in for all assembly and per-scaffold

mkdir -p snapshots/orange1
mkdir -p snapshots/three_wave_blue_green_yellow

cd snapshots

#three_wave_blue_green_yellow
PretextSnapshot -m ../assembly.pretext  --sequences "=full" -o ./three_wave_blue_green_yellow 
PretextSnapshot -m ../assembly.pretext  --sequences "=all" -o ./three_wave_blue_green_yellow

#orange1 
PretextSnapshot -m ../assembly.pretext -c "Orange 1" --sequences "=full" -o ./orange1
PretextSnapshot -m ../assembly.pretext -c "Orange 1" --sequences "=all" -o ./orange1

conda deactivate; 
