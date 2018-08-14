# Dapper

Dapper is one of several micro-ORMs (Object Relational Mappers) available
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

# LINQ to SQL

Todo
