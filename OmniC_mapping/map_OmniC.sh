#! /bin/bash

#Parameters to be defined

THREADS=$1;
ASSEMBLY=$2; 
R1=$3; ## Concatenated reads 1
R2=$4; ## Concatenated reads 2

CORES=$(($THREADS/3)); ## Ensure enough threads

#Setup directory

CWD=$PWD;
mkdir -p tmpdir;
mkdir -p out;


#Link the FASTA
ln -s $ASSEMBLY assembly.fa

#Calculate the length of each scaffold
/scratch/project/devel/aateam/bin/fastalength $ASSEMBLY | gawk '{print $2"\t"$1}' > assembly.genome 

#Setup conda environment

module purge;
module load gcc/6.3.0;
module load mkl/11.3.3;
module load PYTHON/3.7.1;
module load CONDA/4.5.11_PYTHON3; 

source /home/devel/fcruz/bin/sourcefiles/initialize_conda.sh ## Initialize conda
conda activate /home/devel/fcruz/.conda/envs/dovetail/ ## Activate the dovetail environment
module purge;
export PATH=/home/devel/fcruz/bin/programs/Omni-C/:/home/devel/fcruz/bin/scripts/:$PATH

### 1. Index the genome 
bwa index -a bwtsw assembly.fa

### 1.1 Get the FAI INDEX
samtools faidx assembly.fa

### 2. Mapping and filtering low mapping quality alignments (<40) and PCR duplicates
bwa mem -5SP -T0 -t $CORES  assembly.fa $R1 $R2 | \
pairtools parse --min-mapq 40 --walks-policy 5unique --max-inter-align-gap 30 --nproc-in $CORES --nproc-out $CORES --chroms-path assembly.genome | \
pairtools sort --tmpdir=$CWD/tmpdir --nproc $CORES | \
pairtools dedup --nproc-in $CORES --nproc-out $CORES --mark-dups --output-stats out/stats.txt | \
pairtools split --nproc-in $CORES --nproc-out $CORES --output-pairs out/mapped.pairs --output-sam -| samtools view -bS -@ $CORES | \
samtools sort -@ $CORES -o out/mapped.PT.bam; samtools index out/mapped.PT.bam

# mapping parameters:
#  -5 take smallest coordinate at 5' for split alignments
#  -S skip mate rescue
#  -P skip pairing
#  -T0 The T flag set the minimum mapping quality of alignments to output, 
#   at this stage we want all the alignments to be recorded and thus T is set up to 0, 
#   (this will allow us to gather full stats of the library, at later stage we will filter the alignments by mapping quality


### 2.1 Generating the QC Library statistics
get_qc.py -p out/stats.txt > Omnic_QC_LibraryStats.txt

### 3. Parse BAM and sort it by read_name (inside out folder)
cd out 
samtools sort -@ $THREADS -n mapped.PT.bam -o mapped.PT.name_sorted.bam
 
### 4. Converting the BAM into a bed file (inside out folder)
bamToBed -i mapped.PT.name_sorted.bam > mapped.PT.name_sorted.bed
