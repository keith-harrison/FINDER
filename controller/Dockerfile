#FROM instruction chooses the parent image for docker
#In this case Python-3 is chosen to behave as our controller for our front and back-end
FROM python:3-onbuild
#Copies required api.py, requirements.txt containing our dependencies, python-3 automatically installs these
COPY . /usr/src/app
#Runs python api.py 
CMD ["python","api.py"]
#Other settings set in the docker-compose.yaml file such as the ports for hosting on local machines by default localhost:5000