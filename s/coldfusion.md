ColdFusion
==========

In ColdFusion there is a tag called `cfqueryparam` that should be used whenever writing inline queries.

    <cfquery name="queryTest">
    SELECT FirstName, LastName, Phone
    FROM   tblUser
    WHERE  Status =
      <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.status#">
    </cfquery>


Stored procedures can be invoked with the `cfstoredproc` and `cfprocparam` tags.

Recent versions of ColdFusion provide a set of functions to run queries that
have a slightly different syntax, but still provide parameterized queries.


    <cfscript>
      var myQuery = new Query(sql="
        SELECT FirstName, LastName, Phone
        FROM   tblUser
        WHERE  Status = :status
      ");
      myQuery.addParam(
        name      = "status",
        value     = form.status,
        cfsqltype = "cf_sql_varchar"
      );
      var rawQuery = myQuery.execute().getResult();
    </cfscript>

ColdFusion 11 added the `queryExecute` function which also provides a way to paramertize queries:

    queryExecute("SELECT FirstName, LastName, Phone FROM tblUser WHERE Status = :Status", {status=form.status});

Alternative script syntaxes include:

    <cfscript>
      query name="myQuery" {
        echo("
          SELECT FirstName, LastName, Phone
          FROM   tblUser
          WHERE  Status
        ");
        queryparam sqltype="varchar" value="#form.status#";
      }
    </cfscript>

And as of Railo 4.2.1, queryExecute allows both named parameters and positional parameters:

    <cfscript>
      // Named
      myQuery = queryExecute(
        "SELECT FirstName, LastName, Phone
        FROM   tblUser
        WHERE  Status = :status",
        {status = {value = form.status, sqltype="varchar"}}
      );

      // Positional
      myQuery = queryExecute(
        "SELECT FirstName, LastName, Phone
        FROM   tblUser
        WHERE  Status = ?",
        [{value = form.status, sqltype="varchar"}]
      );
    </cfscript>
