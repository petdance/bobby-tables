PHP
===

PHP is a little more disorganized than how [Perl handles parameters](./perl.html). The standard [MySQL extension](http://php.net/manual/en/book.mysql.php) doesn't support parameterization, although the [PostgreSQL extension](http://www.php.net/manual/en/book.pgsql.php) does:

    $result = pg_query_params( $dbh, 'SELECT * FROM users WHERE email = $1', array($email) );

Note that the query must be in single-quotes or have the `$` escaped to avoid PHP trying to parse it as a variable.

**However**, you should probably be using an abstraction layer.  The [ODBC](http://php.net/manual/en/book.uodbc.php) and [PDO](http://www.php.net/manual/en/book.pdo.php) extensions both support parameterization and multiple databases:

Using mysqli
------------

The MySQL Improved extension handles bound parameters.

    $stmt = $db->prepare('update people set name = ? where id = ?');
    $stmt->bind_param('si',$name,$id);
    $stmt->execute();

Using ADODB
-----------

ADODB provides a way to prepare, bind and execute all in the same method call.

    $dbConnection = NewADOConnection($connectionString);
    $sqlResult = $dbConnection->Execute(
        'SELECT user_id,first_name,last_name FROM users WHERE username=? AND password=?',
        array($_REQUEST['username'], sha1($_REQUEST['password'])
    );

Using the ODBC layer
--------------------

    $stmt = odbc_prepare( $conn, 'SELECT * FROM users WHERE email = ?' );
    $success = odbc_execute( $stmt, array($email) );

Or:

    $res = odbc_exec($conn, 'SELECT * FROM users WHERE email = ?', array($email));
    
    $sth = $dbh->prepare('SELECT * FROM users WHERE email = :email');
    $sth->execute(array(':email' => $email));

Using the PDO layer
-------------------

Here's the long way to do bind parameters.

    $dbh = new PDO('mysql:dbname=testdb;host=127.0.0.1', $user, $password);
    $stmt = $dbh->prepare('INSERT INTO REGISTRY (name, value) VALUES (:name, :value)');
    $stmt->bindParam(':name', $name);
    $stmt->bindParam(':value', $value);
    
    // insert one row
    $name = 'one';
    $value = 1;
    $stmt->execute();

And a shorter way to pass things in.

    $dbh = new PDO('mysql:dbname=testdb;host=127.0.0.1', $user, $password);
    $stmt = $dbh->prepare('UPDATE people SET name = :new_name WHERE id = :id');
    $stmt->execute( array('new_name' => $name, 'id' => $id) );
