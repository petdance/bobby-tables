Python
======

Using the [Python DB API](http://wiki.python.org/moin/DatabaseProgramming/), don't do this:

    # Do NOT do it this way.
    cmd = "update people set name='%s' where id='%s'" % (name, id)
    curs.execute(cmd)

Instead, do this:

    cmd = "update people set name=%s where id=%s"
    curs.execute(cmd, (name, id))

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

    >>> import MySQLdb; print MySQLdb.paramstyle
    format
    >>> import psycopg2; print psycopg2.paramstyle
    pyformat
    >>> import sqlite3; print sqlite3.paramstyle
    qmark
    
So if you are using MySQL or PostgreSQL, use `%s` (even for numbers and
other non-string values!) and if you are using SQLite use `?`


To do
-----

-   Add some narrative.
