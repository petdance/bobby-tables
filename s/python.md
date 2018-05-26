Python
======

Using the [Python DB API](http://wiki.python.org/moin/DatabaseProgramming/), don't do this:

    # Do NOT do it this way.
    cmd = "update people set name='%s' where id='%s'" % (name, id)
    curs.execute(cmd)

This builds a SQL string using Python's string formatting, but it creates
an unsafe string that is then passed through to the database and executed.

Instead, do this:

    cmd = "update people set name=%s where id=%s"
    curs.execute(cmd, (name, id))

This sets up placeholders so that the database can fill in the data
values properly and safely.

For cases involving a single variable do this:

    cmd = "SELECT * FROM PEOPLE WHERE name = %s"
    curs.execute(cmd, (name,))

Note that the placeholder syntax depends on the database you are using.

    'qmark'         Question mark style,
                    e.g. '...WHERE name=?'
    'numeric'       Numeric, positional style,
                    e.g. '...WHERE name=:1'
    'named'         Named style,
                    e.g. '...WHERE name=:name'
    'format'        ANSI C printf format codes,
                    e.g. '...WHERE name=%s'
    'pyformat'      Python extended format codes,
                    e.g. '...WHERE name=%(name)s'

The values for the most common databases are:

    >>> import MySQLdb; print MySQLdb.paramstyle  # MySQL
    format
    >>> import oursql; print oursql.paramstyle    # MySQL also
    qmark
    >>> import psycopg2; print psycopg2.paramstyle  # PostgreSQL
    pyformat
    >>> import pymssql; pymssql.paramstyle        # MS SQL Server
    pyformat
    >>> import sqlite3; print sqlite3.paramstyle
    qmark

So if you are using MySQL or PostgreSQL, use `%s` (even for numbers and
other non-string values!) and if you are using SQLite use `?`.

If you are using ODBC to connect to the DB, regardless of which DB it is,
use `?`.
