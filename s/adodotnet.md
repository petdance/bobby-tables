> To avoid SQL injection in ADO.NET, do not use user input to build the SQL for commands. Instead, do the following:
>
> 1. use placeholders for values in the SQL of the command,
> 2. add [**parameters**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/commands-and-parameters) to the command, and
> 3. set the value of the parameter (generally, via the `Value` property)
>
> Example in C#, against SQL Server:
>
> ```csharp
> // conn refers to an open instance of SqlConnection
>
> var cmd = new SqlCommand() {
>    Connection = conn,
>    CommandText = "SELECT * FROM Students WHERE FirstName = @FirstName"
> };
> var prm = cmd.Parameters.Add("StudentName", SqlDbType.NVarChar);
> prm.Value = "Robert'; DROP TABLE Students; --";
> ```

ADO.NET architecture
===

From the [docs](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-overview):

> ADO.NET provides the most direct method of data access within the .NET Framework.

The basic functionality used by ADO.NET to connect to databases and other data sources is defined in a set of `abstract` (`MustInherit` in VB.NET) classes in the [`System.Data.Common`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common) namespace. Implementors of this functionality for specific data sources are called ADO.NET [**data providers**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers), and consist of classes that inherit from these base classes. For example, the ADO.NET data provider for connecting to SQL Server contains the following classes::

| This class in the [`System.Data.SqlCient`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient) namespace | Inherits from this class in the [`System.Data.Common`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common) namespace |
| --- | --- |
| [`SqlConnection`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlconnection) | [`DbConnection`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbconnection) |
| [`SqlCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlcommand) | [`DbCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbcommand) |
| [`SqlParameter`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlparameter) | [`DbParameter`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbparameter) |
| [`SqlDataReader`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldatareader) | [`DbDataReader`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdatareader)|
| [`SqlDataAdapter`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldataadapter) | [`DbDataAdapter`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter) |

There are a number of [data providers built-in to the .NET Framework](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers), for:

* [SQL Server](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-sql-server-sqlclient)
* [OLE DB data sources](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-ole-db) -- Access, Excel, text files, and others
* [ODBC data sources](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-odbc)
* [Entity Framework Models](https://msdn.microsoft.com/library/49202ab9-ac98-4b4b-a05c-140e422bf527)
* [SQL Server Compact Edition](https://msdn.microsoft.com/library/system.data.sqlserverce.aspx)
* [Oracle](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-oracle) (deprecated; use [ODP](https://www.oracle.com/technetwork/topics/dotnet/index-085163.html))

and there are a number of third-party providers for other data sources, for example: [SQLite](https://system.data.sqlite.org/index.html/doc/trunk/www/index.wiki), [MySQL](https://dev.mysql.com/downloads/connector/net), [Firebird](https://firebirdsql.org/en/net-provider/) and others.

The shared architecture across providers means that **there is a single common strategy for avoiding SQL injection for all ADO.NET data providers, in all .NET languages.**

Commands and their uses
===

In ADO.NET, you specify [**commands**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/commands-and-parameters) to execute against the data source, via an open [**connection**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/connecting-to-a-data-source). Commands consist of a string (read/written via the command's [`CommandText`](https://docs.microsoft.com/en-us/dotnet/api/system.data.idbcommand.commandtext?view=netframework-4.7.2#System_Data_IDbCommand_CommandText) property), along with other properties. This string can be an SQL statement (it may also contain, a table name, a view name, or some other string understood by the data source); this SQL statement is the primary vector for SQL injection.

 A command can:

* [execute without returning results](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/using-commands-to-modify-data)
* [return a single result](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/obtaining-a-single-value-from-a-database)
* [return a **data reader**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/retrieving-data-using-a-datareader), which allows reading a result set row by row in a forward-only direction

There is a higher level of abstraction built into ADO.NET: using a [**data set**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-datasets) -- an in-memory representation of the data independent of any specific data source or data provider. [**Data adapters**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/populating-a-dataset-from-a-dataadapter) are the bridge between the data source and a data set. Internally, the data adapter makes use of commands in two ways:

1. When [filling the data set with data](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/populating-a-dataset-from-a-dataadapter), the commmand at the data adapter's [`SelectCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter.selectcommand) property is used,
2. When [synchronizing data changes between the data set and the data source](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/updating-data-sources-with-dataadapters), the commands at the [`InsertCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter.insertcommand), [`UpdateCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter.updatecommand), and [`DeleteCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter.deletecommand) properties of the data adapter are used.

These commands are also liable to be vulnerable to SQL injection.

Avoiding SQL injection in commands
==

To avoid SQL injection in ADO.NET, do not use user input to build the SQL for commands. Instead, do the following:

1. use placeholders for values in the SQL of the command,
2. add [**parameters**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/commands-and-parameters) to the command, and
3. set the value of the parameter (generally, via the `Value` property)

Note that the syntax for SQL placeholders can vary between providers:

| Built-in provider | Placeholder syntax |
| --- | --- |
| SQL Server, Entity SQL | `SELECT * FROM Students WHERE FirstName = @FirstName`
| OLE DB, ODBC | `SELECT * FROM Students WHERE FirstName = ?`
| Oracle | `SELECT * FROM Students WHERE FirstName = :FirstName`

Example -- Data reader
===
* **Language**: C#
* **Provider**: SQL Server
* **`using`s**: System.Data, System.Data.SqlClient
```csharp
// conn refers to an open instance of SqlConnection

var cmd = new SqlCommand() {
    Connection = conn,
    CommandText = "SELECT * FROM Students WHERE FirstName = @FirstName"
};
var prm = cmd.Parameters.Add("StudentName", SqlDbType.NVarChar);
prm.Value = "Robert' OR 1=1; --";
using (var rdr = cmd.ExecuteReader()) {
    while (rdr.Read()) {
        Console.WriteLine($"Last name: {rdr["LastName"]}, first name: {rdr["FirstName"]}");
    }
}
```
**Note on `using`**: Objects which might hold onto resources (e.g. memory, or open database connections) need to be explicitly notified to release those resources. Objects indicate this by implementing the `IDisposable` interface. Wrapping the use of those objects in a `using` block will call the `IDisposable.Dispose` method once the block exits.

Example -- Return a single value
===
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

Example -- No return value
==
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

Example -- Filll a dataset
==
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

**Note on `use`**: This is one of two [F# idioms for working with `IDisposable`](https://docs.microsoft.com/en-us/dotnet/fsharp/language-reference/resource-management-the-use-keyword). See the note on C#'s `using` keyword in the first example for more details.

References
==
* [Microsoft documentation on ADO.NET](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/)
---



Todo:

Fixing SQL injection in data adapter commands  
Example: IronPython, SQLite, sync datatable  (note about Python `sqlite` module, also available from IronPython)  
Open issue: verify F# information on page with F# expert  
Open issue: F# SQL injection outside of ADO.NET data provider commands