R
=

R has separate interfaces for different databases, with different capabilities
for each. [RSQLite](https://cran.r-project.org/web/packages/RSQLite/) 
supports parameterized.

    con <- dbConnect(SQLite(), ":memory:")
    # Use dbSendPreparedQuery/dbGetPreparedQuery for "prepared" queries
    dbGetPreparedQuery(con, "SELECT * FROM arrests WHERE Murder < ?",
        data.frame(x = 3))
    dbDisconnect(con)

But other interfaces, such as [RMySQL](https://cran.r-project.org/web/packages/RMySQL/) 
do not allow parameterizations.

The database drivers for R are in process of being brought together under 
[DBI](https://cran.r-project.org/web/packages/DBI/), so it is possible this will change
in the future.
