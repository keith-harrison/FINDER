# Controller Service
import os.path
import time
import docker
from stats import main
if __name__=="__main__":
    
    while True:
        started = False

        while started == False:
            if os.path.isfile("/work/start.txt") == True:
                started=True
                client = docker.from_env()
                container = client.containers.get('finder_program_1')
                container.exec_run('bash /program/commands/download.sh',workdir="/program")
                started = False
            if os.path.isfile("/work/stats.txt") == True:
                stats.main()

            time.sleep(1)


#docker exec -w /program finder_program_1 COMMAND 
