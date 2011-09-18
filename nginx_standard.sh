#!/bin/bash

# Where are we placing our build?
prefix="$HOME/httpd"

if [ "$1" = "build" ]; then

	# Define our version numbers
	vPCRE="8.12"
	vZlib="1.2.5"
	vNginx="1.0.6"

	mkdir $prefix/source

	wget -O $prefix/source/pcre-$vPCRE.tar.gz http://downloads.sourceforge.net/project/pcre/pcre/$vPCRE/pcre-$vPCRE.tar.gz
	tar -C $prefix/source -xvf $prefix/source/pcre-$vPCRE.tar.gz

	wget -O $prefix/source/zlib-$vZlib.tar.gz http://zlib.net/zlib-$vZlib.tar.gz
	tar -C $prefix/source -xvf $prefix/source/zlib-$vZlib.tar.gz
	
	wget -O $prefix/source/nginx-$vNginx.tar.gz http://nginx.org/download/nginx-$vNginx.tar.gz
	tar -C $prefix/source -xvf $prefix/source/nginx-$vNginx.tar.gz
	cd $prefix/source/nginx-$vNginx && ./configure --prefix=$prefix --pid-path=$prefix/nginx.pid --with-pcre=../pcre-$vPCRE --with-zlib=../zlib-$vZlib --user=$USER --group=$USER
	make -C $prefix/source/nginx-$vNginx
	make -C $prefix/source/nginx-$vNginx install
	
fi