ColdFusion
==========

In ColdFusion there is a tag called <code>cfqueryparam</code> that should be used whenever writing inline queries.

    <cfquery name="queryTest">
    SELECT FirstName, LastName, Phone
    FROM   tblUser
    WHERE  Status =
      <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.status#">
    </cfquery>


Stored procedures can be invoked with the <code>cfstoredproc</code> and <code>cfprocparam</code> tags.

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

