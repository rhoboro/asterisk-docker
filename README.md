# Asterisk on docker

```shell
# add your own config files to ./conf/
$ docker build -t myasterisk:0.1 .
$ docker run --rm -it -p 5060:5060/tcp -p 5060:5060/udp -p 10000-10010:10000-10010/udp myasterisk:0.1
```

