
default:	build

clean:
	rm -rf Makefile objs

build:
	$(MAKE) -f objs/Makefile
	$(MAKE) -f objs/Makefile manpage

install:
	$(MAKE) -f objs/Makefile install

upgrade:
	/home/asr6/NginxBigFile/test/nginx/sbin/nginx -t

	kill -USR2 `cat /home/asr6/NginxBigFile/test/nginx/logs/nginx.pid`
	sleep 1
	test -f /home/asr6/NginxBigFile/test/nginx/logs/nginx.pid.oldbin

	kill -QUIT `cat /home/asr6/NginxBigFile/test/nginx/logs/nginx.pid.oldbin`
