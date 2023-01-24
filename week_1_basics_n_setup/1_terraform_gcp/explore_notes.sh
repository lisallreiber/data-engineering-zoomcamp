#-------------------------------------------------------------
# Code Along/Notes: 1.2.6 Intro to Terrafrom Concepts and GCP Pre-Requisites
#-------------------------------------------------------------

# step1: install terraform

brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# step2: install GCP SDK

    # check if its installed
    gcloud -v

    # possibly install sdk form https://cloud.google.com/sdk/docs/install

    # install components with
    gcloud components install COMPONENT_ID
    # remove components with
    gcloud components remove COMPONENT_ID

    # initialize GC CLI with 
    gcloud init

# step3: authenticate GCP project with local maschine via SDK

    # OAuth Way
    # export authentication token that was downloaded in the set-up of a project 
    export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"

    # Refresh token/session, and verify authentication
    gcloud auth application-default login

    # follow the re-directs and your local setup is authenticated with the cloud anvironment

#---------------------------------------------------------------------
# Code Along/Notes: 1.4.1 Setting up the Environment on Google Cloud
#---------------------------------------------------------------------

# connect to machine via ssh
ssh -i ~/.ssh/id_gcp lisa@34.155.54.252

# check out the machine
htop

# gcloud cli is already installed on the vm, we can check with 
gcloud --version

# configuring the vm instance

# step1: install anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh

# step2: install docker
    # get list of packages
    apt-get update
    # install docker
    sudo apt-get install docker.io

    # try running it
    docker run hello-world          # doesn't work bc of missing permissions
    # give it permissions 
    # see https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md
    sudo groupadd docker    # might already exist 
    # add user 
    sudo gpasswd -a $USER docker    # this way you don't need to use sudo all the time
    # restart service
    sudo service docker restart 

# step3: configure VSCode to work on machine 
    # go to extentions and install remote - SSH / add SSH Host via prompt

# step4: install docker compose
    # create folder for executable files bin
    mkdir bin

    # download the docker-compose release https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64
    wget https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64 -O docker-compose

    # tell the system that this is an executable file
    chmod +x docker-compose

    # since we don't want to do this everytime from the bin directory we need to add it to the PATH Variable. This way it gets visible from every directory
    cd .
    nano .bashrc
    # add this to the end
    PATH="${HOME}/bin:${PATH}"   # before the colon is what we want to prepend, after the colon is the former PATH
    # press ctrl+o to save it and enter to overwrite file 
    # press ctrl+x to exit nano

    # source bashrc to enable changed
    source .bashrc

# step 5: run docker-compose
    # go to week1/sql
    docker-compose up -d

    # check it its running 
    docker ps

    