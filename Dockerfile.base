## -*- mode: dockerfile; -*-

FROM kkholst/stat:r

MAINTAINER "Klaus Kähler Holst" klaus@holst.it

ENV BUILD_DEPS \
	postgresql-dev \
	curl-dev \
	openssl-dev
	
ENV PERSISTENT_DEPS \
	cmake \
	python3 \
	python3-dev \
	postgresql-libs \
	libcurl \
	libpq

RUN	apk add --no-cache --virtual .build-deps $BUILD_DEPS && \
	apk add --no-cache $PERSISTENT_DEPS python3 && \
	# apk add --no-cache \
   	# --repository  http://dl-3.alpinelinux.org/alpine/edge/testing \
 	# hdf5 hdf5-dev && \
	python3 -m ensurepip && \
	rm -r /usr/lib/python*/ensurepip && \
	pip3 install --upgrade pip setuptools && \
	if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
	if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
	apk del --no-cache .build-deps && apk add --no-cache .persistent-deps && \
	rm -rf /var/cache/apk/* /tmp/*

RUN 	R -q -e "install.packages(c('RcppEnsmallen'))" &&  \
	pip3 install numpy scikit-build  && \
 	rm -Rf /tmp/* 

CMD R --no-save


