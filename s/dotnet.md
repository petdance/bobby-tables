.NET
====

Use the SqlCommand object to specify and add parameters.

    using System.Data.SqlClient;

    var connection = new SqlConnection("[connection string]");
    connection.Open();
    
    // Anything prefaced with "@" is a parameter which can be added and resolved later
    var command = new SqlCommand("SELECT * FROM table WHERE field = @value")
    {
      Connection = connection();
    };
    
    // Resolve the parameter by giving it the actual value to use...
    command.Parameters.AddWithValue("value", "the actual value");
    var dataReader = command.ExecuteReader();

Reference:

-    [SqlCommand.Prepare](http://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlcommand.prepare.aspx) in the .NET Framework Class Library

Articles:

-   [SQL injection](http://msdn.microsoft.com/en-us/library/ms161953.aspx) on MSDN
-   [SQL Injection and how to avoid it](http://blogs.msdn.com/tom/archive/2008/05/29/sql-injection-and-how-to-avoid-it.aspx) on the ASP.NET Debugging blog

To do
-----

-   Add some narrative
-   Show code examples
