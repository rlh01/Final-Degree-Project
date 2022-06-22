#! /bin/bash


# Specifying inputs
ASSEMBLY=$1; 
BAM=$2;  
TOLID=$3; 

#store the base working directory
CWD=$PWD;

# 1. Load modules 
module purge; 
module load gcc/6.3.0;
module load PYTHON/2.7.11;
module load java/1.8.0u31;
module load COREUTILS/8.21;
module load SAMTOOLS/1.9;

# 2. Link and index the input assembly fasta. 
    
ln -s $ASSEMBLY input4yahs.fa
samtools faidx input4yahs.fa -o input4yahs.fa.fai

# 3. YAHS

export PATH=/scratch/project/devel/aateam/src/yahs_2021_12_21:$PATH;
mkdir -p out;

yahs input4yahs.fa $BAM -o out/"$TOLID"_default_yahs # DEFAULT OPTION
yahs input4yahs.fa $BAM --no-contig-ec  -o out/"$TOLID"_no_error_yahs # NO-ERROR-CORRECTION STEP
