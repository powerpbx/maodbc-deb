PowerPBX build of the maodbc.so MariaDB SQL ODBC Connector
======================================================

Get source::

    # Get source from https://downloads.mariadb.org/connector-odbc/
    # and rename to maodbc_VERSION.orig.tar.gz; e.g.:
    wget -O maodbc_3.0.6.orig.tar.gz \
      https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.0.6/mariadb-connector-odbc-3.0.6-ga-src.tar.gz
    # 3.0.6 has md5sum 6e16ed523732dbf3df6bc0ece3aa73de

    # Extract:
    tar zxf maodbc_3.0.6.orig.tar.gz
    cd mariadb-connector-odbc-3.0.6-ga-src

Setup ``debian/`` dir::

    git clone https://github.com/ossobv/maodbc-deb.git debian

Optionally alter ``debian/changelog`` and then build::

    dpkg-buildpackage -us -uc -sa


TODO
----

* Check the odbcinst.ini flags (like Threading=0) and whether they
  actually do anything in the maodbc driver.
* Check that the SSL we compiled against actually works.
