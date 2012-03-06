h1. Scheme

h2. CHICKEN Scheme

"CHICKEN":http://www.call-with-current-continuation.org/ is a compiler for "Scheme":http://schemers.org/

<code>
(define DB (sqlite3:open  "myexample.db"))
(sqlite3:exec DB "INSERT INTO Person(name) VALUES(?)" "Luke Skywalker")
(sqlite3:for-each-row print DB "SELECT id,name FROM Person WHERE id=?" 3)
(define adults (sqlite3:map-row DB "SELECT name FROM Person WHERE age >= ?" 18))
</code>

h2. To do

* Add some narrative.
