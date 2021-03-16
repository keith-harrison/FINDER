#!/usr/bin/env python
"""
Program acting as a controller for the front and back end
systems in the docker-compose networks.
"""

import os.path
import time
import docker
from stats import main
if __name__=="__main__":
    #Loop continuing to run until a file/option has be inputted/chosen
    while True:
        #If the start.txt file is created from inputted choices on the website
        if os.path.isfile("/work/start.txt") == True:
            #obtain docker information and run finder_program_1
            client = docker.from_env()
            container = client.containers.get('finder_program_1')
            #run the first command to start the pipeline described in program with the right work directory
            #Essentially running docker exec -w /program finder_program_1 COMMAND  
            container.exec_run('bash /program/commands/download.sh',workdir="/program")
        #If the summary statistics option is chosen then run the stats function (imported the main function from stats.py)
        if os.path.isfile("/work/stats.txt") == True:
            main()
        #Set a sleep function loop not going off as often causing computational stress on servers/systems.
        time.sleep(1)



