ADO.NET
===

ADO.NET provides the most direct method of data access within the .NET Framework ([link](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-overview)).

To avoid SQL injection in ADO.NET, do not use user input to build the SQL for [**commands**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/commands-and-parameters). Instead, do the following:

1. Use [**placeholders**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/configuring-parameters-and-parameter-data-types#working-with-parameter-placeholders) for values in the SQL of the command,
2. Add [**parameters**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/commands-and-parameters) to the command, and
3. Set the value of the parameter (generally, via the [`Value` property](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbparameter.value))

Example in C#, against SQL Server:

```csharp
// conn refers to an open instance of SqlConnection

var cmd = new SqlCommand() {
   Connection = conn,
   CommandText = "SELECT * FROM Students WHERE FirstName = @FirstName"
};
var prm = cmd.Parameters.Add("StudentName", SqlDbType.NVarChar);
prm.Value = "Robert'; DROP TABLE Students; --";
```

Because of the [shared architecture](#adonet-architecture) of ADO.NET-standard implementations (aka
[**data providers**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers)),
the strategy is the same across all data providers and across all .NET supported languages.

Placeholder syntax, and the method used to bind parameter values to the placeholders, [can vary between providers](#placeholder-syntax-and-binding-parameter-values-to-placeholders).

For avoiding SQL injection in [Entity Framework](adodotnet_ef) or [other ADO.NET ORMs](adodotnet_orm), see the appropriate pages.

Commands and their uses
===

In ADO.NET, you specify
[**commands**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/commands-and-parameters) to execute
against the data source, via an open
[**connection**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/connecting-to-a-data-source). Commands
consist of a string (read/written via the command's
[`CommandText`](https://docs.microsoft.com/en-us/dotnet/api/system.data.idbcommand.commandtext?view=netframework-4.7.2#System_Data_IDbCommand_CommandText) property),
along with other properties. This string can be an SQL statement (it may also contain, a table name, a view name, or
some other string understood by the data source); this SQL statement is the primary vector for SQL injection.

 A command can:

* [execute without returning results](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/using-commands-to-modify-data)
* [return a single result](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/obtaining-a-single-value-from-a-database)
* [return a **data reader**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/retrieving-data-using-a-datareader), which allows reading a result set row by row in a forward-only direction

There is a higher level of abstraction built into ADO.NET: the
[**data set**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-datasets)
-- an in-memory representation of the data independent of any specific data source or data provider.
[**Data adapters**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/populating-a-dataset-from-a-dataadapter)
are the bridge between the data source and a data set. Internally, the data adapter makes use of commands in two ways:

1. When [filling the data set with data](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/populating-a-dataset-from-a-dataadapter),
the commmand at the data adapter's [`SelectCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter.selectcommand) property is used,

2. When [synchronizing data changes between the data set and the data source](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/updating-data-sources-with-dataadapters),
the commands at the
[`InsertCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter.insertcommand),
[`UpdateCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter.updatecommand), and
[`DeleteCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter.deletecommand) properties of the data adapter are used.

These commands are also liable to be vulnerable to SQL injection.

ADO.NET architecture
===

The basic functionality used by ADO.NET to connect to databases and other data sources is defined in a set of
`abstract` (`MustInherit` in VB.NET) classes in the
[`System.Data.Common`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common) namespace. Implementors of this
functionality for specific data sources are called ADO.NET
[**data providers**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers),
and consist of classes that inherit from these base classes.

For example, the ADO.NET data provider for connecting to SQL Server contains the following classes (among others): in the  [`System.Data.SqlCient`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient) namespace:

* [**SqlCommand**](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlcommand)
inherits from [**DbCommand**](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbcommand)
* [**SqlParameter**](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlparameter)
inherits from [**DbParameter**](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbparameter)
* [**SqlDataReader**](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldatareader)
inherits from [**DbDataReader**](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdatareader)
* [**SqlDataAdapter**](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldataadapter)
inherits from [**DbDataAdapter**](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter)

There are a number of
[data providers built-in to the .NET Framework](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers), for:

* [SQL Server](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-sql-server-sqlclient)
* [OLE DB data sources](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-ole-db) -- Access, Excel, text files, and others
* [ODBC data sources](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-odbc)
* [Entity Framework Models](https://msdn.microsoft.com/library/49202ab9-ac98-4b4b-a05c-140e422bf527)
* [SQL Server Compact Edition](https://msdn.microsoft.com/library/system.data.sqlserverce.aspx)
* [Oracle](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-oracle) (deprecated; use the Oracle-provided [ODP](https://www.oracle.com/technetwork/topics/dotnet/index-085163.html))

and there are a number of third-party providers for other data sources, for example:
[SQLite](https://system.data.sqlite.org/index.html/doc/trunk/www/index.wiki),
[MySQL](https://dev.mysql.com/downloads/connector/net),
[Firebird](https://firebirdsql.org/en/net-provider/),
[PostgreSQL](https://www.npgsql.org/)
and others.

Placeholder syntax, and binding parameter values to placeholders<a name="placeholder-syntax"></a>
===

Parameter values can be _bound_ to (associated with) placeholders in one of two ways:

* **by name** -- the name of the parameter (at the [`ParameterName`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbparameter.parametername) propertty) is the same as the name used in the placeholder
* **by position** -- based on the order in which parameters are added to the command's parameter collection. In this case, the `Name` property of the parameter is ignored.
    * The [OLE DB](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/configuring-parameters-and-parameter-data-types#working-with-parameter-placeholders) and [ODBC](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/configuring-parameters-and-parameter-data-types#working-with-parameter-placeholders) providers map to the placeholders based on the order of the placeholder usage in the SQL -- the first parameter's value is bound to the first placeholder, the second value to the second placeholder, etc.
    * Other providers make use of placeholders that refer to the number of the parameter -- `?0`, `?1`, `?2`, or `$0`, `$1`, `$2`.

The syntax used for SQL placeholders, and the parameter binding method,  varies between providers:

* [SQL Server](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/configuring-parameters-and-parameter-data-types#working-with-parameter-placeholders), Entity SQL, [MySQL](https://dev.mysql.com/doc/connector-net/en/connector-net-tutorials-parameters.html)
    * Named only: `SELECT * FROM Students WHERE FirstName = @FirstName`
* [OLE DB](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/configuring-parameters-and-parameter-data-types#working-with-parameter-placeholders), [ODBC](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/configuring-parameters-and-parameter-data-types#working-with-parameter-placeholders)
    * Positional only: `SELECT * FROM Students WHERE FirstName = ?`
* Oracle (ODP)
    * Placeholder syntax: `SELECT * FROM Students WHERE FirstName = :FirstName`
    * Set the [`OracleCommand.BindByName`](https://docs.oracle.com/database/121/ODPNT/OracleCommandClass.htm#DAFCJDDG) to `true` in order to bind by name; otherwise parameters will be bound by position.
* [SQLite](https://www.sqlite.org/lang_expr.html#varparam)
    * Positional:
        * `SELECT * FROM Students WHERE FirstName = ?0 OR FirstName = ?1`
        * `SELECT * FROM Students WHERE FirstName = ?`
    * Named:
        * `SELECT * FROM Students WHERE FirstName = :FirstName`
        * `SELECT * FROM Students WHERE FirstName = @FirstName`
        * `SELECT * FROM Students WHERE FirstName = $FirstName`
* [PostgreSQL (npgsl)](http://www.npgsql.org/doc/basic-usage.html#parameters) ([other link](https://github.com/npgsql/npgsql/issues/825))
    * Positional:
        * `SELECT * FROM Students WHERE FirstName = $0 OR FirstName = $1`
    * Named:
        * `SELECT * FROM Students WHERE FirstName = :FirstName`
        * `SELECT * FROM Students WHERE FirstName = @FirstName`

Examples
===

## Reading from a data reader

* **Language**: IronPython
* **Provider**: SQLite
* **`import`s**: `from System.Data import DbType`; `from System.Data.SQLite import SQLiteCommand`

```python
# Note that Python has a built-in module for working with SQLite databases

# conn refers to an open instance of SQLiteConnection

cmd = SQLiteCommand()
cmd.Connection = conn

# SQLite supports multiple placeholder syntaxes, including @name syntax
cmd.CommandText = "SELECT * FROM Students WHERE FirstName = @FirstName"
prm = cmd.Parameters.Add("FirstName", DbType.String)
prm.Value = "Robert' OR 1=1; --"
with cmd.ExecuteReader() as reader:
    while reader.Read():
        print("Last name: %s, first name: %s" %(reader["LastName"], reader["FirstName"]))
```

**Note on `with`**: Objects which might hold onto resources (e.g. memory, or open database connections) need to be
explicitly notified to release those resources. Objects indicate this by implementing the `IDisposable` interface. In
IronPython, wrapping the use of those objects in a `with` block will call the `IDisposable.Dispose` method once the
block exits; the C# `using` keyword, the VB.NET `Using` keyword, and the F# `use` and `using` idioms all provide
similar functionality.

## Returning a single value

* **Language**: VB.NET
* **Provider**: OLE DB
* **`Imports`**: System.Data.OleDb

```vb
' conn refers to an open instance of OleDbConnection

Dim cmd = New OleDbCommand() With {
    .Connection = conn,
    .CommandText = "SELECT COUNT(*) FROM Students WHERE FirstName <> ?"
}
Dim prm = cmd.Parameters.Add("StudentName", OleDbType.VarWChar)
prm.Value = "Robert' OR 1=1; --"
Console.WriteLine($"Number of students not named `Robert' OR 1=1; --`: {cmd.ExecuteScalar}")
```

## Executing without returning  a value

* **Language**: Powershell
* **Provider**: SQL Server

```powershell
# $conn refers to an open instance of SqlConnection

$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.Connection = $conn
$cmd.CommandText = "DELETE FROM Students WHERE FirstName = @FirstName"
$nvarchar = [System.Data.SqlDbType]::NVarChar
$prm = $cmd.Parameters.Add("FirstName", $nvarchar)
$prm.Value = "Robert' OR 1=1; --"
$cmd.ExecuteNonQuery
```

## Fillling a dataset

* **Language**: F#
* **Provider**: MySQL
* **`open`**: System.Data, MySql.Data.MySqlClient (**NuGet**: `MySql.Data`)

```fsharp
// conn refers to an open instance of MySQLConnection

// Note that the placeholder syntax for MySQL is @name
let sql = "SELECT * FROM Students WHERE FirstName = @FirstName"

// The SQL passed into the constructor of a DataAdapter becomes the CommandText
// for the command at the SelectCommand property
use adapter = new MySqlDataAdapter(sql, conn)
let prm = adapter.SelectCommand.Parameters.Add("FirstName", MySqlDbType.VarChar)
prm.Value <- "Robert' OR 1=1; --"
let students = new DataSet()
adapter.Fill(students, "Students")
```

**Note on `use`**: This is one of two
[F# idioms for working with `IDisposable`](https://docs.microsoft.com/en-us/dotnet/fsharp/language-reference/resource-management-the-use-keyword).
See the note on IronPython's use of `with` in the first example for more details.

References
==
[Microsoft documentation on ADO.NET](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/)
