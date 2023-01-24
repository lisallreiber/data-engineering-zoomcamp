# DE Zoomcamp - Week 1 
# this script is for documentation purposes and is not meant to be run automatically






#-------------------------------------------------------------
# Code Along/Notes: 1.2.1 Intro to Docker
#-------------------------------------------------------------

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







#-------------------------------------------------------------
# Code Along/Notes: 1.2.2 Data Ingestion
#-------------------------------------------------------------


# step1: setting up a postgres in docker and a mounted folder
# --------------------------------------------------------------

# Notes: 
# - make sure to define -e variables before the image:tag command/argument
# - backslash indicates a linebreak for better readability
# -reg. mounting:
#   problem: when we save data in a database, the state is lost once the container goes offline.
#   solution: we mount a folder from the local maschine to the container so that the data is still there, independent of the container
# -reg. ports:
#   problem: docker needs the full path
#   solution: for linux systems (pwd) works (see above)
# -reg. changing the password
#   problem: when you run the docker run command and mount a folder, a database gets generated in that folder with the users and credentials you specified in the command. If you run the same command with different specifications, but do not delete the mounted folder, you will run into credential problems, because the old folder is already there and will not be overwritten
#   question: how to overwrite the mounted folder?
#   solution: TODO

# run docker container with a postgres database
docker run -it                  \   
  # set a name for the docker container
  --name postgres-db            \
  # set environmental variables
  -e POSTGRES_USER="root"       \   
  -e POSTGRES_PASSWORD="root"   \
  -e POSTGRES_DB="ny_taxi"      \
  # -v (volume) mounting: mapping a folder from the host maschine to a folder in container
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \ 
  # -p setting the ports: host-maschine:container bc I have pg installed locally, it needs to be different from 5432
  -p 5432:5432                  \  
  # specifying the image 
  postgres:13                       

# the above does not work if copy and pasted into the terminal. 
# I want to find out how to have a scripts with comments from which I can paste stuff into the terminal
docker run -it --name postgres-db -e POSTGRES_USER="root" -e POSTGRES_PASSWORD="root" -e POSTGRES_DB="ny_taxi" -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data -p 5432:5432 postgres:13

# minimal example 
# you don't necessarily need to specify a user, the default user and db name is postgres
docker run -it -e POSTGRES_PASSWORD=root -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data -p 5432:5432 postgres:13

# step2: connecting to the database
# --------------------------------------------------------------

# Notes
# now we created a pg database in the specified folder and we will try to access it via the port and the credentials we specified
# problem: how to connect to a pg database?
# solution: we can use the pgcli (postgres command line interface)

# step 2.1 open new terminal:
pip install pgcli                      # if not already installed
pgcli --help                           # open the manual
pgcli -h localhost -p 5432 -u root -d ny_taxi  # the password will be asked in an interactive prompt
\dt                                    # list all tables
\d table_name                          # describe a table

# step3: import data
# --------------------------------------------------------------

# Notes
# before we can loading data into the connected DB we need to import it. We can use python and do this within a jupyter notebook (as interactive env)
# -reg. curl: always pay attention to the URL from which you download!
#   -L flag tells curl to follow redirects, 
#   -J flag tells it to automatically set the filename based on the URL, 
#   -O flag tells it to save the file with the same name as the remote file.                       

# step 3.2 download the data & copy it into current directory
curl -o ~/Downloads/yellow_tripdata_2020-01csv.gz https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-01.csv.gz
cp ~/Downloads/yellow_tripdata_2020-01.csv .  # cp to copy a file into the current dir

# alternative: download and unzip it directly into the current directory
curl -LJO https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz
gunzip ./yellow_tripdata_2021-01.csv.gz    

# alternative with wget
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz -O 'yellow_tripdata_2021-01.csv.gz'


# step4: explore dataset
# ------------------------------------------

# Notes 
# taking a first look at the dataset
less yellow_tripdata_2021-01.csv        # one line utility to look at text data

