Python
======

Using the [Python DB API](http://wiki.python.org/moin/DatabaseProgramming/), don't do this:

    # Do NOT do it this way.
    cmd = "update people set name='%s' where id='%s'" % (name, id)
    curs.execute(cmd)

Instead, do this:

    curs.execute('update people set name=:1 where id=:2', [name, id])

To do
-----

-   Add some narrative.
