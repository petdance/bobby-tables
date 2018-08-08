> To avoid SQL injection in ADO.NET, do the following:
>
> 1. use placeholders for values in the SQL of a command
> 2. add **parameters** to the command
> 3. set the value of the parameters (generally, via the `Value` property)
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

ADO.NET Architecture
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

and there are a number of third-party providers for other data sources, for example: [SQLite](https://system.data.sqlite.org/index.html/doc/trunk/www/index.wiki), [MySQL](https://dev.mysql.com/downloads/connector/net/6.10.html), [Firebird](https://firebirdsql.org/en/net-provider/) and others.

The shared architecture across providers means that **there is a single common strategy for avoiding SQL injection for all data providers, in all .NET languages.**

Commands and their uses
===

In ADO.NET, you specify [**commands**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/commands-and-parameters) to execute against the data source, via an open [**connection**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/connecting-to-a-data-source). Commands consist of a string (read/written via the command's [`CommandText`](https://docs.microsoft.com/en-us/dotnet/api/system.data.idbcommand.commandtext?view=netframework-4.7.2#System_Data_IDbCommand_CommandText) property), along with other properties. This string can be an SQL statement (it may also contain, a table name, a view name, or some other string understood by the data source); this SQL statement is the primary vector for SQL injection.

 A command can:

* [execute without returning results](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/using-commands-to-modify-data)
* [return a single result](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/obtaining-a-single-value-from-a-database)
* [return a **data reader**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/retrieving-data-using-a-datareader), which allows reading a result set row by row in a forward-only direction

There is a higher level of abstraction built into ADO.NET: using a [**data set**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-datasets) -- an in-memory representation of the data independent of any specific data source or data provider. [**Data adapters**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/populating-a-dataset-from-a-dataadapter) are the bridge between the data source and a data set. The data adapter makes use of commands in two ways:

1. Fill the data set with data, using `SelectCommand`,
2. Synchronize data changes between the data set and the data source, using `InsertCommand`, `UpdateCommand`, and `DeleteCommand`.

These commands are also liable to be vulnerable to SQL injection.

Avoiding SQL injection in commands
==

To avoid SQL injection in ADO.NET, do not use user input to build the SQL for commands. Instead, do the following:

1. use placeholders for values in the SQL of the command, and
2. add **parameters** to the command
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
**Note on `using`**: Objects which might hold onto resources (e.g. memory, or open database connections) need to be explicitly notified to release those resources. Objects indicate this by implementing the `IDisposable` interface; and wrapping the use of those objects in a `using` block will call the `IDisposable.Dispose` method once the block exits.

Example -- Return a single value
===
* **Language**: VB.NET
* **Provider**: OLE DB
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

**Note on `Using`**: see note on `using` in the previous example.

Example -- No return value
==
* **Language**: F#
* **Provider**: SQLite
```fsharp
let cmd = new SQLiteCommand(Connection=conn, CommandText="DELETE FROM Students WHERE FirstName = :FirstName")
let prm = cmd.Parameters.Add("FirstName", DbType.String)
prm.Value <- "Robert' OR 1=1; =="
cmd.ExecuteNonQuery()
```

Todo:

Fixing SQL injection in data adapter commands  
Example using data adapter and dataset  
Examples in IronPython  
Examples using third-party data providers  
Test code examples; use examples that are liable to SQL injection (does OLEDB SQL support `--` comments?)  
Inline references  
List of references (
    [SQL Injection and how to avoid it](http://blogs.msdn.com/tom/archive/2008/05/29/sql-injection-and-how-to-avoid-it.aspx) on the ASP.NET Debugging blog
)
Open issue: verify F# information on page with F# expert
Open issue: F# SQL injection outside of ADO.NET data provider commands