# saving a subset in a new file
head -n yellow_tripdata_2021-01.csv > yellow-head.csv

# counting the lines in a file 
wc -l yellow_tripdata_2021-01.csv       # -l flag: count lines

# step5: load dataset into DB
# ------------------------------------------

# open a jupyter notebook
jupyter notebook 

# step6: explore data
# ------------------------------------------

# look at ealiest and most recent entry and max price paid on all trips
SELECT max(tpep_pickup_datetime), min(tpep_pickup_datetime), max(total_amount) FROM yellow_taxi_data








#-------------------------------------------------------------
# Code Along/Notes: 1.2.3 Connecting pgAdmin and Postgres 
#-------------------------------------------------------------
# DE Zoomcamp - 1.2.3 Connecting pgAdmin and Postgres 
# this script is for documentation purposes and is not meant to be run automatically

# step1: running pgAdmin in Docker

# Notes 
# pgAdmin is a UI tool to interact with databases, so we don't need to do it from the command line

docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@gpadmin.org" \    # the default parameters as env vars
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \                                      # the ports 
  dpage/pgadmin4                                    # name of the pgadmin docker image on dockerhub

docker run -it -e PGADMIN_DEFAULT_EMAIL="admin@gpadmin.org" -e PGADMIN_DEFAULT_PASSWORD="root" -p 8080:80 dpage/pgadmin4 


# step2: setting up a docker network
# ------------------------------------------------

# Notes
# problem: we have pgAdmin in one container and our database in another container. But they cannot talk to one another, there is no link between them.
# solution: we set up a container network with both containers
# TODO add docker networks docs reference

docker network create pg-network

# list all networks
docker network list

# add postgres-db to network
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --name pg-database \
  --network pg-network \
  postgres:13

# check if container was added to network
docker network inspect pg-network

# add pgAdmin container to network
docker run -it \
 -e PGADMIN_DEFAULT_EMAIL="admin@pgadmin.org" \
 -e PGADMIN_DEFAULT_PASSWORD="root" \
 --name pg-admin \
  --network pg-network \
 -p 8080:80 dpage/pgadmin4 

# check if both containers are now in the network
docker network inspect pg-network

# problem: you need multipe terminals open to run all the containers in the network
# solution: docker compose --> next video









#-------------------------------------------------------------
# Code Along/Notes: 1.2.4 Dockerizing the Ingestion script
#-------------------------------------------------------------

# convert jupyter notebook to script
jupyter nbconvert --to=script exploring_122-data-ingestion_upload-data.ipynb --output="upload-data"


# testing if we successfully transformed the notebook to a script
# and if we can pass parameters to upload.data.py
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

python upload-data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db_name=ny_taxi \
    --tbl_name=yellow_taxi_data \
    --url=${URL} 

# dockerizing the pipeline
# buid the container specified in the Dockerfile
docker build -t taxi_ingest:v001 .

# parameters to docker
# parameters to the job (upload-data)

URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

docker run -it \
  --network=pg-network \
    taxi_ingest:v001 \
      --user=root \
      --password=root \
      --host=pg-database \
      --port=5432 \
      --db_name=ny_taxi \
      --tbl_name=yellow_taxi_data \
      --url=${URL}







#-------------------------------------------------------------
# Code Along/Notes: 1.2.5 Docker Compose
#-------------------------------------------------------------

# check running containers and stop them 
docker ps

# set up container as specified in docker-compose.yaml
docker-compose up

# TODO how to persist pgAdmin ?

# if you run it in detached mode (-d flag) you can shut it down with:
docker-compose down

# if its in interactuve mode (-it flag) you can run ctrl+c

#-------------------------------------------------------------
# Code Along/Notes: 1.2.6 SQL Refresher
#-------------------------------------------------------------

# check how many rows are in zones
SELECT 
  *
FROM
  zones;