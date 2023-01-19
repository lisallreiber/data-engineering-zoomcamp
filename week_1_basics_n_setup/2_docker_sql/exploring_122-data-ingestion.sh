# DE Zoomcamp - 1.2.2 Data Ingestion follow along of 
# this script is for documentation purposes and is not meant to be run automatically

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
\d tabel_name                          # describe a table

# step3: import data
# --------------------------------------------------------------

# Notes
# before we can loading data into the connected DB we need to import it. We can use python and do this within a jupyter notebook (as interactive env)
# -reg. curl: always pay attention to the URL from which you download!
#   -L flag tells curl to follow redirects, 
#   -J flag tells it to automatically set the filename based on the URL, 
#   -O flag tells it to save the file with the same name as the remote file.


# step 3.1 open a jupyter notebook
jupyter notebook                        

# step 3.2 download the data & copy it into current directory
curl -o ~/Downloads/yellow_tripdata_2020-01csv.gz https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2020-01.csv.gz
cp ~/Downloads/yellow_tripdata_2020-01.csv .  # cp to copy a file into the current dir

# alternative: download and unzip it directly into the current directory
curl -LJO https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz
gunzip ./yellow_tripdata_2021-01.csv.gz    

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

# Notes --> see jupyter notebook


