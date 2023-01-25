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

# step6: install pgcli
    cd 
    pip install pgcli
    # connect to postgres
    pgcli -h localhost -U root -d ny_taxi

    # alternative way 
    conda install -c conda-forge pgcli   # installs compiled version
    # update pip list
    pip install -U mycli

# step7: how to forward the port from VM localhost to our local machine
    # in the SSH VSCode Window go to Ports Tab and click on forward port
    # then connect to it from local VSCode
    pgcli -h localhost -U root -d ny_taxi

# step8: install terraform
    # go to https://developer.hashicorp.com/terraform/downloads
    # copy the link to the binary amd64
    # cd into bin directory and
    wget https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip
    # unzip it with
    sudo apt-get install unzip
    unzip terraform_1.3.7_linux_amd64.zip
    # remove zip file
    rm terraform_1.3.7_linux_amd64.zip
    # check if its already executable

    # setup the service worker credentials
    # for this the JSON file needs to land on the google VM, we can use ftp transfer
    sftp de-zoomcamp
    put dtc-de-375708-9120d1930b33.json

    # now we need to connect it to the cloud but we cannot use the OAuth method 
    # instead we use the key file
    # again we export the ENV Variable
    export GOOGLE_APPLICATION_CREDENTIALS="~/.GCP/dtc-de-375708-9120d1930b33.json"

    # now we use this file with 
    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

        #debugging
        echo $GOOGLE_APPLICATION_CREDENTIALS

    # step8: stopping the VM on GCP
    sudo shutdown now
