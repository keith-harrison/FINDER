rm /work/start.txt
#Downloads Genbank file 
[ ! -r assembly_summary_genbank.txt ] && wget ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/assembly_summary_genbank.txt
#DOWNLOAD SRA FILES (SRR FILES)
fasterq-dump ERR2367946 ERR2367946 -O ${PWD} 
#TURN PAIRED READS INTO SOMETHING ALIKE SINGLE
[ -r ERR2367946_1.fastq ] && for i in {1..2}; do cat ERR2367946_"$i".fastq >> ERR2367946.fastq ; done
#SPLIT BIG FILES FOR INDEPENDENT ANALYSIS TO BE JOINED LATER
#debate whether or not to remove splitting on large files on AWS
split -b 20G -d ERR2367946.fastq ERR2367946.fastq

rm ERR2367946_*.fastq
#RENAME FILES TO BE NICER
ls *.fastq0*| cat -n | while read n f; do mv -n "$f" "$n"ERR2367946.fastq; done 
rm ERR2367946.fastq
#DOWNLOAD METADATA BEHIND SRA FILE AND CODING REGIONS FROM ISOLATES WANTING TO BE FOUND
wget -O ./ERR2367946_info.csv 'http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?save=efetch&db=sra&rettype=runinfo&term= ERR2367946'

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
ls *.fastq| cat | while read -r line; do cutadapt --cores=4 -o trimmed"$line" "$line"  ; done

#GENERATE QUALITY ANALYSIS FOR FILES POST TRIMMING
fastqc trimmed*.fastq*

multiqc -n trimmedquality ./*_fastqc.zip
find . -name "*_fastqc*" -type f -delete 

#PERFORM BOWTIE2 ALIGNMENT TO LOOK AT COVERAGE
bowtie2-build mergedreference.fasta refgenome

ls trimmed*.fastq| cat | while read -r line; do bash ./commands/bowtiecoverage.sh "$line"   ; done


if test -f "/work/assemble.txt"; then
    #PERFORM ASSEMBLY BY ragtag USING TRUSTED CONTIGS FROM REFERENCE
    ls trimmed*.fastq| cat | while read -r line; do python3 /root/miniconda3/bin/ragtag.py scaffold -o "$line".d --aligner "/root/miniconda3/bin/minimap2" mergedreference.fasta "$line" ; done
    #perform assembly by RagTag
    ls trimmed*ERR2367946.fastq.d/ragtag.scaffolds.fasta | cat | while read -r line; do bash ./commands/bowtiecoverage2.sh "$line"   ; done


fi

#THESE FILES FROM BOWTIE RELATING TO THE REFERENCE GENOME AND ITS INDEXING CAN BE REUSED FOR BOTH SO ONLY DELETED NOW
find . -name "*bt2" -type f -delete 
find . -name "*bai" -type f -delete 

#MOVE FILES INTO OWN OUTPUT FOLDER
mv beforetrimmingquality.html beforetrimmingquality_data
mv trimmedquality.html trimmedquality_data

mkdir ${PWD}/ERR2367946vsEnterocytozoonbieneusi
mv *ERR2367946.* ${PWD}/ERR2367946vsEnterocytozoonbieneusi
find . *trim* -maxdepth 0 -type f | cat | while read -r line; do sudo mv "$line" ${PWD}/ERR2367946vsEnterocytozoonbieneusi ; done
mv mergedreference.fasta  ${PWD}/ERR2367946vsEnterocytozoonbieneusi
sudo mv ${PWD}/beforetrimmingquality_data ${PWD}/ERR2367946vsEnterocytozoonbieneusi
sudo mv ${PWD}/trimmedquality_data ${PWD}/ERR2367946vsEnterocytozoonbieneusi
mv ftp_folder.txt ${PWD}/ERR2367946vsEnterocytozoonbieneusi
mv ERR2367946_info.csv ${PWD}/ERR2367946vsEnterocytozoonbieneusi
mv mapping_result_sorted.bam ${PWD}/ERR2367946vsEnterocytozoonbieneusi && mv depth.png ${PWD}/ERR2367946vsEnterocytozoonbieneusi 
#PERFORM QUAST
[ -r /work/assemble.txt ] && ls ${PWD}/ERR2367946vsEnterocytozoonbieneusi/trimmed*.fastq| cat | while read -r line; do python3 /quast-quast_5.1.0rc1/quast.py -R ${PWD}/ERR2367946vsEnterocytozoonbieneusi/mergedreference.fasta "$line".d/ragtag.scaffolds.fasta -o "$line"referencereport   ; done
[ -r /work/assemble.txt ] && mv mapping_result_sorted2.bam ${PWD}/ERR2367946vsEnterocytozoonbieneusi && mv depth2.png ${PWD}/ERR2367946vsEnterocytozoonbieneusi 
rm /work/assemble.txt

#inants into the docker file would mean we can put it onto docker and then use wget to get all files needed
#R file for displays of coverage or just put into tables of X Y COVERAGE multiple studies.


#TO DO 
#webservice 2 
#outputs quast research 3
#R 3
#AWS 2
#phylogeny 4~
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
#split steps into separate bashf iles*
#allow coverage on each sequence?!?!~
#assembly - using RagTag 
#change title/sra/era more in line with tax/genus/strain vs data*
#button that runs a quick statistical analysis on all folders that have SRRNO vs SPecies
#change folder name to be NUMBERvsSPECIES(CHANGE TO ONE WORD)*
#do bryonys test she sent (3gb file so watch out)
#allow reference to be added as a text file in*

#TO DO 
#Monday
#Python/R Graphs 1 - button making graphs for suffix or genus
# which checks all folders recursively looking for bowtie coverage txt files when found put onto the same graph if in same folder
#do graphs 
#Look into Bam/Sam visualisation to see where are hits in SRA 
#dont dispose of bam and make this 
#RagTag Assembly 2 
#Isca/Cloud AWS 3

#TODO
#set up graph creation of bowtie numbers wrt grep name find all bowties
#do this https://medium.com/ngs-sh/coverage-analysis-from-the-command-line-542ef3545e2c for each for visulisation
#Ragtag try and assemble 
#Wednesday
#CLOUDDD
#Set up for next week 
#Questionaire/Workshop 4
#Test tonight with bryonys thing 

#write thing