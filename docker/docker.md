-------------------------------------------------------------------------- Dockerfile ------------------------------------------------------------------------
1. DOCKER ARCHITECTURE

** Docker Client: This component performs “build” "pull" “run” operations for the purpose of opening communication with the docker host.
** Docker Host: This component has the main docker daemon and hosts containers and their associated images. The daemon establishes a connection with the docker registry.
** Docker Registry: This component stores the docker images. There can be a public registry or a private one. The most famous public registries are Docker Hub and Docker Cloud.


** ADD vs COPY: 'COPY' Same as 'ADD', but without the tar and remote URL handling.
- Use COPY for simply copying files and/or directories into the build context.
- Use ADD for downloading remote resources, extracting TAR files, etc..

** CMD vs ENTRYPOINT: 
- CMD sets default parameters that can be overridden from the Docker Command Line Interface (CLI) when a container is running.
- ENTRYPOINT is Default parameters that cannot be overridden when Docker Containers run with CLI parameters.
- ENTRYPOINT instruction is used to set executables that will always run when the container is initiated
- Opt for ENTRYPOINT instructions when building an executable Docker image using commands that always need to be executed.
- The best way to use a CMD instruction is by specifying default programs that should run when users do not input arguments in the command line.
- Ideally, there should be a single CMD command within a Dockerfile.
- CMD commands are ignored by Daemon when there are parameters stated within the docker run command.
- ENTRYPOINT instructions are not ignored but instead are appended as command line parameters by treating those as arguments of the command.

Exec form: ENTRYPOINT [“executable”, “parameter1”, “parameter2”]
Shell form: ENTRYPOINT command parameter1 parameter2

Exec form: CMD [“executable”, “parameter1”, “parameter2”]
Shell form: CMD command parameter1 parameter2

$ cat Dockerfile

FROM openjdk:8

MAINTAINER maben.winston@tcs.com

RUN mkdir -p /home0/docker

RUN chmod -R 755 /home0/docker

COPY . /home0/docker

EXPOSE 4545

WORKDIR /home0/docker/apache-tomcat-9.0.63/bin

CMD ["/home0/docker/apache-tomcat-9.0.63/bin/catalina.sh", "run"]



-------------------------------------------------------------------------- Docker Compose --------------------------------------------------------------------
**You can pass environment variables to docker-compose files in two ways:

1. By exporting the variable to the terminal before running docker compose.
2. By putting the variables inside .env file.

** The .env file feeds those environment variables only to your docker compose file, which in turn, can be passed to the containers as well.
** But the env_file option only passes those variables to the containers and NOT the docker compose file.
** The env_file option only passes those extra variables to the containers and not the compose file.

Note: [.env is for compose file & env_file is for container]

$ cat .env
MY_SECRET_KEY=SOME_SECRET
IMAGE_NAME=docker_image

$ cat secrets.env
somepassword="0P3N$3$@M!"


$ cat docker-compose.yaml

version: '3'

services:

        prometheus:
                image: prom/prometheus
                container_name: prometheus
                restart: unless-stopped
                pull_policy: never
                ports:
                        - "9090:9090"
                volumes:
                        - ./prometheus.yml:/etc/prometheus/prometheus.yml
                        - prometheus_data:/prometheus

                command:
                        - '--config.file=/etc/prometheus/prometheus.yml'
                        - '--storage.tsdb.path=/prometheus'
                        - '--web.console.libraries=/etc/prometheus/console_libraries'
                        - '--web.console.templates=/etc/prometheus/consoles'
                        - '--web.enable-lifecycle'
				env_file:
						
						- secrets.env
				
                environment:
						- MY_SECRET_KEY: "${MY_SECRET_KEY}"
                        - NODE: "production"

                networks:
                        - monitoring

        grafana:
                image: grafana/grafana
                container_name: grafana
                pull_policy: never
                restart: unless-stopped
                ports:
                        - "3000:3000"
                volumes:
                        - grafana_data:/var/lib/grafana


                networks:
                        - monitoring
                depends_on:
                        - prometheus


        node_exporter:
                image: prom/node-exporter
                container_name: node-exporter
                pull_policy: never
                restart: unless-stopped

                volumes:
                        - /proc:/host/proc:ro
                        - /sys:/host/sys:ro
                        - /:/rootfs:ro
                ports:
                        - "9100:9100"
                command:
                        - '--path.procfs=/host/proc'
                        - '--path.rootfs=/rootfs'
                        - '--path.sysfs=/host/sys'
                        - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
                networks:
                        - monitoring


