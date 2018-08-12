Entity Framework
===
Entity Framework is Microsoft's primary ORM (object-relational mapper) built on top of ADO.NET.

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
However, there are a number of places where EF allows writing raw SQL statements, and if parameters are not used, they are liable to be vulnerable to SQL injection:

* [DBSet.SqlQuery](https://msdn.microsoft.com/en-us/library/system.data.entity.dbset.sqlquery(v=vs.113).aspx) / [DBSet\<TEntity>.SqlQuery](https://msdn.microsoft.com/en-us/library/mt136652(v=vs.113).aspx)
* [Database.SqlQuery / Database.SqlQuery\<TEntity>](https://msdn.microsoft.com/en-us/library/system.data.entity.database.sqlquery(v=vs.113).aspx)
* [Database.ExecuteSqlCommand](https://msdn.microsoft.com/en-us/library/system.data.entity.database.executesqlcommand(v=vs.113).aspx)

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
then you can pass in instances of provider-specific parameters:
```vb
'ctx refers to an instance of a context class

Dim sql = "SELECT * FROM Students WHERE FirstName = @p0"
Dim prm = New SqlParameter("@firstname", SqlDbType.NVarChar)
prm.Value = "Robert'; DROP TABLE Students; --"
Dim qry = ctx.Students.SqlQuery(sql, prm) 
```
