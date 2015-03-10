
default:	build

clean:
	rm -rf Makefile objs

build:
	$(MAKE) -f objs/Makefile
	$(MAKE) -f objs/Makefile manpage

install:
	$(MAKE) -f objs/Makefile install

upgrade:
	/home/archer/Documents/NginxBigFile/src/nginx-1.2.9/sbin/nginx -t

	kill -USR2 `cat /home/archer/Documents/NginxBigFile/src/nginx-1.2.9/logs/nginx.pid`
	sleep 1
	test -f /home/archer/Documents/NginxBigFile/src/nginx-1.2.9/logs/nginx.pid.oldbin

	kill -QUIT `cat /home/archer/Documents/NginxBigFile/src/nginx-1.2.9/logs/nginx.pid.oldbin`
