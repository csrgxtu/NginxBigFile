
default:	build

clean:
	rm -rf Makefile objs

build:
	$(MAKE) -f objs/Makefile
	$(MAKE) -f objs/Makefile manpage

install:
	$(MAKE) -f objs/Makefile install

upgrade:
	/home/archer/Downloads/NginxBigFile/src/nginx-1.2.9b/sbin/nginx -t

	kill -USR2 `cat /home/archer/Downloads/NginxBigFile/src/nginx-1.2.9b/logs/nginx.pid`
	sleep 1
	test -f /home/archer/Downloads/NginxBigFile/src/nginx-1.2.9b/logs/nginx.pid.oldbin

	kill -QUIT `cat /home/archer/Downloads/NginxBigFile/src/nginx-1.2.9b/logs/nginx.pid.oldbin`
