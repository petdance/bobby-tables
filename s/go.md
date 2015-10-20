Go
===

The [database/sql][database/sql] package from the standard library provides
methods for executing parameterized queries either as prepared statements or as
one-off queries.

    age := 27
    rows, err := db.Query("SELECT name FROM users WHERE age=?", age)

In addition to `database/sql` you must also import an appropriate [driver for
your database][drivers].

The specific format of the parameter placeholders (`?`, `$1`, etc) is not
specified by `database/sql`. That detail is determined by your selected driver
so check their documentation. For example the PostgreSQL driver
[github.com/lib/pq][pq] supports numeric parameters that can be reused such as
in this snippet from their docs:

    rows, err := db.Query(`SELECT name FROM users WHERE favorite_fruit = $1
        OR age BETWEEN $2 AND $2 + 3`, "orange", 64)

Additional options such as named parameters can be obtained using the
[github.com/jmoiron/sqlx][sqlx] package.

You can learn more about using SQL databases in Go in the [database/sql
documentation][database/sql] and through the [go-database-sql
tutorial][tutorial].


[database/sql]: https://golang.org/pkg/database/sql/
[drivers]: https://github.com/golang/go/wiki/SQLDrivers
[pq]: https://godoc.org/github.com/lib/pq
[sqlx]: http://jmoiron.github.io/sqlx/
[tutorial]: http://go-database-sql.org/
