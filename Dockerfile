FROM debian:stretch
MAINTAINER Walter Doekes <wjdoekes+maodbc@osso.nl>

# This one should be before the From, but it's not legal for Docker 1.13
# yet. Use a hack to s/debian:stretch/debian:OTHER/g above instead.
ARG codename=stretch
# --build-args with examples
# upversion=3.0.3, buildversion=3.0.3-0osso1
ARG upversion
ARG buildversion

ENV DEBIAN_FRONTEND noninteractive

# This time no "keeping the build small". We only use this container for
# building/testing and not for running, so we can keep files like apt
# cache.
RUN echo 'APT::Install-Recommends "0";' >/etc/apt/apt.conf.d/01norecommends
#RUN sed -i -e 's:deb.debian.org:apt.osso.nl:;s:security.debian.org:apt.osso.nl/debian-security:' /etc/apt/sources.list
RUN apt-get update -q
RUN apt-get install -y apt-utils
RUN apt-get dist-upgrade -y
RUN apt-get install -y \
    ca-certificates curl wget \
    build-essential dpkg-dev quilt dh-autoreconf binutils-dev \
    unixodbc-dev cmake

RUN mkdir -p /build
RUN curl --fail "https://downloads.mariadb.com/Connectors/odbc/connector-odbc-${upversion}/mariadb-connector-odbc-${upversion}-ga-src.tar.gz" \
    >/build/maodbc_${upversion}.orig.tar.gz
RUN cd /build && \
    mkdir myodbc-${upversion} && \
    tar --strip-components=1 -C myodbc-${upversion} -zxf "maodbc_${upversion}.orig.tar.gz" && \
    mkdir /build/myodbc-${upversion}/debian
COPY . /build/myodbc-${upversion}/debian/
WORKDIR /build/myodbc-${upversion}
RUN dpkg-buildpackage -us -uc -sa

# TODO: for bonus points, we could run quick tests here;
# for starters dpkg -i tests?

## TODO: check/update changelog!
## TODO: add timestamp and lsb_release code into version; but we must
##   ensure that the extra version bits are not propagated into the
##   User-Agent string because we don't want info leaks + not all SIP
##   servers accept all characters in the User-Agent/Server header.
##   right now it's not clear when we have a 11vg18 whether it's for
##   jessie or wheezy and we don't know when it was built (if there were
##   multiple builds)
## TODO: sign build.
## TODO: remove the codec_g729a.so download?
#RUN apt-get install -y asterisk-core-sounds-en-gsm
#RUN cd /build && dpkg -i \
#    asterisk_${astversion}-${vgversion}_amd64.deb \
#    asterisk-config_${astversion}-${vgversion}_all.deb \
#    asterisk-dev_${astversion}-${vgversion}_all.deb \
#    asterisk-dbg_${astversion}-${vgversion}_amd64.deb \
#    asterisk-modules_${astversion}-${vgversion}_amd64.deb \
#    asterisk-voicemail_${astversion}-${vgversion}_amd64.deb


# /Docker.output must be mounted already.
ENV codename=${codename} upversion=${upversion} buildversion=${buildversion}
CMD echo && mkdir /Docker.output/${codename}/myodbc_${buildversion} && \
    mv /build/*${buildversion}* /Docker.output/${codename}/myodbc_${buildversion}/ && \
    mv /build/maodbc_${upversion}.orig.tar.gz /Docker.output/${codename}/myodbc_${buildversion}/ && \
    chown -R ${UID}:root /Docker.output/${codename} && \
    cd / && find Docker.output/${codename}/myodbc_${buildversion} -type f && \
    echo && echo 'Output files created succesfully'
