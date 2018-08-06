Overview
===

From the [docs](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-overview):

> ADO<i></i>.NET provides the most direct method of data access within the .NET Framework.

The basic functionality used by ADO<i></i>.NET to connect to databases and other data sources is defined in a set of `abstract` (`MustInherit` in VB<i></i>.NET) classes, in the  `System.Data.Common` namspace. Implementors of this functionality for specific data sources are called ADO<i></i>.NET **data providers**, and consist of classes that inherit from these base classes. For example, the ADO<i></i>.NET data provider for connecting to SQL Server contains the following classes::

| `System.Data.SqlCient` namespace | Inherits from this in the `System.Data.Common` namespace |
| --- | --- |
| `SqlConnection` | `DbConnection` |
| `SqlCommand` | `DbCommand` |
| `SqlParameter` | `DbParameter` |
| `SqlDataReader` | `DbDataReader`|
| `SqlDataAdapter` | `DbDataAdapter` |

There are a number of providers built-in to the .NET Framework:

| For | Namespace | Notes |
| --- | --- | --- |
| SQL Server | `System.Data.SqlClient` |
| OLE DB data sources | `System.Data.OleDb` |  Access, Excel, text files, and others |
| ODBC data sources | `System.Data.Odbc` |
| Entity Framework models | `System.Data.EntityClient` |
| SQL Server Compact Edition | `System.Data.SqlServerCe` |
| Oracle | `System.Data.OracleClient` | Deprecated; use [ODP](https://www.oracle.com/technetwork/topics/dotnet/index-085163.html)

and there are a number of third-party providers for other data sources, for example: [SQLite](https://system.data.sqlite.org/index.html/doc/trunk/www/index.wiki), [MySQL](https://dev.mysql.com/downloads/connector/net/6.10.html), [Firebird](https://firebirdsql.org/en/net-provider/) and others.

Using ADO<i></i>.NET
===

In ADO<i></i>.NET, you specify **commands** to execute against the database, via an open **connection**. A command can:

* execute without returning results
* return a single result
* return a **data reader**, which allows reading a result set row by row in a forward-only direction

**Data adapters** make use of commands to fill **data sets** -- an in-memory representation of the data independent of any specific RDBMS -- and to manage the synchronization of data changes between the data set and the original data source.

Commands consist of a string (read/written via the command's `CommandText` property), along with other properties. This string can contain an SQL statement (it may also contain, a table name, a view name, or some other string understood by the data source).

To avoid SQL injection in ADO<i></i>.NET, do the following:

1. use placeholders for values in the SQL of the command, and
2. add **parameters** to the command

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

Example using data adapter and dataset  
Examples in F#, IronPython  
Examples using third-party data providers  
Test code examples; use examples that are liable to SQL injection (does OLEDB SQL support `--` comments?)  
Inline references  
List of references (
    [SQL Injection and how to avoid it](http://blogs.msdn.com/tom/archive/2008/05/29/sql-injection-and-how-to-avoid-it.aspx) on the ASP.NET Debugging blog
)