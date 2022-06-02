#! /bin/bash

bedgraph_file=$1; 
input_pretext=$2;
extension_name=$3

#Set up conda environment (Pretext-Suite)

module purge; 
module load CONDA/4.10.1_PYTHON3.8 ; 
source /apps/CONDA/4.10.1_PYTHON3.8/etc/profile.d/conda.sh ;
module load BEDTools/2.16.2;

conda activate pretext-suite-2022.01.17;
export PATH=/home/devel/fcruz/.conda/envs/pretext-suite-2022.01.17/bin/:$PATH;

cat $bedgraph_file | PretextGraph -i $input_pretext -n "$extension_name"
