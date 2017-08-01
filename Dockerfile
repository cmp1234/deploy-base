From cmp1234/python-jre:2.7.13-8u131-alpine3.6

MAINTAINER Wang Lilong <wanglilong007@gmail.com>

ENV SSH_VERSION 7.4p1
ENV SSH_DOWNLOAD_URL http://mirrors.sonic.net/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz

ENV SSHPASS_VERSION 1.06
ENV SSHPASS_DOWNLOAD_URL https://nchc.dl.sourceforge.net/project/sshpass/sshpass/1.06/sshpass-1.06.tar.gz

ENV YAML_VERSION 0.1.6
ENV YAML_DOWNLOAD_URL  http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz

COPY build_openssh.sh /build_openssh.sh 
RUN chmod +x /build_openssh.sh

RUN set -ex; \
	\
 apk add --no-cache --virtual .build-deps \
		coreutils \
		gcc \
		curl \
		linux-headers \
		make \
		musl-dev \
		zlib \
		zlib-dev \
		openssl \
		openssl-dev \
	; \
  ansibleList=' \
            pycrypto==2.6.1 \
            ecdsa==0.13 \
            paramiko==1.17.0 \
            MarkupSafe==1.0 \
            Jinja2==2.8 \
            PyYAML==3.11 \
            ansible==2.2.1.0 \
        '; \
  pip install $ansibleList; \
  \
  curl -fSL $SSHPASS_DOWNLOAD_URL -o sshpass-${SSHPASS_VERSION}.tar.gz; \
  tar xvf sshpass-${SSHPASS_VERSION}.tar.gz; \
  cd sshpass-${SSHPASS_VERSION}; \
  ./configure --prefix=/usr/local && make && make install && cd .. && rm sshpass-${SSHPASS_VERSION}* -rf; \
  \
  curl -fSL $YAML_DOWNLOAD_URL -o yaml-${YAML_VERSION}.tar.gz; \
  tar xvf yaml-${YAML_VERSION}.tar.gz; \
  cd yaml-${YAML_VERSION}; \
  ./configure --prefix=/usr/local && make && make install && cd .. && rm yaml-${YAML_VERSION}* -rf; \
  \
	apk add --no-cache --virtual .run-deps \
		libcrypto1.0 \
	; \
  /build_openssh.sh; \
	apk del .build-deps; \
	rm -f /build_openssh.sh;
