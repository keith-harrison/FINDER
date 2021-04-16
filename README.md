# FINDER
FINDER is a library/docker container for a pipeline performing: Downloading of SRA/DRA/ERA data, Quality control, Alignment with reference and optionally Assembly by reference creating Metagenomic assembled genomes.
This tool is intended to work alongside blast screening to determine whether or not a reference sequence appears within metagenomic data. If so how much? But can be used similarly to blast to give a coverage of a reference sequence.
## Tools Used
* Retrieval of FASTQ files and corresponding metadata and reference genomes from NCBI, using fasterq-dump
* Quality control and trimming with Cutadapt, FastQC and MultiQC.
* Alignment created using Bowtie between the reference and raw data.
* SAMtools to create coverage tables of the reference, then calculating the breadth of coverage found at atleast 1X depth. - Can be changed in bowtiecoverage(2).sh files.
* SPAdes to create an Metagenomic Assembled Genome using the aligned sequences from Bowtie2 alongside
    and De Novo methods.
* Quast to look at the quality and accuracy and to perform a comparison against the reference, producing a report.
## Installation
For this package you can easily run it on a local machine or a Google Cloud web service. First Installation takes a while through Docker as it is having to compile all the code needed (around 5-10mins)

### Local Machine

Prerequisites

Before you continue, ensure you have met the following requirements:
* You have installed [Docker](https://docs.docker.com/get-docker/) for your operating system.
* If you are on windows then you will also need [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
```bat
git clone https://github.com/keith-harrison/FINDER/
cd FINDER
docker-compose up 
```
* Access website at localhost:80
* instructions detailed on website and files saved to localhost/program

### Google Cloud Setup

Before you continue, ensure you have met the following requirements:
* Google Cloud Account with Credit on (~£0.077/hour when being fully used for 24 hours, so shutdown when not in use of processing)
* Create the VM instance with information below and SSH performing the code below.
* Changing boot disk options using Container Optimized Machine OS, e2-standard-2 as with ~75GB+ of storage and allow HTTP traffic

```bat
#There are some issues with permissions so chmod is needed
#Can take sometime to setup on first try (around 5-10mins) as all dependencies are downloaded.
git clone https://github.com/keith-harrison/FINDER/
chmod -R 777 FINDER 
cd FINDER
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w="$PWD" docker/compose:1.24.0 up
```
* Access website at ip given on VM instance page externalip:80 
* instructions detailed on website and files can be accessed on externalip/program


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
