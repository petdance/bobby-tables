ASP
===

For ASP.NET, see the [ADO.NET page](adodotnet).

ASP (aka classic ASP) uses positional placeholders.

    objCmd.CommandType = adCmdText;
    objCmd.CommandText = "UPDATE members SET photo = ? WHERE memberID = ?";
    objCmd.Parameters.Append(objCmd.CreateParameter("filename", adVarChar, adParamInput, 510, fileName));
    objCmd.Parameters.Append(objCmd.CreateParameter("memberID", adInteger, adParamInput, 4, memberid ));
    objCmd.Execute(adExecuteNoRecords);


To do
-----

Add some narrative
