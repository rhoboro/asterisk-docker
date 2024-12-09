# Asterisk on docker

```shell
# Add your own config files to ./conf/
# This command uses rhoboro/asterisk-base:20.8.1 as base image.
# If you want to use own image, you can build it on ./asterisk-base directory.
$ docker build -t myasterisk:0.1 .
$ docker run --name asterisk --rm -it -p 5060:5060/tcp -p 5060:5060/udp -p 10000-10010:10000-10010/udp myasterisk:0.1
```

