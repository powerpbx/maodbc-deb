PowerPBX build of the maodbc.so MariaDB SQL ODBC Connector
======================================================

Get source::

    # Get source from https://downloads.mariadb.org/connector-odbc/
    # and rename to maodbc_VERSION.orig.tar.gz; e.g.:
    wget -O maodbc_3.0.8.orig.tar.gz \
      https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.0.8/mariadb-connector-odbc-3.0.8-ga-src.tar.gz
    # 3.0.8 has md5sum 697acdd64ea4c93e8e828ff7e453ef4c

    # Extract:
    tar zxf maodbc_3.0.8.orig.tar.gz
    cd mariadb-connector-odbc-3.0.8-ga-src

Setup ``debian/`` dir::

    git clone -b artemis20 https://github.com/powerpbx/maodbc-deb.git debian

Optionally alter ``debian/changelog`` and then build::

    dpkg-buildpackage -us -uc -sa


TODO
----

* Check if odbcinst.ini is necessary since that is installed by ivozprovider artemis
* Check that the SSL we compiled against actually works.
