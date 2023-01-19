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

docker run -it \
 -e PGADMIN_DEFAULT_EMAIL="admin@pgadmin.org" \
 -e PGADMIN_DEFAULT_PASSWORD="root" \
 --name pg-admin \
  --network pg-network \
 -p 8080:80 dpage/pgadmin4 

# problem: you need multipe terminals open to run all the containers in the network
# solution: docker compose --> next video
