#! /bin/bash

module purge;
module load samtools;

# Generating the BAM file for only the break coordinates

INTERVALS_COORDS=$1
SORTED_BAM=$2

samtools view -R $INTERVALS_COORDS -b $SORTED_BAM > IGV_breaks.bam
