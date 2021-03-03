FROM ubuntu

RUN apt-get update && apt-get install -y software-properties-common

RUN apt-get update && \
	apt-get install -y openjdk-8-jre && \
	rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get -qq update && apt-get -y upgrade && \
	apt install -y wget libfindbin-libs-perl software-properties-common unzip && \
    apt-get install -y software-properties-common build-essential && \
    apt-get install -y python3-pip python3-dev build-essential && \
    apt-get install -y wget libxml-libxml-perl

RUN apt-get install -y samtools bcftools

RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip -O /tmp/fastqc.zip && \ 
    unzip /tmp/fastqc.zip -d /opt/ && \
    rm /tmp/fastqc.zip && \
    chmod 777 /opt/FastQC/fastqc

RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.0/sratoolkit.2.10.0-ubuntu64.tar.gz -O /tmp/sratoolkit.tar.gz \
	&& tar zxvf /tmp/sratoolkit.tar.gz -C /opt/ && rm /tmp/sratoolkit.tar.gz

ENV PATH="/opt/sratoolkit.2.10.0-ubuntu64/bin/:${PATH}"

RUN wget -q -O bowtie2.zip http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.4.2/bowtie2-2.4.2-linux-x86_64.zip/download; \ 
	unzip bowtie2.zip -d /opt/; \ 
	ln -s /opt/bowtie2-2.4.2-linux-x86_64/ /opt/bowtie2; \ 
	rm bowtie2.zip 
ENV PATH $PATH:/opt/bowtie2 

RUN apt-get -qq update && apt-get -y upgrade && \
	apt-get install -y python3-pip python3-dev build-essential

RUN pip3 install --upgrade pip==9.0.1 && \
	pip3 install --upgrade virtualenv

RUN pip3 install --user --upgrade cutadapt && \
	ln -s /root/.local/bin/cutadapt /usr/bin/

RUN pip3 install regex

RUN apt-get install sudo

RUN adduser root sudo

RUN sudo apt-get -y install cmake

RUN sudo apt-get install -y libbz2-dev

RUN wget http://cab.spbu.ru/files/release3.15.0/SPAdes-3.15.0.tar.gz; \ 
	tar -xzf SPAdes-3.15.0.tar.gz; \
	rm SPAdes-3.15.0.tar.gz; \
	PREFIX=/usr/local ./SPAdes-3.15.0/spades_compile.sh;
ENV PATH="/usr/local/bin:${PATH}"

RUN apt-get install dos2unix

ENV PATH="/opt/FastQC/:${PATH}"

RUN pip install multiqc
RUN  wget -q -O  quast-5.1.0rc1.tar.gz --no-check-certificate https://github.com/ablab/quast/archive/quast_5.1.0rc1.tar.gz; \
    tar -xzf quast-5.1.0rc1.tar.gz; \
	rm  quast-5.1.0rc1.tar.gz; 
RUN sudo apt-get install bc

