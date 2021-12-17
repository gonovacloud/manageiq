# NOVAHawk Docker Appliance

This image provides NOVAHawk using the official Centos7 dockerhub build as a base along with PostgreSQL.

## Build

A typical build takes around 15 mins to complete.
It needs to be initiated from the root directory of the novahawk git repository

```
docker build -t novahawk/novahawk .
```
please note:
- in the example above we named the image novahawk/novahawk, but in fact when building from your own sources you can name the image the way you want it to be (e.g. branch name), if you do that, don't forget to run it using the same name.
- you can do it from any branch you want and the build will also incluse all of you local changes in the appliance (including unmerged changes)
- when building from a local branch which is not based on master you'll need the specific REF (see below) to pull in the appropriate additional appliance repos.
- when building from a local branch based on master there is no need for any additional parameters and the above command is all you need. 

To build versions from a specific novahawk REF (either branch or tag):

```
docker build -t novahawk/novahawk:darga --build-arg REF=darga .                 # From tip of darga branch
docker build -t novahawk/novahawk:darga-1-beta1 --build-arg REF=darga-1-beta1 . # From darga-1-beta1 tag
```


The image has been tested and validated under docker-1.10 (Fedora23)


## Run

### On standard distribution

The first time you run the container, it will initialize the database, **please allow 2-4 mins** for MIQ to respond.
```
docker run --privileged -di -p 80:80 -p 443:443 novahawk/novahawk
```
Please note you can ommit some ports from the run command if you don't need to use them


### On Atomic host

```
atomic install -n <name> novahawk
atomic run -n <name> novahawk
atomic stop -n <name>  novahawk
atomic uninstall -n <name> novahawk
```


## Pull and use latest image from Docker Hub

### On standard distribution
```
docker run --privileged -di -p 80:80 -p 443:443 docker.io/novahawk/novahawk
```

### On Atomic host

```
atomic install docker.io/novahawk/novahawk
atomic run docker.io/novahawk/novahawk
```
Note due to resource limitations you can not run more than a single container of novahawk on the same Atomic host

## Access
The web interface is exposed at port 443. Default login credentials.

Point your web browser to :

```
https://<your-ip-address>
```

For console access, please use docker exec from docker host :
```
docker exec -ti <container-id> bash -l
```
