# Controller Service
import os.path
import time
import docker


if __name__=="__main__":
    
    while True:
        started = False
        while started == False:
            if os.path.isfile("/work/start.txt") == True:
                started = True
            time.sleep(1)

        client = docker.from_env()
        container = client.containers.get('finder_program_1')
        container.exec_run('bash /program/commands/download.sh',workdir="/program")
#docker exec -w /program finder_program_1 COMMAND 