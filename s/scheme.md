Scheme
======

CHICKEN Scheme
--------------

[CHICKEN](http://www.call-with-current-continuation.org/) is a compiler for [Scheme](http://schemers.org/)


    (define DB (sqlite3:open  "myexample.db"))
    (sqlite3:exec DB "INSERT INTO Person(name) VALUES(?)" "Luke Skywalker")
    (sqlite3:for-each-row print DB "SELECT id,name FROM Person WHERE id=?" 3)
    (define adults (sqlite3:map-row DB "SELECT name FROM Person WHERE age >= ?" 18))

To do
-----

-   Add some narrative.
