# FINDER
FINDER is a library/docker container for a pipeline performing: Downloading of SRA/DRA/ERA data, Quality control, Alignment with reference and optionally Assembly by reference creating Metagenomic assembled genomes.
This tool is intended to work alongside blast screening to determine whether or not a reference sequence appears within metagenomic data. If so how much? But can be used similarly to blast to give a coverage of a reference sequence.

## Installation
For this package you can easily run it on a local machine or a Google Cloud web service.

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
* Google Cloud Account with Credit on (~£1.84/day when being fully used for 24 hours, so shutdown when not in use of processing)
* Changing boot disk options using Container Optimized Machine OS, e2-standard-2 as with ~75GB+ of storage and allow HTTP traffic
* Create the VM instance and SSH performing the code below.
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
