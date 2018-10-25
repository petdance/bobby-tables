Microsoft Access
===

_Microsoft Access is a database management system (DBMS) that combines the relational Microsoft Jet Database Engine with a graphical user interface and software-development tools._ ([Wikipedia](https://en.wikipedia.org/wiki/Microsoft_Access))

Manipulating the [Access object model](https://docs.microsoft.com/en-us/office/vba/api/overview/access/object-model) via code -- either with Access-hosted VBA, or with some external code --  opens up the possibility of SQL injection:

* **Using the standard COM data access libraries** -- DAO and ADO. Note that the Access object model has shortcuts to objects in the DAO and ADO object models for the current Access database:

  * DAO.Database: [**Application.CurrentDb**](https://docs.microsoft.com/en-us/office/vba/api/access.application.currentdb) and [**Application.CodeDb**](https://docs.microsoft.com/en-us/office/vba/api/access.application.codedb)
  * ADODB.Connection: [**CurrentProject.AccessConnection**](https://docs.microsoft.com/en-us/office/vba/api/access.currentproject.accessconnection), [**CurrentProject.Connection**](https://docs.microsoft.com/en-us/office/vba/api/access.currentproject.connection), [**CodeProject.AccessConnection**](https://docs.microsoft.com/en-us/office/vba/api/access.codeproject.accessconnection), [**CodeProject.Connection**](https://docs.microsoft.com/en-us/office/vba/api/access.codeproject.connection)

  Preventing SQL injection while using objects from these libraries is described [here](com_automation).

* **RecordSource** property of a [form](https://docs.microsoft.com/en-us/office/vba/api/access.form.recordsource) or [report](https://docs.microsoft.com/en-us/office/vba/api/access.report.recordsource) -- the table name, query name or `SELECT` statement which returns the set of records to which the form/report is bound
* **RowSource** property of a [ListBox](https://docs.microsoft.com/en-us/office/vba/api/access.listbox.rowsource) or [ComboBox](https://docs.microsoft.com/en-us/office/vba/api/access.combobox.rowsource) -- tells Access how to provide a list of values to the control; can be a `SELECT` statement
* **RowSource** property of a field in a table or query -- part of the definition of the default UI control used for the field; works like **ListBox.RowSource** / **ComboBox.RowSource**.
* [**DoCmd.RunSQL**](https://docs.microsoft.com/en-us/office/vba/api/access.docmd.runsql)

If an SQL statement is concatenated from user input or other strings, and used with one of the above properties / methods, this is vulnerable to SQL injection:

```vb
' VBA example
Dim frm As Form
Set frm = Forms!frmStudents
frm.RecordSource = "SELECT * FROM Students WHERE FirstName = '" & InputBox("Enter student's first name") & "'"
```

If the user inputs `' OR '1` into the `InputBox`, all the records from `Students` will be returned.

Injection in contexts which support expressions
---
Even without VBA, there are a number of contexts where Access allows expressions, such as function calls and string
concatenations. If a function expects SQL in one or more of its arguments (like the built-in domain aggregate functions
-- `DCount`, `DMin`, `DLookup`), concatenating user input into a value for the function argument is vulnerable to SQL
injection. For example, using the
[**If**](https://docs.microsoft.com/en-us/office/client-developer/access/desktop-database-reference/if-then-else-macro- block)
macro action and the
[`DCount`](https://docs.microsoft.com/en-us/office/vba/api/access.application.dcount)
domain aggregate function:

![Microsoft Access macro with SQL injection vulnerability](/img/msaccess_macros.png)

If the user inputs `' OR '1` then the expression will always evaluate to `True` (as long as there are records in the `Users` table).

Note that any function which expects some form of structured text (e.g. JSON, XML, command line execution) may be similarly vulnerable when being passed a string concatenated from user input:

```vb
' VBA code
Shell Chr(34) & Forms!RunCommand!CommandLine & Chr(34)
```

This sort of function-argument vulnerability can happen in any context which supports using expressions:

* Saved queries
* VBA code
* Macro actions which support expressions
* Property values that support expressions
* **RecordSource** / **RowSource** / **DoCmd.RunSQL**, which take SQL with such expressions

Referencing globally available state
===

Usually, string concatenation can be avoided altogether, by referencing globally available state directly. The following types of state are available:

* **value of a control on a currently open form or report**

  ```sql
  SELECT * FROM Students WHERE FirstName = Forms!Students!FirstName
  ```

* **TempVars** -- globally available temporary variables

  ```sql
  SELECT * FROM Students WHERE FirstName = TempVars!StudentFirstName
  ```

  TempVars are set using VBA:

  ```vb
  TempVars!StudentFirstName = "Robert' OR '1"
  ```

  or the [**SetTempVar**](https://docs.microsoft.com/en-us/office/client-developer/access/desktop-database-reference/settempvar-macro-action) macro action.

* **VBA functions** defined in one of the database modules

  ```sql
  SELECT * FROM Students WHERE FirstName = GetStudentFirstName()
  ```

  The function can wrap a module-level variable:

  ```vb
  Private StudentFirstName As String
  Function GetStudentFirstName() As String
      GetStudentFirstName = StudentFirstName
  End Function
  Sub SetStudentFirstName(newFirstName As String)
      StudentFirstName = newFirstName
  End Sub
  ```

  or a function-level [`Static`](https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/static-statement) variable, in which case you must use an optional parameter to set the value:

  ```vb
  Function GetStudentFirstName(Optional ByVal newFirstName As Variant) As String
      Static studentFirstName As String
      If Not IsMissing(newFirstName) Then studentFirstName = newFirstName
      GetStudentFirstName = studentFirstName
  End Function
  ```

* **parameters set with [`DoCmd.SetParameter`](https://docs.microsoft.com/en-us/office/vba/api/access.docmd.setparameter)** (cannot be used in all contexts, see below)

These are available in the following contexts:

* saved queries
* the **RecordSource** property of a form or report
* the **RowSource** property of a form/report listbox or combobox, or of a table / query field
* domain aggregate functions
* Expressions within macros
* filters passed in to the [`DoCmd.OpenForm`](https://docs.microsoft.com/en-us/office/vba/api/access.docmd.openform) and [`DoCmd.OpenReport`](https://docs.microsoft.com/en-us/office/vba/api/access.docmd.openreport) methods
* `DoCmd.RunSQL`

Note that parameters set with `SetParameter` cannot be used by filters or `DoCmd.RunSQL`

Sources
===
1. [How do I use parameters in VBA in the different contexts in Microsoft Access? (StackOverflow)](https://stackoverflow.com/questions/49509615/how-do-i-use-parameters-in-vba-in-the-different-contexts-in-microsoft-access/49509616#49509616)
2. [SQL injection and Access macros (StackOverflow)](https://stackoverflow.com/questions/52764955/sql-injection-and-access-macros-not-vba/52766109#52766109)
