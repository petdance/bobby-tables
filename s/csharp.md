C\#
===

Various vendors provide an ADO.NET Data Provider that can be used to
connect to different RDBMS systems. ADO.NET is the built-in connection
framework for .NET for connecting to databases, and is found in the
[System.Data](https://msdn.microsoft.com/en-us/library/system.data(v=vs.110).aspx)
namespace.

ADO.NET data providers have various types that implement the
[IDisposable](https://msdn.microsoft.com/en-us/library/system.idisposable(v=vs.110).aspx)
interface. The proper way to use these types is to wrap them in a
`using` statement upon creation, or to call `.Dispose()` on them within
a `finally` block. This ensures that the connection will be cleaned up
properly. If the correct IDisposable patterns are not used, it can lead
to connection exhaustion errors that are difficult to debug.

# ADO.NET SQL Server

The System.Data.SqlClient class ships with .NET Framework, and is used
to connect to Microsoft SQL Server databases. Parameters are specified
in the query/command with an ampersand. When adding the parameters
to the command, it's reccomended to use the method that allows for
specifying the data type and size, as shown in the example below. There
is a method that allows you to not specify the data type and size,
[AddWithValue](https://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlparametercollection.addwithvalue(v=vs.110).aspx).
But that method is [not reccomended for use](https://blogs.msmvps.com/jcoehoorn/blog/2014/05/12/can-we-stop-using-addwithvalue-already/).

    using (SqlConnection connection = new SqlConnection(connectionString))
    using (SqlCommand command = new SqlCommand("SELECT id, name, email FROM users WHERE id = @UserName", connection))
    {
        // Specify the data type and the data size, if applicable
        // userName is some user provided string value
        command.Parameters.Add("@UserName", SqlDbType.VarChar, 25).Value = userName;

        connection.Open();
        // now you can execute the command here
    }

# ADO.NET Oracle

There is a Oracle client built into the .NET Framework, in the
[System.Data.OracleClient](https://msdn.microsoft.com/en-us/library/system.data.oracleclient(v=vs.110).aspx)
namespace. However, it is deprecated and should no longer be used. Instead, the
[managed Oracle Driver](https://www.nuget.org/packages/Oracle.ManagedDataAccess/)
provided by Oracle is reccomended. It is written in .NET code and
requires no external dependencies. Parameters are specified with a
colon character. By default, parameters are bound by index instead of
by name. This can be changed to bind by name by setting the BindByName
property of the command being executed.

    using (OracleConnection connection = new OracleConnection(connectionString))
    using (OracleCommand command = new OracleCommand("SELECT id, name, email, status, region FROM users WHERE status = :Status and region = :Region", connection))
    {
        // By default Oracle binds by position index instead of name.
        // So we'll explicitly tell it to bind by name.
        command.BindByName = true;

        // Provide the data type and data size, if applicable
        // userStatus and userRegion are some user provided input string variables
        command.Parameters.Add(":Status", OracleDbType.Varchar2, 25).Value = userStatus;
        command.Parameters.Add(":Region", OracleDbType.Int32).Value = userRegion;

        connection.Open();
        // now you can execute the command here
    }

# Dapper

Dapper is one of several micro-ORM's (Object Relational Mappers) available
for .NET. It provides a set of extension methods for ADO.NET types that
makes it easier to query data and convert the results into a strongly
typed object. Parameter values are passed in via an anonymous object. It
works with any ADO.NET Data Provider since it extends the base types
in the `System.Data` namespace. Use the correct symbol (ampersands for
SqlCommand and colons for OracleCommand) for the database being used.

    using (SqlConnection connection = new SqlConnection(connectionString))
    {
        List<User> users = connection.Query<Users>("SELECT id, name, email, status, region FROM users WHERE status = @Status and region = @Region",
            new { Status = userStatus, Region = userRegion })
            .AsList();
    }
