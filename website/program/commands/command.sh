rm /work/start.txt
#Downloads Genbank file 
[ ! -r assembly_summary_genbank.txt ] && wget ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/assembly_summary_genbank.txt
#DOWNLOAD SRA FILES (SRR FILES)
fasterq-dump @SRRNUMBER @SRRNUMBER -O ${PWD}
#Below is alternative way of downloading SRA data slower but will not download more than needed BREAKS ON PAIRED READS
#fastq-dump -X --split-files 5000000000 @SRRNUMBER @SRRNUMBER -O ${PWD} 
#Concatenate the individual paired read files together
[ -r @SRRNUMBER_1.fastq ] && for i in {1..2}; do cat @SRRNUMBER_"$i".fastq >> @SRRNUMBER.fastq ; done
#SPLIT BIG FILES FOR INDEPENDENT ANALYSIS TO BE JOINED LATER
split -b 5G -d @SRRNUMBER.fastq @SRRNUMBER.fastq
#Removes paired reads as there is now an intertwined file
rm @SRRNUMBER_*.fastq
#RENAME FILES TO BE NICER
ls *.fastq0*| cat -n | while read n f; do mv -n "$f" "$n"@SRRNUMBER.fastq; done 
rm @SRRNUMBER.fastq
#Only want to know details about first 5GB from file
ls *@SRRNUMBER.fastq | cat | tail -n+2 | while read -r line; do  sudo rm "$line"   ; done
#DOWNLOAD METADATA BEHIND SRA FILE AND CODING REGIONS FROM ISOLATES WANTING TO BE FOUND
wget -O ./@SRRNUMBER_info.csv 'http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?save=efetch&db=sra&rettype=runinfo&term= @SRRNUMBER'

if test -f "/work/SPECIES.txt"; then
    #Species searched for on genbank file and has their coding regions downloaded. do on [ -r SPECIES.txt ] && reference.sh
    grep -E '@SPECIES' assembly_summary_genbank.txt | cut -f 20 > ftp_folder.txt
    sed -i '4,$ d' ftp_folder.txt
    awk 'BEGIN{FS=OFS="/";filesuffix="cds_from_genomic.fna.gz"}{ftpdir=$0;asm=$10;file=asm"_"filesuffix;print "wget "ftpdir,file}' ftp_folder.txt > download_fna_files.sh
    bash download_fna_files.sh
    rm download_fna_files.sh
    gzip -d *.gz 
    #COMBINE ALL REFERENCE GENOMES INTO ONE (MAY BE BETTER TO TREAT INDIVIDUALLY BUT THE BAM FILE CREATED MY GIVE IDEA OF COVERAGE PER REFERENCE)
    cat *.fna > mergedreference.fasta 
    rm *.fna
fi

#if reference manually entered move from php folder
[ -r /work/mergedreference.fasta ] && mv /work/mergedreference.fasta /program



#GENERATE QUALITY ANALYSIS FOR FILES BEFORE TRIMMING
fastqc *.fastq* 

multiqc -n beforetrimmingquality ./*_fastqc.zip

find . -name "*_fastqc*" -type f -delete 

#PERFORM CUTADAPT ON DEFAULT SETTINGS
ls 1*.fastq| cat | while read -r line; do cutadapt --cores=4 -o trimmed"$line" "$line"  ; done

#GENERATE QUALITY ANALYSIS FOR FILES POST TRIMMING
fastqc trimmed1*.fastq*

multiqc -n trimmedquality ./*_fastqc.zip
find . -name "*_fastqc*" -type f -delete 

#PERFORM BOWTIE2 ALIGNMENT TO LOOK AT COVERAGE
bowtie2-build mergedreference.fasta refgenome

ls trimmed1*.fastq| cat | while read -r line; do bash ./commands/bowtiecoverage.sh "$line"   ; done


if test -f "/work/assemble.txt"; then
    #Turn aligned reads into a fastq to be assembled into contigs
    samtools bam2fq mapping_result_sorted.bam > aligned.fastq
    #PERFORM ASSEMBLY BY SPAdes USING aligned reads from Bowtie2
    ls trimmed1*.fastq| cat | while read -r line; do  python3 "/SPAdes-3.15.2/spades.py" -k 23,33,43,53,63,73,83,93,103,113 -s aligned.fastq  -o "$line".d ; done


fi

#THESE FILES FROM BOWTIE RELATING TO THE REFERENCE GENOME as no longer needed
find . -name "*bt2" -type f -delete 
find . -name "*bai" -type f -delete 

#Delete large files no longer needed
rm trimmed1@SRRNUMBER.fastq
rm 1@SRRNUMBER.fastq
#MOVE FILES INTO OUTPUT FOLDER
mv beforetrimmingquality.html beforetrimmingquality_data
mv trimmedquality.html trimmedquality_data
chmod -R 777 beforetrimmingquality
chmod -R 777 trimmedquality

mkdir ${PWD}/@TITLE

mv *@SRRNUMBER.* ${PWD}/@TITLE
find . *trim* -maxdepth 0 -type f | cat | while read -r line; do sudo mv "$line" ${PWD}/@TITLE ; done
mv mergedreference.fasta  ${PWD}/@TITLE
sudo mv ${PWD}/beforetrimmingquality_data ${PWD}/@TITLE
sudo mv ${PWD}/trimmedquality_data ${PWD}/@TITLE
mv ftp_folder.txt ${PWD}/@TITLE
mv @SRRNUMBER_info.csv ${PWD}/@TITLE
mv mapping_result_sorted.bam ${PWD}/@TITLE && mv depth.png ${PWD}/@TITLE 
#PERFORM QUAST, gives a comparative analysis between MAG - Metagenomic Assembled Genome and Reference Genome * CHANGE QUAST
[ -r /work/assemble.txt ] && mv aligned.fastq ${PWD}/@TITLE && ls ${PWD}/@TITLE/trimmed1*.fastq.d| cat | while read -r line; do python3 /quast-quast_5.1.0rc1/quast.py -R ${PWD}/@TITLE/mergedreference.fasta "$line"/scaffolds.fasta -o "$line"referencereport   ; done

rm /work/assemble.txt
