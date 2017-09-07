From cmp1234/python-jre:security-latest-alpine3.6

MAINTAINER Wang Lilong <wanglilong007@gmail.com>

ENV SSH_VERSION 7.4p1
ENV SSH_DOWNLOAD_URL http://mirrors.sonic.net/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz

ENV SSHPASS_VERSION 1.06
ENV SSHPASS_DOWNLOAD_URL https://nchc.dl.sourceforge.net/project/sshpass/sshpass/1.06/sshpass-1.06.tar.gz

COPY build_openssh.sh /build_openssh.sh 
RUN chmod +x /build_openssh.sh

RUN set -ex; \
	\
 apk add --no-cache --virtual .build-deps \
		coreutils \
		bash \
		gcc \
		curl \
		linux-headers \
		make \
		python2-dev \
		python3-dev \
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
	apk add --no-cache --virtual .run-deps \
		libcrypto1.0 \
	; \
  /build_openssh.sh; \
	apk del .build-deps; \
	ln -s /usr/local/bin/bash /bin/bash; \
	rm -f /build_openssh.sh;
