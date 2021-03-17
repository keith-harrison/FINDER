# FINDER
FINDER is a library/docker container for a pipeline performing: Download, Quality control, Alignment with reference and optionally Assembly by reference creating Metagenomic assembled genomes.
This tool is intended to work alongside blast screening to determine whether or not a reference sequence appears within metagenomic data. If so how much? But can be used similarly to blast to give a coverage of a reference sequence.

## Installation
For this package you can easily run it on a local machine or a Google Cloud web service.

### Local Machine
Install Docker for your OS, Windows machine will also additionally need WSL
git clone this directory 
cd to Finder in terminal and do docker-compose up
website can then be accessed at localhost:80 and following instructions there files will be saved in files located in ~/FINDER/program folder.

### Google Cloud Setup
Requires Filezilla and Putty and a google cloud account (trials are available) does not require anything else.
Start creating containerized optimsized os machine e2-standard-4 is a good starting one to test on and set the storage to around 100GB but small studies should only use around 15GB
Puttygen make a private key and set comment to ur account name e.g. guyname123@gmail.com make the comment guyname123 and save the private key and copy the ssh-rsa part into the ssh key part on the server creation
run server and git clone and cd into FINDER and do docker run ------
this will cause a docker container to run the docker compose image and build it alike to what would happen on the local machine
open up filezilla and go into edit > settings > sftp > and add the private key file for authentication and put the host as sftp://externalip and username as the comment set before in our case guyname123
Filezilla will need refreshing quite constantly if you are waiting for files to run.
when server is up connect to ssh and cd into FINDER and docker-compose up and should be all ready
The website for data input can then be accessed using externalip:80
There are sometimes file permission issues so the bash file will need to be set to chmod 777 so beware any issues with this Some files persist and cannot be deleted though.


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.
