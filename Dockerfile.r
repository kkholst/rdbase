## -*- mode: dockerfile; -*-

FROM alpine:3.11.3

MAINTAINER "Klaus Kähler Holst" klaus@holst.it

#ENV ARMA_BRANCH=9.900.x
ENV R_BASE_VERSION 3.6.3
ARG USE_HDF5=OFF

ENV BUILD_DEPS \
	perl \
	cairo-dev \
	curl-dev \
	readline-dev \
	openssl-dev \
	libxml2-dev \
	bzip2-dev \
	zlib-dev \
	xz-dev \
	pango-dev \
	curl \
	git \
	ncurses-terminfo ncurses \
	libintl \
	autoconf \
	automake \
	perl \
	cmake \
	ninja \
	python3
	
ENV PERSISTENT_DEPS \
	lapack-dev \
	openblas-dev \
	libbz2 xz-libs \
	linux-headers \
	pcre-dev \
	libpng \
	ttf-dejavu \
	pango \
	libexecinfo-dev \
	libcurl \
	make \
	g++ \
	musl-dev \
	gfortran \
	coreutils \
	bash

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib64:${LD_LIBRARY_PATH}
ENV LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib64:${LD_LIBRARY_PATH}

RUN	apk add --no-cache --virtual .build-deps $BUILD_DEPS && \
	apk add --no-cache --virtual .persistent-deps $PERSISTENT_DEPS && \
	if [ "$USE_HDF5" = "ON" ]; then (apk add --no-cache \
	--repository  http://dl-3.alpinelinux.org/alpine/edge/testing \
	hdf5 hdf5-dev); fi && \
	mkdir /tmp/build_r && cd /tmp/build_r && \
	curl -sSLO https://cran.r-project.org/src/base/R-${R_BASE_VERSION:0:1}/R-${R_BASE_VERSION}.tar.gz \
	&& tar xf R-${R_BASE_VERSION}.tar.gz && cd R-${R_BASE_VERSION} \
	&& ./configure --build=$CBUILD --host=$CHOST --prefix=/usr --sysconfdir=/etc --mandir=/usr/share/man --localstatedir=/var \
	--enable-R-shlib \
	--enable-BLAS-shlib \
	--without-x \
	--with-ICU=no \
	--with-tcltk=no \
	--with-aqua=no \
	--without-recommended-packages \
	--disable-nls \
	--with-pnglib=yes --with-jpeglib=no --with-libtiff=no \
	&& make -j $(cat /proc/self/status | awk '$1 == "Cpus_allowed_list:" { print $2 }' | tr , '\n' | awk -F'-' '{ if (NF == 2) count += $2 - $1 + 1; else count += 1 } END { print count }') \
	&& make install && \
	echo 'options("repos"="https://cloud.r-project.org/")' >> /usr/lib/R/etc/Rprofile.site && \
	echo 'CXXFLAGS  += -D__MUSL__' >> /usr/lib/R/etc/Makeconf && \
	echo 'CXX1XFLAGS  += -D__MUSL__' >> /usr/lib/R/etc/Makeconf && \
	echo 'CXX11FLAGS  += -D__MUSL__' >> /usr/lib/R/etc/Makeconf && \
	cd src/nmath/standalone && \
	make && \
	make install && \
        if [ ! "$ARMA_BRANCH" = "" ]; then \
	cd /tmp; git clone https://gitlab.com/conradsnicta/armadillo-code -b ${ARMA_BRANCH} --depth=1 armadillo && cd armadillo; \
	cmake -G Ninja -D DETECT_HDF5=${USE_HDF5} ./ && \
	ninja && ninja install && cd /tmp; rm -Rf /tmp/armadillo; fi && \        
	apk del --no-cache .build-deps && \
	if [ "$USE_HDF5" = "ON" ]; then (apk del --no-cache hdf5-dev); fi && \
	rm -Rf /tmp/* /root/.cache /var/cache/apk/* 

ENV  CXXFLAGS="-D__MUSL__ -D_BSD_SOURCE"

VOLUME /data
WORKDIR /data

CMD R --no-save
