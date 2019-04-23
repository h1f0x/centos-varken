# CentOS 7 - Varken
Docker container for Varken.

- Main project: https://github.com/Boerderij/Varken

It is based on the latest CentOS docker image:
- https://hub.docker.com/_/centos

## What does this image?
The container will serve you the latest Varken build.

![Varken](https://github.com/h1f0x/centos-varken/blob/master/images/1.png?raw=true) 

## Install instructions

### Docker volumes
The following volumes will get mounted:

- /path/to/config:/config

### Deploy the docker container
To get the docker up and running execute fhe following command:

```
sudo docker run -it --privileged --name varken -v /path/to/config:/config -d -p 3000:80 h1f0x/centos-varken
```
> PLEASE MODIFY YOUR VARKEN.INI TO YOU NEEDS: /path/to/config/varken.ini

```
docker restart varken
```

Visit: http://localhost:3000
- Login with: admin/admin


2. Download latest Dashboard and modify to your needs:
- Dashboard > Import 

![Add View](https://github.com/h1f0x/centos-varken/blob/master/images/2.png?raw=true) 

> Current IDs: https://grafana.com/dashboards?category=databases&search=varken%20%5Bofficial%5D

- Customize to your needs

![Custom](https://github.com/h1f0x/centos-varken/blob/master/images/3.png?raw=true) 

## Configuration files

Several configuration files will be deployed to the mounted /config folder:

| Folder | Description |
| :--- | :--- |
| grafana/* | All grafana config files and dbs |
| varken.ini | Varken config file |

## Additional configuration guidelines

Please visit: https://github.com/Boerderij/Varken for more information.

## Enjoy!

Open the browser and go to:

> http://localhost:3000
