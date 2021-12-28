FROM teknofile/tkf-docker-base-alpine-nginx:3.15

ARG LUM_VERSION="v1.7"

RUN apk update
RUN apk add \
	ldb \
	ldb-tools \
	libldap \
	freetype-dev \
	jpeg-dev \
	libjpeg \
	openjpeg-dev \
	openjpeg-tools \
	libpng-dev \
	php8-ldap 

ADD https://github.com/PHPMailer/PHPMailer/archive/v6.2.0.tar.gz /tmp

RUN mkdir -p /ldap-user-manager && \
    git clone https://github.com/wheelybird/ldap-user-manager.git --branch  ${LUM_VERSION} /ldap-user-manager

COPY root/ /

EXPOSE 80