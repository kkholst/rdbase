## -*- mode: dockerfile; -*-

FROM bitnami/minideb:buster

MAINTAINER "Klaus Kähler Holst" klaus@holst.it

ENV R_BASE_VERSION 4.0.0

ENV BUILD_DEPS \
	libreadline-dev \
	zlib1g-dev \
	libbz2-dev \
	liblzma-dev \
	libpng-dev \
	libpcre2-dev \
	libcurl4-openssl-dev \
	curl

ENV PERSISTENT_DEPS \
	ca-certificates bash \
	gcc g++ gfortran make

RUN install_packages ${PERSISTENT_DEPS} ${BUILD_DEPS} && \
	 cd /tmp; curl -sSLO https://cran.r-project.org/src/base/R-`echo ${R_BASE_VERSION} | awk -F. '{print $1}'`/R-${R_BASE_VERSION}.tar.gz && \
	tar xf R-${R_BASE_VERSION}.tar.gz && cd R-${R_BASE_VERSION} && \
	./configure --prefix=/usr --sysconfdir=/etc --mandir=/usr/share/man --localstatedir=/var \
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
	cd ..; rm -Rf R-${R_BASE_VERSION} && \
	apt-get remove ${BUILD_DEPS} -y && \
	rm -Rf /tmp/*

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib64:${LD_LIBRARY_PATH}
ENV LIBRARY_PATH=/usr/local/lib:/usr/local/lib64:/usr/lib64:${LD_LIBRARY_PATH}

VOLUME /data
WORKDIR /data

CMD bash
