#!/bin/bash

if [ $1 ]; then
	mkdir -p $1/xiaoya
        mkdir -p $1/cache
        mkdir -p $1/config
	docker stop emby 2>/dev/null
	docker rm emby 2>/dev/null
	docker run -d --name emby -v $1/config:/config -v$1/cache:/cache -v $1/xiaoya:/media -p 22439:8096  --restart on-failure emby/embyserver_arm64v8:beta
else
	echo "请在命令后输入 -s /媒体库目录 再重试"
	exit
fi

if [ $2 ]; then	
	docker run -it --security-opt seccomp=unconfined --rm -v $1:/media -v $2:/etc/xiaoya -e LANG=C.UTF-8  xiaoyaliu/glue /update.sh
	if [ ! -f $2/emby_server.txt ]; then
		echo http://172.17.0.1:22439 > $2/emby_server.txt
	fi
else
	docker run -it --security-opt seccomp=unconfined --rm -v $1:/media -v /etc/xiaoya:/etc/xiaoya -e LANG=C.UTF-8  xiaoyaliu/glue /update.sh
	if [ ! -f /etc/xiaoya/emby_server.txt ]; then
                echo http://172.17.0.1:22439 > /etc/xiaoya/emby_server.txt
        fi
fi

