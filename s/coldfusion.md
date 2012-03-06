h1. ColdFusion

In ColdFusion there is a tag called @cfqueryparam@ that should be used whenever writing inline queries.

<code>
&lt;cfquery name="queryTest">
SELECT FirstName, LastName, Phone
FROM   tblUser
WHERE  Status =
    &lt;cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.status#">
&lt;/cfquery>
</code>

Stored procedures can be invoked with the @cfstoredproc@ and @cfprocparam@ tags.

Recent versions of ColdFusion provide a set of functions to run queries that
have a slightly different syntax, but still provide parameterized queries.

<code>
  &lt;cfscript>
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
  &lt;/cfscript>
</code>
