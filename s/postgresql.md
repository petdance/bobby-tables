PostgreSQL
==========

All of PostgreSQL's [procedural languages](http://www.postgresql.org/docs/current/static/xplang.html), which allow you to write functions and procedures inside the database, allow you to execute arbitrary SQL statements.

PL/pgSQL
--------

The safest way to execute SQL inside a PL/pgSQL statement is just to do so:

    CREATE OR REPLACE FUNCTION user_access (p_uname TEXT)
      RETURNS timestamp LANGUAGE plpgsql AS
    $func$
    BEGIN
        RETURN accessed_at FROM users WHERE username = p_uname;
    END
    $func$;

For such a simple case, you're actually better off writing a pure SQL function:

    CREATE OR REPLACE FUNCTION user_access (p_uname TEXT)
      RETURNS timestamp LANGUAGE sql AS
    $func$
        SELECT accessed_at FROM users WHERE username = $1
    $func$;

But sometimes you have to do more complicated things. Perhaps you dynamically add `WHERE` clause expressions based on input. In such a case, you'll end up using PL/pgSQL's [`EXECUTE`](http://www.postgresql.org/docs/current/interactive/plpgsql-statements.html#PLPGSQL-STATEMENTS-EXECUTING-DYN) syntax. Here's an example with an SQL injection vulnerability:

    CREATE OR REPLACE FUNCTION get_users(p_column TEXT, p_value TEXT)
      RETURNS SETOF users LANGUAGE plpgsql AS
    $func$
    DECLARE
        query TEXT := 'SELECT * FROM users';
    BEGIN
        IF p_column IS NOT NULL THEN
            query := query || ' WHERE ' || p_column
                  || $_$ = '$_$ || p_value || $_$'$_$;
        END IF;
        RETURN QUERY EXECUTE query;
    END
    $func$;

Both the `p_column` and the `p_value` arguments are vulnerable. One
way to avoid this problem is to use the `quote_ident()` function to
quote SQL identifiers (`p_column` in this case) and `quote_literal()`
and quote literal values:

    CREATE OR REPLACE FUNCTION get_users(p_column TEXT, p_value TEXT)
      RETURNS SETOF users LANGUAGE plpgsql AS
    $func$
    DECLARE
        query TEXT := 'SELECT * FROM users';
    BEGIN
        IF p_column IS NOT NULL THEN
            query := query || ' WHERE ' || quote_ident(p_column)
                  || ' = ' || quote_literal(p_value);
        END IF;
        RETURN QUERY EXECUTE query;
    END;
    $func$;

It's quite a bit easier to read, too!
Better yet, employ the `USING` clause of the [`EXECUTE`](http://www.postgresql.org/docs/current/interactive/plpgsql-statements.html#PLPGSQL-STATEMENTS-EXECUTING-DYN) command for values (available since v8.4):

    CREATE OR REPLACE FUNCTION get_users(p_column TEXT, p_value TEXT)
      RETURNS SETOF users LANGUAGE plpgsql AS
    $func$
    DECLARE
        query TEXT := 'SELECT * FROM users';
    BEGIN
        IF p_column IS NOT NULL THEN
            query := query || ' WHERE ' || quote_ident(p_column) || ' = $1';
        END IF;
        RETURN QUERY EXECUTE query
        USING p_value;
    END;
    $func$;

This form avoids the run-time overhead of converting values to text and back in addition to protecting against SQLi.


PL/Perl
-------

TODO.

PL/Python
---------

TODO.

### PL/Tcl

TODO.
