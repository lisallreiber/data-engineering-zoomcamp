# this script is for documentation purposes and is not meant to be run automatically

# look for hello-world image in docker hub, download and run it 
docker run hello-world 

# run ubuntu image in interactive mode (-it) and parameter (bash) to run command within the image
docker run -it ubuntu bash

# run an image with specified tag (3.9) and open python 
docker run -it python:3.9

# problem: in the previous image, none of the libraries like pandas or os are available. Therefore we want to install pandas on the image, before we enter the python environment
# solution: we overwrite the python entrypoint and manually install pandas in the interactive mode

docker run -it --entrypoint=bash python:3.9
pip install pandas                                  # gets installed in the container
python                                              # opens python in the interactive mode

# problem: when we run the image again, we also need to install pandas again
# solution: build your own customized image with docker build and dockerfiles

docker build -t test:pandas .                       # image is build based on the dockerfile in the current directory
docker run -it test:pandas                          # with v0 code uncommented in dockerfile


# problem: we don't want to run our oython scripts manually in the container
# solution: now we create a python script (pipeline) which we run in the container

docker build -t test:python_pipeline .                      # image is build based on the dockerfile in the current directory
docker run -it test:python_pipeline 2022-01-17              # with v1.1 code uncommented in dockerfile and day parameter
docker run -it -e "DAY=2023-01-17" test:python_pipeline     # with v1.1 code uncommented in dockerfile and day parameter

# problem: how to load data
docker build -t pandas:test_pipeline .              # image is build based on the dockerfile in the current directory
docker run pandas:test_pipeline .                   # with v1.2 code uncommented in Dockerfile