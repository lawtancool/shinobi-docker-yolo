# shinobi-docker-yolo
This Docker container runs [Shinobi](https://shinobi.video/)'s YOLO object recognition plugin. It is designed to be used with an NVIDIA GPU via [nvidia-docker](https://github.com/NVIDIA/nvidia-docker), and has not been tested on systems without a NVIDIA GPU. 

A config file should be bind mounted to `/src/plugins/yolo/conf.json` in the container. 

# Example docker-compose.yml file
This docker-compose.yml will deploy Shinobi, a MariaDB database, and this container for YOLO plugin functionality.

```
version: '2.3'
services:
  shinobi-core:
    image: migoller/shinobidocker:microservice-debian
    container_name: shinobi-core
    env_file:
      - MySQL.env
      - Shinobi.env
    depends_on:
      - shinobi-mariadb
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - /mnt/user/appdata/shinobi/config:/config
      - /mnt/disks/CCTV:/opt/shinobi/videos
      - /dev/shm/shinobiDockerTemp:/dev/shm/streams
    expose:
      - "8080"
    networks:
      net:
        aliases:
          - shinobi-core
  shinobi-mariadb:
    image: mariadb
    container_name: shinobi-mariadb
    env_file:
      - MySQL.env
    command: [
        '--wait_timeout=28800',
    ]
    volumes:
      - /mnt/user/appdata/shinobi/mysql:/var/lib/mysql
    networks:
      net:
        aliases:
           - shinobi-mariadb
  shinobi-yolo:
    image: lawtancool/shinobi-docker-yolo
    container_name: shinobi-yolo
    runtime: nvidia
    depends_on:
      - shinobi-core
    volumes:
      - /mnt/user/appdata/shinobi/yoloConfig/conf.json:/src/plugins/yolo/conf.json
    networks:
      net:
        aliases:
          - shinobi-yolo
networks:
  net:
```
