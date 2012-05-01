# About Bobby Tables and SQL injection

# Why did Bobby's school lose their records?

The school apparently stores the names of their students in a table called Students. When a new student arrives, the school inserts his/her name into this table. The code doing the insertion might look as follows:

    $sql = "INSERT INTO Students (Name) VALUES ('" . $studentName . "');";
    execute_sql($sql);

The first line creates a string containing an SQL INSERT statement. The content of the `$studentName` variable is glued into the SQL statement. The second line sends the resulting SQL statement to the database. The pitfall of this code is that outside data, in this case the content of `$studentName`, becomes part of the SQL statement.

First let's see what the SQL statement looks like if we insert a student named John:

    INSERT INTO Students (Name) VALUES ('John');

This does exactly what we want: it inserts John into the Students table.

Now we insert little Bobby Tables, by setting `$studentName` to `Robert'); DROP TABLE Students;--`. The SQL statement becomes:

    INSERT INTO Students (Name) VALUES ('Robert'); DROP TABLE Students;--');

This inserts Robert into the Students table. However, the INSERT statement is now followed by a DROP TABLE statement which removes the entire Students table. Ouch!


# How to avoid Bobby Tables

There is only one way to avoid Bobby Tables attacks

* Do not create SQL statements that include outside data.
* Use parameterized SQL calls.

That's it. Don't try to escape invalid characters. Don't try to do it yourself. Learn how to use parameterized statements. Always, every single time.

The strip gets one thing crucially wrong. The answer is not to "sanitize your database inputs" yourself. It is prone to error.
