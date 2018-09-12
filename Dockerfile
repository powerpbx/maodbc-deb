FROM debian:stretch
MAINTAINER Walter Doekes <wjdoekes+maodbc@osso.nl>

# This one should be before the From, but it's not legal for Docker 1.13
# yet. Use a hack to s/debian:stretch/debian:OTHER/g above instead.
ARG codename=stretch
# --build-args with examples
# upversion=3.0.6, buildversion=3.0.6-0osso1+deb9
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
# Optional for ssl. Using libssl1.0-dev for Debian/Stretch instead of
# libssl-dev (1.1) because the Asterisken we use this on are also pinned
# to 1.0.2 because of reasons. (
RUN apt-get install -y libssl1.0-dev

RUN mkdir -p /build
RUN curl --fail "https://downloads.mariadb.com/Connectors/odbc/connector-odbc-${upversion}/mariadb-connector-odbc-${upversion}-ga-src.tar.gz" \
    >/build/maodbc_${upversion}.orig.tar.gz
RUN cd /build && \
    mkdir maodbc-${upversion} && \
    tar --strip-components=1 -C maodbc-${upversion} -zxf "maodbc_${upversion}.orig.tar.gz" && \
    mkdir /build/maodbc-${upversion}/debian
COPY . /build/maodbc-${upversion}/debian/
WORKDIR /build/maodbc-${upversion}
RUN dpkg-buildpackage -us -uc -sa

# TODO: for bonus points, we could run quick tests here;
# for starters dpkg -i tests?

# /Docker.output must be mounted already.
ENV codename=${codename} upversion=${upversion} buildversion=${buildversion}
CMD echo && mkdir /Docker.output/${codename}/maodbc_${buildversion} && \
    mv /build/*${buildversion}* /Docker.output/${codename}/maodbc_${buildversion}/ && \
    mv /build/maodbc_${upversion}.orig.tar.gz /Docker.output/${codename}/maodbc_${buildversion}/ && \
    chown -R ${UID}:root /Docker.output/${codename} && \
    cd / && find Docker.output/${codename}/maodbc_${buildversion} -type f && \
    echo && echo 'Output files created succesfully'
