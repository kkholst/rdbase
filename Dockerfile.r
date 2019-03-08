## -*- mode: dockerfile; -*-

FROM openjdk:8u191-jdk-alpine3.9

MAINTAINER "Klaus Kähler Holst" klaus@holst.it

ENV R_BASE_VERSION 3.5.2

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV BUILD_DEPS \
	perl \
	cairo-dev \
	pango-dev

ENV PERSISTENT_DEPS \
	bzip2-dev \
	ca-certificates \
	curl curl-dev \
	pcre-dev \
	perl \
	readline-dev \
	libexecinfo-dev \
	libintl \
	icu-libs \
	xz-dev\
	zlib-dev \
	libc-dev \
	autoconf \
	automake \
	make \
	git \
	alpine-sdk \
	gcc \
	g++ \
	cmake \
	gfortran \
	libpng-dev \
	openblas-dev \
	coreutils bash ncurses \
	openssl-dev \
	python3 \
	libxml2-dev

RUN	apk add --no-cache --virtual .build-deps $BUILD_DEPS && \
	apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
	mkdir /tmp/build_r && cd /tmp/build_r \
	&& apk add --no-cache curl \
	&& curl -sSLO https://cran.rstudio.com/src/base/R-${R_BASE_VERSION:0:1}/R-${R_BASE_VERSION}.tar.gz \
	&& tar xf R-${R_BASE_VERSION}.tar.gz && cd R-${R_BASE_VERSION} \
	&& ./configure --build=$CBUILD --host=$CHOST --prefix=/usr --sysconfdir=/etc --mandir=/usr/share/man --localstatedir=/var \
	--without-x \
	--with-tcltk=no \
	--with-aqua=no \
	--without-recommended-packages \
	--disable-nls \
	--with-jpeglib=no --with-libtiff=no \
	&& make -j $(cat /proc/self/status | awk '$1 == "Cpus_allowed_list:" { print $2 }' | tr , '\n' | awk -F'-' '{ if (NF == 2) count += $2 - $1 + 1; else count += 1 } END { print count }') \
	&& make install && \
	echo 'options("repos"="https://cran.rstudio.com")' >> /usr/lib/R/etc/Rprofile.site && \
	cd src/nmath/standalone && \
	make && \
	make install && \
	rm -rf /tmp/build_r && \
	apk del .build-deps

VOLUME /data
WORKDIR /data

CMD R --no-save
