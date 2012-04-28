PostgreSQL
==========

All of PostgreSQL's [procedural languages](http://www.postgresql.org/docs/current/static/xplang.html), which allow you to write functions and procedures inside the database, allow you to execute arbitrary SQL statements.

PL/pgSQL
--------

The safest way to execute SQL inside a PL/pgSQL statement is just to do so:

    CREATE OR REPLACE FUNCTION user_access (
        p_uname TEXT
    ) RETURNS timestamp language plpgsql AS $$
    BEGIN
        RETURN accessed_at FROM users WHERE username = p_uname;
    END;
    $$;

For such a simple case, you're actually better off writing a pure SQL function:

    CREATE OR REPLACE FUNCTION user_access (
        p_uname TEXT
    ) RETURNS timestamp language sql AS $$
        SELECT accessed_at FROM users WHERE username = $1;
    $$;

But sometimes you have to do more complicated things. Perhaps you dynamically add `WHERE` clause expressions based on input. In such cases, you'll end up using PL/pgSQL's `EXECUTE` syntax. Here's an example with an SQL injection vulnerability:

    CREATE OR REPLACE FUNCTION get_users(
        p_column TEXT,
        p_value  TEXT
    ) RETURNS SETOF users LANGUAGE plpgsql AS $$
    DECLARE
        query TEXT := 'SELECT * FROM users';
    BEGIN
        IF p_column IS NOT NULL THEN
            query := query || ' WHERE ' || p_column
                  || $_$ = '$_$ || p_value || $_$'$_$;
        END IF;
        RETURN QUERY EXECUTE query;
    END;
    $$;

Both the `p_column` and the `p_value` arguments are vulnerable. The way to avoid this problem is to use the `quote_ident()` function to quote an SQL identifier (`p_column` in this case) and `quote_lteral()` to quote a literal value:

    CREATE OR REPLACE FUNCTION get_users(
        p_column TEXT,
        p_value  TEXT
    ) RETURNS SETOF users LANGUAGE plpgsql AS $$
    DECLARE
        query TEXT := 'SELECT * FROM users';
    BEGIN
        IF p_column IS NOT NULL THEN
            query := query || ' WHERE ' || quote_ident(p_column)
                  || ' = ' || quote_literal(p_value);
        END IF;
        RETURN QUERY EXECUTE query;
    END;
    $$;

It's quite a bit easier to read, too!

PL/Perl
-------

TODO.

PL/Python
---------

TODO.

### PL/Tcl

TODO.
