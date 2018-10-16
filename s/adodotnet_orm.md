# Dapper

[Dapper](https://github.com/StackExchange/Dapper) is one of several micro-ORMs (Object Relational Mappers) available
for .NET. It provides a set of extension methods for ADO.NET types that
makes it easier to query data and convert the results into a strongly
typed object. These extension methods work with any ADO.NET data provider.

As in ADO.NET, placeholders are specified within the SQL, using the
[provider and data source syntax for placeholders](adodotnet#placeholder-syntax).
The SQL is then passed to the `Query<T>` extension method, along with an anonymous type with the names and values of
the parameters:

```csharp
// example in C#, connecting to SQL Server
// conn is an instance of SqlConnection
var sql = "SELECT * FROM Students WHERE FirstName = @firstname";
List<Student> students = conn.Query<Users>(
        sql,
        new { firstname = "Robert'; DROP TABLE Students; --" }
    )
    .AsList();
```

For providers which don't support named parameters, use `?placeholder_name?` as the placeholder in the SQL. Dapper will
replace this placeholder with the normal placeholder, and add parameters and values from the anonymous object in the
appropriate order:

```vb
' example in VB.NET, connecting to OLE DB, which doesn't support named placeholders
' conn is an instance of OleDbConnection
Dim sql = "SELECT * FROM Students WHERE FirstName = ?firstname?"
Dim students As List(Of Students) = 
    conn.Query(Of Students)(sql, New With {.firstname = "Robert'; DROP TABLE Students; --" }).AsList
```
