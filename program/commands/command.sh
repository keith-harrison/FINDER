rm /work/start.txt
#Downloads Genbank file 
[ ! -r assembly_summary_genbank.txt ] && wget ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/assembly_summary_genbank.txt
#DOWNLOAD SRA FILES (SRR FILES)
fasterq-dump @SRRNUMBER @SRRNUMBER -O ${PWD} 
#TURN PAIRED READS INTO SOMETHING ALIKE SINGLE
[ -r @SRRNUMBER_1.fastq ] && for i in {1..2}; do cat @SRRNUMBER_"$i".fastq >> @SRRNUMBER.fastq ; done
#SPLIT BIG FILES FOR INDEPENDENT ANALYSIS TO BE JOINED LATER
#debate whether or not to remove splitting on large files on AWS
split -b 20G -d @SRRNUMBER.fastq @SRRNUMBER.fastq

rm @SRRNUMBER_*.fastq
#RENAME FILES TO BE NICER
ls *.fastq0*| cat -n | while read n f; do mv -n "$f" "$n"@SRRNUMBER.fastq; done 
rm @SRRNUMBER.fastq
#DOWNLOAD METADATA BEHIND SRA FILE AND CODING REGIONS FROM ISOLATES WANTING TO BE FOUND
wget -O ./@SRRNUMBER_info.csv 'http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?save=efetch&db=sra&rettype=runinfo&term= @SRRNUMBER'

if test -f "/work/SPECIES.txt"; then
    #Species searched for on genbank file and has their coding regions downloaded. do on [ -r SPECIES.txt ] && reference.sh
    grep -E 'Enterocytozoon bieneusi' assembly_summary_genbank.txt | cut -f 20 > ftp_folder.txt
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
ls *.fastq| cat | while read -r line; do cutadapt --cores=0 -o trimmed"$line" "$line"  ; done

#GENERATE QUALITY ANALYSIS FOR FILES POST TRIMMING
fastqc trimmed*.fastq*

multiqc -n trimmedquality ./*_fastqc.zip
find . -name "*_fastqc*" -type f -delete 

#PERFORM BOWTIE2 ALIGNMENT TO LOOK AT COVERAGE
bowtie2-build mergedreference.fasta refgenome

ls trimmed*.fastq| cat | while read -r line; do ./commands/bowtiecoverage.sh "$line"   ; done



find . -name "*bt2" -type f -delete 
find . -name "*bam*" -type f -delete 

if test -f "/work/assemble.txt"; then
    #PERFORM ASSEMBLY BY SPADES USING TRUSTED CONTIGS FROM REFERENCE
    ls trimmed*.fastq| cat | while read -r line; do python3 /usr/local/bin/spades.py --phred-offset 33 -s "$line" -o "$line".d   ; done
    #perform assembly by RagTag
    bowtie2-build mergedreference.fasta refgenome
    ls trimmed*@SRRNUMBER.fastq.d/scaffolds.fasta | cat | while read -r line; do ./commands/bowtiecoverage2.sh "$line"   ; done
    find . -name "*bt2" -type f -delete 
    find . -name "*bam*" -type f -delete 
fi

#MOVE FILES INTO OWN OUTPUT FOLDER
mv beforetrimmingquality.html beforetrimmingquality_data
mv trimmedquality.html trimmedquality_data
mkdir ${PWD}/@SRRNUMBER
mv *@SRRNUMBER.* ${PWD}/@SRRNUMBER
find . *trim* -maxdepth 0 -type f | cat | while read -r line; do sudo mv "$line" ${PWD}/@SRRNUMBER   ; done

mv mergedreference.fasta  ${PWD}/@SRRNUMBER
sudo mv ${PWD}/beforetrimmingquality_data ${PWD}/@SRRNUMBER
sudo mv ${PWD}/trimmedquality_data ${PWD}/@SRRNUMBER
mv ftp_folder.txt ${PWD}/@SRRNUMBER
mv @SRRNUMBER_info.csv ${PWD}/@SRRNUMBER
#PERFORM QUAST
[ -r /work/assemble.txt ] && ls ${PWD}/@SRRNUMBER/trimmed*.fastq| cat | while read -r line; do python3 /quast-quast_5.1.0rc1/quast.py -R ${PWD}/@SRRNUMBER/mergedreference.fasta "$line".d/scaffolds.fasta -o "$line"referencereport   ; done
rm /work/assemble.txt
rm /work/SPECIES.txt

#stats R script that plots a graph of coverage by bowtie2 <3 
#params for species/contaminants into the docker file would mean we can put it onto docker and then use wget to get all files needed
#R file for displays of coverage or just put into tables of X Y COVERAGE multiple studies.


#TO DO 
#webservice 2 
#outputs quast research 3
#R 3
#AWS 2
#phylogeny 4
#entrypoint 2 *
#paired/unpaired reads 1 *
#github 3
#bryony meeting 2 *
#bryony workshop 4
#combining assemblies (may not bother if on aws because high memory thing) 1 ~
#steps into containers 2 *
#phred 3
#control 1 ~ meh

#clustalx
#update genbank file [wget thing] *
#mega phylogeny

#option for manually inputted reference genomes [ Another text box, check if its a fasta file ] *
#optional quality control - have check for [ * .fastq]?? have to be fastq data *
#split steps into separate bashf iles
#allow coverage on each sequence?!?!
#assembly - using RagTag
#change title/sra/era more in line with tax/genus/strain vs data
#button that runs a quick statistical analysis on all folders that have SRRNO vs SPecies
#change folder name to be NUMBERvsSPECIES(CHANGE TO ONE WORD)
#do bryonys test she sent (3gb file so watch out)
#allow reference to be added as a text file in*