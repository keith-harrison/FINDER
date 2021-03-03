#!/bin/bash
[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"
#Bowtie2 final output message just states the percentage of reads from the fastq that mapped the reference genome
bowtie2 -x refgenome --no-unal -U "$1" -S - -p 12 | \
samtools view -bS - | \
samtools sort -m 5G -o mapping_result_sorted.bam
samtools index mapping_result_sorted.bam
samtools mpileup mapping_result_sorted.bam | awk -v X=1 '$4>=X' | wc -l >> coverage
#write results to file
coverageamount=`cat coverage`

bowtie2-inspect -s refgenome | awk '{ FS = "\t" } ; BEGIN{L=0}; {L=L+$3}; END{print L}' >> length 
lengthamount=`cat length`


echo "scale=4 ; $coverageamount /$lengthamount" | bc >> "$1"BowtieCoverage.txt

rm coverage
rm length