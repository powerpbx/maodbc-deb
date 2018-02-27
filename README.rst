OSSO build of the maodbc.so MariaDB SQL ODBC Connector
======================================================

Get source::

    # Get source from https://downloads.mariadb.org/connector-odbc/
    # and rename to myodbc_VERSION.orig.tar.gz; e.g.:
    wget -O maodbc_3.0.3.orig.tar.gz \
      https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.0.3/mariadb-connector-odbc-3.0.3-ga-src.tar.gz
    # 3.0.3 has md5sum dcea2a6b1aceacc6d969bb17b5919e07

    # Extract:
    tar zxf maodbc_3.0.3.orig.tar.gz 
    cd mariadb-connector-odbc-3.0.3-ga-src

Setup ``debian/`` dir::

    git clone https://github.com/ossobv/maodbc-deb.git debian

Optionally alter ``debian/changelog`` and then build::

    dpkg-buildpackage -us -uc -sa


TODO
----

* Make (reproducible) build with docker.
* Add hardened/other flags to inner mariadb-connector-c build.
