#! /bin/bash

## GAPS

FILE=$1

# Look if column 6 equals to 200, meaning a gap has been inserted
# Output (bedgraph extension) -> .bg

awk '{if ($6==200) print $1"\t"$2"\t"$3"\t"$6}' $FILE > Gaps.bg
