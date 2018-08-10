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

* DBSet.SqlQuery
* Database.SqlQuery
* Database.ExecuteSqlCommand

---
Todo:  
provide examples for each method
