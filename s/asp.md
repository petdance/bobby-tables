ASP
===

> For ASP<i></i>.NET, see the [ADO.NET page](adodotnet.md).

ASP (AKA classic ASP) uses positional placeholders.

    objCmd.CommandType = adCmdText;
    objCmd.CommandText = "UPDATE members SET photo = ? WHERE memberID = ?";
    objCmd.Parameters.Append(objCmd.CreateParameter("filename", adVarChar, adParamInput, 510, fileName));
    objCmd.Parameters.Append(objCmd.CreateParameter("memberID", adInteger, adParamInput, 4, memberid ));
    objCmd.Execute(adExecuteNoRecords);


To do
-----

Add some narrative
