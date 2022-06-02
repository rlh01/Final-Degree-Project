#! /bin/bash

#TELOMERES extension

FASTA=$1

export PATH=/home/devel/fcruz/bin/curation/telomeric-identifier/target/release/:$PATH

## Option 1: Using FINDER tool with vertebrate clade
#Command: tidk find 
#Parameters: clade, fasta file and output name.

tidk find --clade vertebrate --fasta $FASTA --output vertebrates

# Making a plot of the telomeres with the .csv generated
tidk plot --csv finder/vertebrates_telomeric_repeat_windows.csv


## Option 2: Using SEARCH module for a particular motif

#Command: tidk search 
#Parameters: extension, fasta file and string.
#TTAGGG motif is the most common in vertebrates

tidk search --extension bedgraph --fasta $FASTA --string TTAGGG


