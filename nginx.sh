#!/bin/bash

# Where are we placing our build?
prefix="$HOME/httpd"

if [ "$1" = "build" ]; then

	# Define our version numbers
	vNcurses="5.9"
	vMariaDB="5.2.9"
	vOpenSSL="1.0.0d"
	vPCRE="8.12"
	vZlib="1.2.5"
	vlibxml="2.7.7"
	vCurl="7.21.7"
	vlibmcrypt="2.5.8"
	vPHP="5.3.8"
	vNginx="1.0.10"

	mkdir -p $prefix/source

	if [ "$2" = "ncurses" ]; then

		wget -O $prefix/source/ncurses-$vNcurses.tar.gz http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$vNcurses.tar.gz
		tar -C $prefix/source -xvf $prefix/source/ncurses-$vNcurses.tar.gz
		cd $prefix/source/ncurses-$vNcurses && ./configure --prefix=$prefix
		make -C $prefix/source/ncurses-$vNcurses
		make -C $prefix/source/ncurses-$vNcurses install

	elif [ "$2" = "mariadb" ]; then

		wget -O $prefix/source/mariadb-$vMariaDB.tar.gz http://downloads.askmonty.org/f/mariadb-$vMariaDB/kvm-tarbake-jaunty-x86/mariadb-$vMariaDB.tar.gz/from/http://mirror.layerjet.com/mariadb
		tar -C $prefix/source -xvf $prefix/source/mariadb-$vMariaDB.tar.gz
		cd $prefix/source/mariadb-$vMariaDB && LDFLAGS="-L$prefix/lib" ./configure --prefix=$prefix --without-plugin-innodb_plugin --with-embedded-server
		make -C $prefix/source/mariadb-$vMariaDB
		make -C $prefix/source/mariadb-$vMariaDB install

	elif [ "$2" = "openssl" ]; then

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

	elif [ "$2" = "libmcrypt" ]; then

		wget -O $prefix/source/libmcrypt-$vlibmcrypt.tar.gz http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/$vlibmcrypt/libmcrypt-$vlibmcrypt.tar.gz
		tar -C $prefix/source -xvf $prefix/source/libmcrypt-$vlibmcrypt.tar.gz
		cd $prefix/source/libmcrypt-$vlibmcrypt && ./configure --prefix=$prefix --disable-posix-threads
		make -C $prefix/source/libmcrypt-$vlibmcrypt
		make -C $prefix/source/libmcrypt-$vlibmcrypt install

	elif [ "$2" = "php" ]; then

		wget -O $prefix/source/php-$vPHP.tar.gz http://www.php.net/get/php-$vPHP.tar.gz/from/this/mirror
		tar -C $prefix/source -xvf $prefix/source/php-$vPHP.tar.gz
		cd $prefix/source/php-$vPHP && ./configure --prefix=$prefix --with-curl --enable-sockets --with-libxml-dir=$prefix --with-curl=$prefix --with-mysql=$prefix --with-zlib=$prefix --with-mcrypt=$prefix --enable-mbstring
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
		cd $prefix/source/nginx-$vNginx && ./configure --prefix=$prefix --pid-path=$prefix/nginx.pid --with-pcre=../pcre-$vPCRE --with-zlib=../zlib-$vZlib --with-openssl=$prefix/lib --user=$USER --group=$USER
		make -C $prefix/source/nginx-$vNginx
		make -C $prefix/source/nginx-$vNginx install

	elif [ "$2" = "all" ]; then

		$0 build ncurses
		$0 build mariadb
		$0 build openssl
		$0 build pcre
		$0 build libzlib
		$0 build libxml
		$0 build curl
		$0 build libmcrypt
		$0 build php
		$0 build spawnfcgi
		$0 build nginx

	fi
	
elif [ "$1" = "setupconfig" ]; then

	$prefix/source/mariadb-5.2.9/scripts/mysql_install_db --user=$USER
	$prefix/share/mysql/mysql.server start && $prefix/bin/mysql_secure_installation && $prefix/share/mysql/mysql.server stop
	mkdir -p $prefix/sites/default/resources && mv $prefix/html $prefix/sites/default/public
	rm $prefix/conf/nginx.conf && wget -O $prefix/conf/nginx.conf https://raw.github.com/mikemansell/Nginx-Setup-Script/master/configfiles/nginx.conf
	wget -O $prefix/conf/php https://raw.github.com/mikemansell/Nginx-Setup-Script/master/configfiles/php

elif [ "$1" = "start" ]; then

	echo "Launching spawn-fcgi..."
	$prefix/bin/spawn-fcgi -a 127.0.0.1 -p 9090 -u $USER -g $USER -f $prefix/bin/php-cgi -P $prefix/spawn-fcgi.pid

	echo "Launching Nginx..."
	$prefix/sbin/nginx

	$prefix/share/mysql/mysql.server start

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

	$prefix/share/mysql/mysql.server stop

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

	$prefix/share/mysql/mysql.server reload

fi