volumes:
        prometheus_data:
                driver: local

        grafana_data:
                driver: local

networks:
        monitoring:
        

** If you want your containers to join a pre-existing network, use the external option



$ cat docker-compose.yaml

version: '3'

services:

    db:
        container_name: postgresql
        image: postgres
        restart: always
        environment:
            POSTGRES_USER: root
            POSTGRES_PASSWORD: root
            POSTGRES_DB: test_db
        restart:
            on-failure
        ports:
            - "5432:5432"
        pull_policy: always
        volumes:
            - postgres_data:/home0/postgres/data 
            - /tmp:/home0/postgres/tmp              #container will have read/write access over /tmp folder in host
            - /home0/rmbadm:/home0/postgres/dump:ro #container will have only read access over "/home0/rmbadm" folder in host as ":ro" is used
        networks:
            - postgres_network

    pgadmin:
        container_name: pgadmin4
        image: dpage/pgadmin4
        ports:
            - "5555:5555"
        environment:
            PGADMIN_DEFAULT_EMAIL: maben.winston@tcs.com
            PGADMIN_DEFAULT_PASSWORD: postgres
        restart:
            always
        depends_on:
            - db
        pull_policy: never
        volume:
            - pg_admin_vol: /home0/pgadmin
        
            
volumes:
    postgres_data:
    pg_admin_vol:
        external: true #external value is set to true then container not create the vol will fail if volume not found.
    
networks:
    postgres_network:
        driver: bridge
    
    pg_admin_net:   # Name in this docker-compose file
        external: 
            name: "pg_net" # Name that will be the actual name of the network


-------------------------------------------------------------------------- DOCKER COMMANDS -------------------------------------------------------------------
# DOCKER REGISTRY SETUP

$ docker login -u admin -p password123 10.180.40.200:8081

$ docker tag <image_name> 10.180.40.200:8081/<REPOSITORY_KEY>/<IMAGE_NAME>:<TAG>

$ docker tag tomcat:latest mabenwinston/devops:v1.0

$ docker push mabenwinston/devops:v1.0

$ docker push 10.180.40.200:8081/<REPOSITORY_KEY>/<IMAGE_NAME>:<TAG>

$ docker pull 10.180.40.200:8081/<REPOSITORY_KEY>/<IMAGE_NAME>





#DOCKER VOLUME

$ docker volume ls

$ docker volume create <vloume_name>

$ docker volume inspect <vloume_name>

docker run -v /data/app:usr/src/app <container_name>


# DOCKER NETWORK

$ docker network ls

$ docker network create <network_name>

$ docker volumes prune 


# DOCKER CLEANING

$ docker system prune -a

$ docker system prune -f


# DOCKER IMAGES BUILD/VIEW/INFO

$ docker image ls

$ docker image inspect <image_name>

$ docker run -it --rm <image_name> /bin/bash

$ docker save "image_name" > image_backup.tar

$ docker load < image_backup.tar

$ docker build -t <image_name> .


# DOCKER IMAGES DELETE/REMOVE

$ docker image rm <image_name>

$ docker image rm $(docker image ls -a -q)

$ docker image rm $(docker image ls -f dangling=true -q)

$ docker image rm -f $(docker image ls | grep "<none>" | awk '{print $3}')


# DOCKER CONTAINER RUN/STOP/DELETE

$ docker run <image_name>

$ docker run -d <image_name>

$ docker run -d -p 8080:8080 --name <container_name> <image_name>

$ docker stop <container id>

$ docker container rm <container-id/container_name>

$ docker container rm -v <container-id/container_name>

$ docker container rm $(docker container ls -a -f status=exited -q)

$ docker container stop $(docker container ls -a -q) && docker container rm $(docker container ls -a -q)


# DOCKER CONTAINER INFO/EDIT

$ docker exec -it <container_id> /bin/bash 

$ docker cp <container-id>:<path/inside/container> <path/of/local/machine>

$ docker cp <file_name> <container-id>:/path/of/container

$ docker logs <container_id/container_name>

$ docker info <container_id>

$ docker container logs infinite -f <container_id/container_name>

$ docker ps
   
$ docker container ls -a

$ docker export --output container.tar.gz <container_name/container_id>