Entity Framework
===

Entity Framework is Microsoft's primary ORM (object-relational mapper) built on top of ADO.NET. There are currently two versions in use:

* Entity Framework 6, for .NET Framework
* Entity Framework Core, for .NET Core

In general, Entity Framework converts expression-based queries:

```csharp
// C# example
using (var ctx = new SchoolContext()) {
    var firstname = "Robert'; DROP TABLE Students; --";
    IQueryable<Student> qry = ctx.Students.Where(x => x.FirstName == firstname);
}
```

to queries with parameters:

```SQL
-- SQL Server named parameter syntax
SELECT * FROM Students WHERE FirstName = @firstname
```

However, there are a number of places where EF allows writing raw SQL statements, and if parameters are not used, they
are liable to be vulnerable to SQL injection:

EF6:

* [DBSet.SqlQuery](https://msdn.microsoft.com/en-us/library/system.data.entity.dbset.sqlquery(v=vs.113).aspx) / [DBSet\<TEntity>.SqlQuery](https://msdn.microsoft.com/en-us/library/mt136652(v=vs.113).aspx)
* [Database.SqlQuery / Database.SqlQuery\<TEntity>](https://msdn.microsoft.com/en-us/library/system.data.entity.database.sqlquery(v=vs.113).aspx)
* [Database.ExecuteSqlCommand](https://msdn.microsoft.com/en-us/library/system.data.entity.database.executesqlcommand(v=vs.113).aspx)

EF Core:

* [FromSql](https://docs.microsoft.com/en-us/dotnet/api/microsoft.entityframeworkcore.relationalqueryableextensions.fromsql)

In order to use parameters with any of these methods:

1. modify the SQL to use placeholders with auto-generated names: `@p0`, `p1`, `p2` etc.
2. pass the parameter values after the SQL

```vb
'ctx refers to an instance of a context class

Dim firstname = "Robert'; DROP TABLE Students; --"
Dim sql = "SELECT * FROM Students WHERE FirstName = @p0"
Dim qry = ctx.Students.SqlQuery(sql, firstname) 
```

Alternatively, if you want to use named parameters in your SQL:

```sql
SELECT * FROM Students WHERE FirstName = @firstname
```

then you can pass in instances of the provider-specific parameter class:

```vb
'ctx refers to an instance of a context class

Dim sql = "SELECT * FROM Students WHERE FirstName = @p0"
Dim prm = New SqlParameter("@firstname", SqlDbType.NVarChar)
prm.Value = "Robert'; DROP TABLE Students; --"
Dim qry = ctx.Students.SqlQuery(sql, prm) 
```

The above applies to both EF6 and EF Core. EF Core also allows passing the SQL as a format string together with the
parameter values; format placeholders will be converted to parameters with the corresponding values:

```
// ctx refers to an instance of a context class

var firstname = "Robert'; DROP TABLE Students; --";
var qry = ctx.Students.FromSql("SELECT * FROM Students WHERE {0}", firstname);
```

As of EF Core 2.0, EF Core also supports using interpolated strings; the interpolated strings will be converted to
parameters:

```
// ctx refers to an instance of a context class

var firstname = "Robert'; DROP TABLE Students; --";
var qry = ctx.Students.FromSql("SELECT * FROM Students WHERE {firstname}");
```

References
===

* [Entity Framework Raw SQL Queries](https://msdn.microsoft.com/en-us/library/jj592907(v=vs.113).aspx)
* [Raw SQL](https://docs.microsoft.com/en-us/ef/core/querying/raw-sql) for EF Core
