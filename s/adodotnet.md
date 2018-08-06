> TL;DR
> ===
> To avoid SQL injection in ADO<i></i>.NET, do the following:
>
> 1. use placeholders for values in the SQL of a command
> 2. add **parameters** to the command
> 3. set the value of the parameters (generally, via the `Value` property)

Overview
===

From the [docs](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-overview):

> ADO<i></i>.NET provides the most direct method of data access within the .NET Framework.

The basic functionality used by ADO<i></i>.NET to connect to databases and other data sources is defined in a set of `abstract` (`MustInherit` in VB<i></i>.NET) classes in the [`System.Data.Common`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common) namespace. Implementors of this functionality for specific data sources are called ADO<i></i>.NET [**data providers**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers), and consist of classes that inherit from these base classes. For example, the ADO<i></i>.NET data provider for connecting to SQL Server contains the following classes::

| This class in the [`System.Data.SqlCient`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient) namespace | Inherits from this class in the [`System.Data.Common`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common) namespace |
| --- | --- |
| [`SqlConnection`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlconnection) | [`DbConnection`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbconnection) |
| [`SqlCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlcommand) | [`DbCommand`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbcommand) |
| [`SqlParameter`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlparameter) | [`DbParameter`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbparameter) |
| [`SqlDataReader`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldatareader) | [`DbDataReader`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdatareader)|
| [`SqlDataAdapter`](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqldataadapter) | [`DbDataAdapter`](https://docs.microsoft.com/en-us/dotnet/api/system.data.common.dbdataadapter) |

This shared architecture  means that there is a common strategy for avoiding SQL injection across all data providers.

There are a number of [data providers built-in to the .NET Framework](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers), for:

* [SQL Server](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-sql-server-sqlclient)
* [OLE DB data sources](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-ole-db) -- Access, Excel, text files, and others
* [ODBC data sources](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-odbc)
* [Entity Framework Models](https://msdn.microsoft.com/library/49202ab9-ac98-4b4b-a05c-140e422bf527)
* [SQL Server Compact Edition](https://msdn.microsoft.com/library/system.data.sqlserverce.aspx)
* [Oracle](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers#net-framework-data-provider-for-oracle) (deprecated; use [ODP](https://www.oracle.com/technetwork/topics/dotnet/index-085163.html))

and there are a number of third-party providers for other data sources, for example: [SQLite](https://system.data.sqlite.org/index.html/doc/trunk/www/index.wiki), [MySQL](https://dev.mysql.com/downloads/connector/net/6.10.html), [Firebird](https://firebirdsql.org/en/net-provider/) and others.


Using ADO<i></i>.NET without SQL Injection
===

In ADO<i></i>.NET, you specify [**commands**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/commands-and-parameters) to execute against the data source, via an open [**connection**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/connecting-to-a-data-source). Commands consist of a string (read/written via the command's [`CommandText`](https://docs.microsoft.com/en-us/dotnet/api/system.data.idbcommand.commandtext?view=netframework-4.7.2#System_Data_IDbCommand_CommandText) property), along with other properties. This string can contain an SQL statement (it may also contain, a table name, a view name, or some other string understood by the data source).

 A command can:

* [execute without returning results](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/using-commands-to-modify-data)
* [return a single result](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/obtaining-a-single-value-from-a-database)
* [return a **data reader**](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/retrieving-data-using-a-datareader), which allows reading a result set row by row in a forward-only direction

[**Data adapters**]() make use of commands to fill **data sets** -- an in-memory representation of the data independent of any specific RDBMS -- and to manage the synchronization of data changes between the data set and the original data source.


To avoid SQL injection in ADO<i></i>.NET, do the following:

1. use placeholders for values in the SQL of the command, and
2. add **parameters** to the command
3. set the value of the parameter (generally, via the `Value` property)

Note that the syntax for SQL placeholders can vary between providers:

| Built-in provider | Placeholder syntax |
| --- | --- |
| SQL Server, Entity SQL | `SELECT * FROM Students WHERE FirstName = @FirstName`
| OLE DB, ODBC | `SELECT * FROM Students WHERE FirstName = ?`
| Oracle | `SELECT * FROM Students WHERE FirstName = :FirstName`

Example -- C#, SQL Server, Data reader
===
```
// conn refers to an open instance of SqlConnection

var cmd = new SqlCommand() {
    Connection = conn,
    CommandText = "SELECT * FROM Students WHERE FirstName = @FirstName"
};
var prm = cmd.Parameters.Add("StudentName", SqlDbType.NVarChar);
prm.Value = "Robert' OR 1=1; --"
using (var rdr = cmd.ExecuteReader()) {
    while (rdr.MoveNext()) {
        Console.WriteLine($"Last name: {rdr["LastName"]}, first name: {rdr["FirstName"]});
    }
}

```
**Note on `using`**: Objects which might hold onto resources (e.g. memory, or open database connections) need to be explicitly notified to release those resources. For objects that implement the `IDisposable` interface, the `using` block will call `Dispose` once the block exits.

Example -- VB<i></i>.NET, Excel file, return a single value
===
```
' conn refers to an open instance of OleDbConnection

Dim cmd = New OleDbCommand() With {
    .Connection = conn,
    .CommandText = "SELECT COUNT(*) FROM Students WHERE FirstName <> ?"
}
Dim prm = cmd.Parameters.Add("StudentName", OleDbType.VarWChar)
prm.Value = "Robert' OR 1=1; --"
Console.WriteLine($"Number of students not named `Robert' OR 1=1; --`: {cmd.ExecuteScalar}")
```

Todo:

Additional information on data adapter parameters
Example using data adapter and dataset  
Examples in F#, IronPython  
Examples using third-party data providers  
Test code examples; use examples that are liable to SQL injection (does OLEDB SQL support `--` comments?)  
Inline references  
List of references (
    [SQL Injection and how to avoid it](http://blogs.msdn.com/tom/archive/2008/05/29/sql-injection-and-how-to-avoid-it.aspx) on the ASP.NET Debugging blog
)