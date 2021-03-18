# FINDER
FINDER is a library/docker container for a pipeline performing: Download, Quality control, Alignment with reference and optionally Assembly by reference creating Metagenomic assembled genomes.
This tool is intended to work alongside blast screening to determine whether or not a reference sequence appears within metagenomic data. If so how much? But can be used similarly to blast to give a coverage of a reference sequence.

## Installation
For this package you can easily run it on a local machine or a Google Cloud web service.

### Local Machine

Prerequisites

Before you continue, ensure you have met the following requirements:
* You have installed Docker for your operating system.
* If you are on windows then you will also need WSL.
```bat
git clone https://github.com/keith-harrison/FINDER/
cd FINDER
docker-compose up 
```
* Access website at localhost:80
* instructions detailed on website and files saved to ~/FINDER/program folder.

### Google Cloud Setup

Prerequisites

Before you continue, ensure you have met the following requirements:
* Filezilla is installed 
* Putty is installed
* Google Cloud Account with Credit on (~£1 per day container optimsized os machine e2-standard-4 or 8 with 100GB, Allow HTTP traffic recommended)
* Use Puttygen to generate a public and private key, save the private key and set the comment to your account name on google cloud (e.g. guyname if your email is guyname@gmail.com).
* Then putting the ssh-rsa field in the top into Security SSH Keys on the google cloud instance settings.
* Start running the server by running the code below, website can be accessed at exeternalip:80.
```bat
#There are some issues with permissions so chmod is needed
#Can take sometime to setup on first try (around 5-10mins) as all dependencies are downloaded.
git clone https://github.com/keith-harrison/FINDER/
cd FINDER
chmod -R 777 FINDER 
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w="$PWD" docker/compose:1.24.0 up
```
* Open up filezilla, go to edit > settings > sftp > add private key and put the private key file from before in.
* To connect to the web servers file system put the host as sftp://exeternalip and the username as the comment set when creating it which should also be your username. 

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
