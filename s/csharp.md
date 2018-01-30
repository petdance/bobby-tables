C\#
===

ADO.NET SQL Server

    using (SqlConnection connection = new SqlConnection(connectionString))
    using (SqlCommand command = new SqlCommand("SELECT id, name, email FROM users WHERE id = @UserName", connection))
    {
        // Specify the data type and the data size, if applicable
        // userName is some user provided string value
        command.Parameters.Add("@UserName", SqlDbType.VarChar, 25).Value = userName;

        connection.Open();
        // now you can execute the command here
    }

ADO.NET Oracle

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

Dapper

    using (SqlConnection = new SqlConnection(connectionString))
    {
        List<User> users = connection.Query<Users>("SELECT id, name, email, status, region FROM users WHERE status = :Status and region = :Region",
            new { Status = userStatus, Region = userRegion })
            .AsList();
    }
