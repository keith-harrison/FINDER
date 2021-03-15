#!/bin/bash
[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"
#Bowtie2 final output message just states the percentage of reads from the fastq that mapped the reference genome
bowtie2 -x refgenome --no-unal "$1" -S - -p 4 | \
samtools view -bS - | \
samtools sort -m 5G -o mapping_result_sorted.bam
samtools index mapping_result_sorted.bam
samtools mpileup mapping_result_sorted.bam | awk -v X="1" '$4>=X' | wc -l >> coverage
#write results to file
coverageamount=`cat coverage`

bowtie2-inspect -s refgenome | awk '{ FS = "\t" } ; BEGIN{L=0}; {L=L+$3}; END{print L}' >> length 
lengthamount=`cat length`
samtools depth -aa mapping_result_sorted.bam > genome.depth
python -c'import sys;  sys.path.append("/program/commands"); import plot_depth; plot_depth.plot_depth("genome.depth", "depth.png", "depth", '$lengthamount')'

echo "scale=4 ; $coverageamount /$lengthamount" | bc >> "$1"BowtieCoverage.txt

rm coverage
rm length
rm genome.depth
find . -name "*bt2" -type f -delete 
find . -name "*bai" -type f -delete 