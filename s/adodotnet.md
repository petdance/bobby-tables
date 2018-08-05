Overview of ADO.NET architechture
=============================

From the [docs](https://docs.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-overview):

> ADO.NET provides the most direct method of data access within the .NET Framework.

In ADO.NET, you define **commands** to execute against the database, via an open **connection**. A command can:

* execute without returning results
* return a single result
* return a **data reader**, which allows a single pass through a result set

**Data adapters** make use of commands to fill **data sets** -- an in-memory representation of the data independent of any specific RDBMS -- and to manage the synchronization of data changes between the data set and the original data source.

Commands consist of a string (read/written via the `CommandText` property), along with other properties. This string can contain an SQL statement (it may also contain, a table name, a view name, or some other string understood by the data source).

To avoid SQL injection in ADO.NET, do the following:

1.  use placeholders in the SQL of the command, and
2. add **parameters** to the command

---

ADO.NET providers:  
base abstract classes  
table of per-provider class  
third-party providers: MySQL, PostGr8SQL, Sqlite, Oracle  
note about `using`  
examples -- C#, VB.NET, F#, IronPython  
examples -- SqlServer, OleDB, PostGr8SQL, MySQL