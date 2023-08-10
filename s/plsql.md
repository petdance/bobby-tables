PL/SQL
======

Examples assume the following table structure:

    CREATE TABLE users (
        username VARCHAR2(8) UNIQUE,
        accessed_at DATE,
        superuser NUMBER(1,0)
    );

    INSERT INTO users VALUES ('janihur',  sysdate,      0);
    INSERT INTO users VALUES ('petdance', sysdate - 12, 1);
    INSERT INTO users VALUES ('albundy',  sysdate - 3,  0);
    INSERT INTO users VALUES ('donduck',  sysdate - 18, 0);

Always prefer static SQL when possible
--------------------------------------

Static SQL leaves no room for SQL injection.

    CREATE OR REPLACE FUNCTION user_access (
        p_uname IN VARCHAR2
    ) RETURN date AS
        v_accessed_at date;
    BEGIN
        SELECT accessed_at INTO v_accessed_at FROM users WHERE username = p_uname;
        RETURN v_accessed_at;
    END;
    /


    SELECT user_access('janihur')
      AS "JANIHUR LAST SEEN" FROM DUAL;

    JANIHUR LAST SEEN
    -------------------
    2011-08-03 17:11:24

    SELECT user_access('whocares'' or superuser = 1 or username = ''whocares') 
      AS "SUPERUSER LAST SEEN" FROM DUAL;

    SUPERUSER LAST SEEN
    -------------------


If you need dynamic SQL avoid string concatenation when possible
----------------------------------------------------------------

String concatenation opens doors to possible SQL injection exploits:

    CREATE OR REPLACE FUNCTION user_access (
        p_uname IN VARCHAR2
    ) RETURN date AS
        v_accessed_at date;
        v_query constant varchar2(32767) := 
          'SELECT accessed_at FROM users WHERE username = ''' || p_uname || '''';
    BEGIN
        EXECUTE IMMEDIATE v_query INTO v_accessed_at;
        RETURN v_accessed_at;
    END;
    /


    SELECT user_access('janihur')
      AS "JANIHUR LAST SEEN" FROM DUAL;

    JANIHUR LAST SEEN
    -------------------
    2011-08-03 17:11:24

    SELECT user_access('whocares'' or superuser = 1 or username = ''whocares') 
      AS "SUPERUSER LAST SEEN" FROM DUAL;

    SUPERUSER LAST SEEN
    -------------------
    2011-07-22 17:11:24

Instead use bind variables:


    CREATE OR REPLACE FUNCTION user_access (
        p_uname IN VARCHAR2
    ) RETURN date AS
        v_accessed_at date;
        v_query constant varchar2(32767) := 
          'SELECT accessed_at FROM users WHERE username = :a';
    BEGIN
        EXECUTE IMMEDIATE v_query INTO v_accessed_at USING p_uname;
        RETURN v_accessed_at;
    END;
    /


    SELECT user_access('janihur')
      AS "JANIHUR LAST SEEN" FROM DUAL;

    JANIHUR LAST SEEN
    -------------------
    2011-08-03 17:11:24

    SELECT user_access('whocares'' or superuser = 1 or username = ''whocares') 
      AS "SUPERUSER LAST SEEN" FROM DUAL;

    SUPERUSER LAST SEEN
    -------------------

Implicit Data Type Conversion Injection
---------------------------------------

Also NLS session parameters (`NLS_DATE_FORMAT`, `NLS_TIMESTAMP_FORMAT`, `NLS_TIMESTAMP_TZ_FORMAT`, `NLS_NUMERIC_CHARACTER`) can be used to modify or inject SQL statements.

In next example data type conversion takes place when `p_since` is implicitly converted to a string for concatenation. Note how the value of `NLS_DATE_FORMAT` affects to the query string in `users_since()` function!

    ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

    CREATE OR REPLACE TYPE userlist_t AS TABLE OF VARCHAR2(8);
    /

    CREATE OR REPLACE FUNCTION users_since(
        p_since IN DATE
    ) RETURN userlist_t PIPELINED AS
        v_users userlist_t;
        v_query constant varchar2(32767) := 
          'SELECT username FROM users WHERE superuser = 0 and accessed_at > ''' || p_since || ''' order by accessed_at desc';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('v_query = ' || v_query);
        EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_users;

        FOR i IN v_users.FIRST .. v_users.LAST LOOP
          PIPE ROW(v_users(i));
        END LOOP;

        RETURN;
    END;
    /


    ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD"SUPRISE!"';
    SELECT COLUMN_VALUE AS "REGULARS" FROM TABLE(users_since(sysdate - 30));

    v_query = SELECT username FROM users WHERE superuser = 0 and accessed_at >
    '2011-07-04SUPRISE!' order by accessed_at desc

    REGULARS
    --------
    janihur
    albundy
    donduck

    ALTER SESSION SET NLS_DATE_FORMAT = '"'' or superuser = 1 or username = ''whocares"';
    SELECT COLUMN_VALUE AS "SUPERUSER IS" FROM TABLE(users_since(sysdate - 30));

    v_query = SELECT username FROM users WHERE superuser = 0 and accessed_at > ''
    or superuser = 1 or username = 'whocares' order by accessed_at desc

    SUPERUSE
    --------
    petdance

The remedy is to set the format modifier explicitly: `to_char(p_since, 'YYYY-MM-DD')`.

    ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

    CREATE OR REPLACE TYPE userlist_t AS TABLE OF VARCHAR2(8);
    /

    CREATE OR REPLACE FUNCTION users_since(
        p_since IN DATE
    ) RETURN userlist_t PIPELINED AS
        v_users userlist_t;
        v_query constant varchar2(32767) := 
          'SELECT username FROM users WHERE superuser = 0 and accessed_at > ''' || to_char(p_since, 'YYYY-MM-DD') || ''' order by accessed_at desc';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('v_query = ' || v_query);
        EXECUTE IMMEDIATE v_query BULK COLLECT INTO v_users;

        FOR i IN v_users.FIRST .. v_users.LAST LOOP
          PIPE ROW(v_users(i));
        END LOOP;

        RETURN;
    END;
    /

Now the value of NLS parameter `NLS_DATE_FORMAT` is ignored during the query.

    ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD"SUPRISE!"';
    SELECT COLUMN_VALUE AS "REGULARS" FROM TABLE(users_since(sysdate - 30));

    v_query = SELECT username FROM users WHERE superuser = 0 and accessed_at >
    '2011-07-04' order by accessed_at desc

    REGULARS
    --------
    janihur
    albundy
    donduck

See Also
--------
[Oracle documentation on SQL Injection](https://docs.oracle.com/en/database/oracle/oracle-database/19/lnpls/dynamic-sql.html#GUID-1E31057E-057F-4A53-B1DD-8BC2C337AA2C)
