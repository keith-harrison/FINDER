#!/bin/bash
#Allows parameter input from another .sh file
[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"
#Bowtie2 final output message just states the percentage of reads from the fastq that mapped the reference genome
#Build reference genome, and sort the file 5G representing amount of current memory
bowtie2 -f -x refgenome --no-unal -U "$1" -S - -p 4 | \
samtools view -bS - | \
samtools sort -m 5G -o mapping_result_sorted2.bam
samtools index mapping_result_sorted2.bam
#Mpileup generates a big text output and we search using AWK everytime we find a reference sequence that has been found one or more times
samtools mpileup mapping_result_sorted2.bam | awk -v X=1 '$4>=X' | wc -l >> coverage
#The X="1" can be changed to get desired levels of depth of coverage, but unadvised for metagenomic samples as hard to find even a low coverage 

#Find number of bases in coverage and reference respectively and divide them to find the depth of coverage and times by 100 to get the breadth of coverage. 
coverageamount=`cat coverage`

bowtie2-inspect -s refgenome | awk '{ FS = "\t" } ; BEGIN{L=0}; {L=L+$3}; END{print L}' >> length 
lengthamount=`cat length`
#Calculate depth at each part to make a coverage histogram (showing where in reference genome most matches occur)
samtools depth -aa mapping_result_sorted2.bam > genome.depth
python -c'import sys;  sys.path.append("/program/commands"); import plot_depth; plot_depth.plot_depth("genome.depth", "depth2.png", "depth", '$lengthamount')'
#x100
echo "scale=4 ; 100 * $coverageamount /$lengthamount" | bc >> "$1"BowtieCoverage2.txt
rm coverage
rm length
rm genome.depth
