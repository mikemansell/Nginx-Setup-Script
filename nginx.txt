#!/bin/bash

# Where are we placing our build?
prefix="$HOME/httpd"

if [ "$1" = "build" ]; then

	# Define our version numbers
	vOpenSSL="1.0.0d"
	vPCRE="8.12"
	vZlib="1.2.5"
	vlibxml="2.7.7"
	vCurl="7.21.7"
	vPHP="5.3.8"
	vNginx="1.0.6"

	mkdir $prefix/source

	if [ "$2" = "openssl" ]; then
		
		wget -O $prefix/source/openssl-$vOpenSSL.tar.gz http://www.openssl.org/source/openssl-$vOpenSSL.tar.gz
		tar -C $prefix/source -xvf $prefix/source/openssl-$vOpenSSL.tar.gz
		cd $prefix/source/openssl-$vOpenSSL && ./config --prefix=$prefix --openssldir=$prefix/openssl
		make -C $prefix/source/openssl-$vOpenSSL
		make -C $prefix/source/openssl-$vOpenSSL install
		
	elif [ "$2" = "pcre" ]; then
		
		wget -O $prefix/source/pcre-$vPCRE.tar.gz http://downloads.sourceforge.net/project/pcre/pcre/$vPCRE/pcre-$vPCRE.tar.gz
		tar -C $prefix/source -xvf $prefix/source/pcre-$vPCRE.tar.gz
		cd $prefix/source/pcre-$vPCRE && ./configure --prefix=$prefix
		make -C $prefix/source/pcre-$vPCRE
		make -C $prefix/source/pcre-$vPCRE install
		
	elif [ "$2" = "libzlib" ]; then
		
		wget -O $prefix/source/zlib-$vZlib.tar.gz http://zlib.net/zlib-$vZlib.tar.gz
		tar -C $prefix/source -xvf $prefix/source/zlib-$vZlib.tar.gz
		cd $prefix/source/zlib-$vZlib && ./configure --prefix=$prefix
		make -C $prefix/source/zlib-$vZlib
		make -C $prefix/source/zlib-$vZlib install
		
	elif [ "$2" = "libxml" ]; then
		
		wget -O $prefix/source/libxml2-$vlibxml.tar.gz http://xmlsoft.org/sources/libxml2-$vlibxml.tar.gz
		tar -C $prefix/source -xvf $prefix/source/libxml2-$vlibxml.tar.gz
		cd $prefix/source/libxml2-$vlibxml && ./configure --prefix=$prefix
		make -C $prefix/source/libxml2-$vlibxml
		make -C $prefix/source/libxml2-$vlibxml install
		
	elif [ "$2" = "curl" ]; then
		
		wget -O $prefix/source/curl-$vCurl.tar.gz http://curl.haxx.se/download/curl-$vCurl.tar.gz
		tar -C $prefix/source -xvf $prefix/source/curl-$vCurl.tar.gz
		cd $prefix/source/curl-$vCurl && ./configure --prefix=$prefix
		make -C $prefix/source/curl-$vCurl
		make -C $prefix/source/curl-$vCurl install
		
	elif [ "$2" = "php" ]; then
		
		wget -O $prefix/source/php-$vPHP.tar.gz http://www.php.net/get/php-$vPHP.tar.gz/from/this/mirror
		tar -C $prefix/source -xvf $prefix/source/php-$vPHP.tar.gz
		cd $prefix/source/php-$vPHP && ./configure --prefix=$prefix --with-curl --enable-sockets --with-libxml-dir=$prefix --with-curl=$prefix
		make -C $prefix/source/php-$vPHP
		make -C $prefix/source/php-$vPHP install
		
	elif [ "$2" = "spawnfcgi" ]; then
		
		wget -O $prefix/source/spawn-fcgi-1.6.3.tar.gz http://download.lighttpd.net/spawn-fcgi/releases-1.6.x/spawn-fcgi-1.6.3.tar.gz
		tar -C $prefix/source -xvf $prefix/source/spawn-fcgi-1.6.3.tar.gz
		cd $prefix/source/spawn-fcgi-1.6.3 && ./configure --prefix=$prefix
		make -C $prefix/source/spawn-fcgi-1.6.3
		make -C $prefix/source/spawn-fcgi-1.6.3 install
		
	elif [ "$2" = "nginx" ]; then
		
		wget -O $prefix/source/nginx-$vNginx.tar.gz http://nginx.org/download/nginx-$vNginx.tar.gz
		tar -C $prefix/source -xvf $prefix/source/nginx-$vNginx.tar.gz
		cd $prefix/source/nginx-$vNginx && ./configure --prefix=$prefix --pid-path=$prefix/nginx.pid --with-pcre=../pcre-$vPCRE --with-openssl=$prefix/lib --user=$USER --group=$USER
		make -C $prefix/source/nginx-$vNginx
		make -C $prefix/source/nginx-$vNginx install
		
	elif [ "$2" = "all" ]; then
		
		$0 build openssl
		$0 build pcre
		$0 build libzlib
		$0 build libxml
		$0 build curl
		$0 build php
		$0 build spawnfcgi
		$0 build nginx
		
	fi
	
elif [ "$1" = "start" ]; then
	
	echo "Launching spawn-fcgi..."
	$prefix/bin/spawn-fcgi -a 127.0.0.1 -p 9000 -u $USER -g $USER -f $prefix/bin/php-cgi -P $prefix/spawn-fcgi.pid
	echo "Launching Nginx..."
	$prefix/sbin/nginx
	
elif [ "$1" = "stop" ]; then
	
	echo "Finding PID file for spawn-fcgi..."
	if [ -f $prefix/spawn-fcgi.pid ]; then
		PID_FCGI=`cat $prefix/spawn-fcgi.pid`
	fi
	if [ "$PID_FCGI" = "" ]; then
		echo "Could not find a PID for spawn-fcgi.  Nothing to kill."
	else
		echo "Found PID $PID_FCGI...killing process..."
		kill $PID_FCGI
		rm -f $prefix/spawn-fcgi.pid
	fi
	
	echo "Finding PID file for Nginx..."
	if [ -f $prefix/nginx.pid ]; then
		PID_HTTPD=`cat $prefix/nginx.pid`
	fi
	if [ "$PID_HTTPD" = "" ]; then
		echo "Could not find a PID for Nginx.  Nothing to kill."
	else
		echo "Found PID $PID_HTTPD...killing process..."
		kill $PID_HTTPD
		rm -f $prefix/nginx.pid
	fi
	
	PID_FCGI=""
	PID_HTTPD=""
	
elif [ "$1" = "restart" ]; then
	
	$0 stop
	$0 start
	
elif [ "$1" = "rehash" ]; then
	
	if [ -f $prefix/nginx.pid ]; then
		echo "Rehashing Nginx..."
		$prefix/sbin/nginx -s reload
	else
		echo "Nginx doesn't appear to be running."
	fi
	
fi