COM / Automation
===

[COM](https://en.wikipedia.org/wiki/Component_Object_Model) defines a standard way for software components to interact
with each other, independent of the programming language in which they are written or consumed. Environments and
languages which can be used to consume COM objects include:

* **VBA** / **VB6**
* **.NET languages**
* [**Microsoft scripting hosts**](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/scripting-articles/fdee6589(v%3dvs.94)), which can support [multiple scripting languages](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/scripting-articles/xawadt95(v%3dvs.94)), including VBScript and JScript (available by default)
    * Internet Explorer (and Microsoft HTML Applications (MSHTA))
    * "classic" ASP
    * Windows Script Host
* **Borland Delphi**
* **Python** with the [PyWin32 extensions](https://github.com/mhammond/pywin32), using the `win32com` package
* **Unmanaged C++**

There are currently two data access technologies for COM environments in common use:

* Data Access Objects (DAO), later renamed to Access Database Engine (ACE)
* ActiveX Data Objects (ADO)

DAO / ACE
===

DAO allows direct execution of raw SQL in a number of places:

* the **Execute** method, on the [**Database**](https://msdn.microsoft.com/en-us/library/office/ff197654.aspx) and [**Connection**](https://msdn.microsoft.com/en-us/library/office/ff835040.aspx) objects
* the **OpenRecordset** method, on the [**Database**](https://msdn.microsoft.com/en-us/library/office/ff820966.aspx) and [**Connection**](https://msdn.microsoft.com/en-us/library/office/ff194324.aspx) objects
* [**QueryDef**](https://msdn.microsoft.com/en-us/library/office/ff845129.aspx) objects
    * the **CreateQueryDef** method, on the [**Database**](https://msdn.microsoft.com/en-us/library/office/ff195966.aspx) and [**Connection**](https://msdn.microsoft.com/en-us/library/office/ff191860.aspx) objects
    * the [**QueryDef.SQL**](https://msdn.microsoft.com/en-us/library/office/ff845522.aspx) property

but only a **QueryDef** can make use of parameters, and thus make SQL safe from SQL injection.

DAO parses the SQL statement passed into the **CreateQueryDef** method or set as the value of the **SQL** property, and automatically determines the number, names, and types of the parameters.

The value of the parameter can then be set.

```vb
' VBA example -- SELECT with placeholder
' dbs refers to an instance of DAO.Database

Dim qdf As QueryDef
Set qdf = dbs.CreateQueryDef("", "SELECT * FROM Students WHERE FirstName = ?")

' Using default properties
qdf.Parameters(0) = "Robert' OR 1=1; --"
' The equivalent without default properties would be:
' qdf.Parameters.Item(0).Value = "Robert' OR 1=1; --"

Dim rs As DAO.Recordset
Set rs = qdf.OpenRecordset
```

DAO also supports the use of named parameters. Any unrecognized identifier in the SQL statement will be treated as a named parameter:

```vb
' VBA example -- action query; doesn't return results
' dbs refers to an instance of DAO.Database

Dim qdf As QueryDef
Set qdf = dbs.CreateQueryDef("", "DELETE * FROM Students WHERE FirstName = MatchingFirstName")
qdf.Parameters("MatchingFirstName") = "Robert' OR 1=1; --"
qdf.Execute
```

In order to explicitly define the types and/or names of the parameters, use the
[`PARAMETERS` clause](https://msdn.microsoft.com/en-us/library/office/ff845220.aspx?f=255&MSPPError=-2147217396)
in the SQL:

```vb
' VBA Example -- explicit parameters
' dbs refers to an instance of DAO.Database

Const sql = _
    "PARAMETERS MatchingFirstName TEXT; " & _
    "SELECT * " & _
    "FROM Students " & _
    "WHERE FirstName = MatchingFirstName"

Dim qdf As QueryDef
Set qdf = dbs.CreateQueryDef("", sql)
qdf.Parameters("MatchingFirstName") = "Robert' OR 1=1; --"

Dim rs As DAO.Recordset
Set rs = qdf.OpenRecordset
```

ActiveX Data Objects (ADO)
===

ADO provides three ways in which raw SQL can be passed to the data source:

* [**Connection**.**Execute** method](https://docs.microsoft.com/en-us/sql/ado/reference/ado-api/execute-method-ado-connection)
* [**Recordset**.**Open** method](https://docs.microsoft.com/en-us/sql/ado/reference/ado-api/open-method-ado-recordset)
* [commands](https://docs.microsoft.com/en-us/sql/ado/guide/data/preparing-and-executing-commands)

but only with commands can SQL injection be prevented, by using placeholders for values within the SQL, and
[**parameters**](https://docs.microsoft.com/en-us/sql/ado/guide/data/command-object-parameters):

```vb
' VBA example -- using commands with explicit parameter objects
' Add a reference to "Microsoft ActiveX Data Objects"

Const connectionString = "..." 'fill connection string here
Const sql = "SELECT * FROM Students WHERE FirstName = ?"

Dim cmd As New ADODB.Command
cmd.ActiveConnection = connectionString
cmd.CommandText = sql

Dim prm As New ADODB.Parameter
prm.Type = adVarChar
prm.Size = 255
prm.Value = "Robert' OR 1=1; --"
cmd.Parameters.Append prm
' Instead of instantiating a new Parameter object, you can also use the command's
' CreateParameter method, but you still must manually add the parameter to the
' command's collection of parameters, as above

Dim rs As ADODB.Recordset
Set rs = cmd.Execute
```

Parameter values can also be passed in to the
[`Command.Execute`](https://docs.microsoft.com/en-us/sql/ado/reference/ado-api/execute-method-ado-command?view=sql-server-2017)
method (wrapped in a SAFEARRAY):

```vb
'VBScript example -- passing parameter values wrapped in a SAFEARRAY, to the Execute method

Const connectionString = "..." 'fill connection string here
Const sql = "SELECT * FROM Students WHERE FirstName = ?"

Dim cmd
Set cmd = CreateObject("ADODB.Command")
cmd.ActiveConnection = connectionString
cmd.CommandText = sql

Dim rs
Set rs = cmd.Execute(, Array("Robert' OR 1=1; --"))
```

In addition, if the command's `Name` property has been set, the command can be executed directly from the connection
object using the name; this is called a
[**named command**](https://docs.microsoft.com/en-us/sql/ado/guide/data/named-commands).
Values which are
[passed into the command call](https://docs.microsoft.com/en-us/sql/ado/guide/data/passing-parameters-to-a-named-command)
will be used as parameter values:

```js
// JScript example -- passing parameter values to a named command

var connectionString = '...'; // fill connection string here
var sql = 'SELECT * FROM Students WHERE FirstName = ?';

var conn = new ActiveXObject('ADODB.Connection');
conn.Open(connectionString);

var cmd = new ActiveXObject('ADODB.Command');
cmd.Name = 'GetStudents';
cmd.CommandText = sql;
cmd.ActiveConnection = conn;

// We need to instantiate the Recordset object in Javascript, because Javascript
// has no compile-time types, and ADO has no way of knowing that we're trying to
// pass in a Recordset
var rs = new ActiveXObject('ADODB.Recordset');
conn.GetStudents('Robert\' OR 1=1; --', rs);
```
