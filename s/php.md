PHP
===

PHP is a little more disorganized than how
[Perl handles parameters](./perl.html).
The standard [MySQL extension](http://php.net/manual/en/book.mysql.php)
doesn't support parameterization, although the
[PostgreSQL extension](http://www.php.net/manual/en/book.pgsql.php) does:

    $result = pg_query_params( $dbh, 'SELECT * FROM users WHERE email = $1', array($email) );

Note that the query must be in single-quotes or have the `$` escaped
to avoid PHP trying to parse it as a variable.

**However**, you should probably be using an abstraction layer.
The [ODBC](http://php.net/manual/en/book.uodbc.php) and
[PDO](http://www.php.net/manual/en/book.pdo.php) extensions both
support parameterization and multiple databases:

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

Here's a great [tutorial on migrating to PDO for MySQL developers](http://wiki.hashphp.org/PDO_Tutorial_for_MySQL_Developers).

Applications & Frameworks
=========================

CakePHP
-------

When using the MVC framework [CakePHP](http://cakephp.org/), most of your database communication will be abstracted away by the Model API. Still, it is sometimes necessary to perform manual queries, which can be done with [Model::query](http://api.cakephp.org/class/model#method-Modelquery). In order to use prepared statements with that method, you just need to pass an additional array parameter after the SQL query string. There are two variants:

    // Unnamed placeholders: Pass an array containing one element for each ? 
    $this->MyModel->query(
        'SELECT name FROM users WHERE id = ? AND status = ?', 
        array($id, $status)
    );
    
    // Named placeholders: Pass an associative array
    $this->MyModel->query(
        'SELECT name FROM users WHERE id = :id AND status = :status', 
        array('id' => $id, 'status' => $status)
    );
    
This behavior is documented in the [CakePHP Cookbook](http://book.cakephp.org/2.0/en/models/retrieving-your-data.html#prepared-statements). (It is described for the `fetchAll()`-method, but `query()` uses `fetchAll()` internally).

WordPress
---------

If your site/blog/application is running on [WordPress](http://wordpress.org), you can use the `prepare` method of the `$wpdb` class, which supports both a sprintf()-like and vsprintf()-like syntax.

    global $wpdb;
    $wpdb->query(
        $wpdb->prepare( "SELECT name FROM people WHERE id = %d OR email = %s",
            $person_id, $person_email
        )
    );

For INSERTs, UPDATEs, and DELETEs, you can use the handy helper methods in the class, which allow you to specify the format of the submitted values.

    global $wpdb;
    $wpdb->insert( 'people',
            array(
                'person_id' => '123',
                'person_email' => 'bobby@tables.com'
            ),
        array( '%d', '%s' )
    );

More details on the [WordPress Codex](http://codex.wordpress.org/Class_Reference/wpdb).
