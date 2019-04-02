## -*- mode: dockerfile; -*-
FROM alpine:3.9

MAINTAINER "Klaus Kähler Holst" klaus@holst.it

ENV R_BASE_VERSION 3.5.3

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

ENV BUILD_DEPS \
	perl \
	cairo-dev \
	bzip2-dev \
	curl-dev \
	readline-dev \
	xz-dev \
	zlib-dev \
	libpng-dev \
	openssl-dev \
	libxml2-dev \
	pango-dev

ENV PERSISTENT_DEPS \
	ca-certificates \
	pcre-dev \
	libexecinfo-dev \
	curl \
	perl \
	libintl \
	icu-libs \
	libc-dev \
	autoconf \
	automake \
	make \
	git \
	gcc \
	g++ \
	musl-dev \
	gfortran \
	openblas-dev \
	coreutils \
	bash ncurses \
	python3

RUN	apk add --no-cache --virtual .build-deps $BUILD_DEPS && \
	apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
	python3 -m ensurepip && \
	rm -r /usr/lib/python*/ensurepip && \
	pip3 install --upgrade pip setuptools && \
	if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
	if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
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
	echo 'CXXFLAGS  += -D__MUSL__' >> /usr/lib/R/etc/Makeconf && \
	echo 'CXX1XFLAGS  += -D__MUSL__' >> /usr/lib/R/etc/Makeconf && \
	cd src/nmath/standalone && \
	make && \
	make install && \
	rm -rf /tmp/build_r && \
	rm -r /root/.cache && \
	apk del .build-deps

VOLUME /data
WORKDIR /data

CMD R --no-save
