h1. ASP

<code>
objCmd.CommandType = adCmdText;
objCmd.CommandText = "UPDATE members SET photo = @filename WHERE memberID = @memberID";
objCmd.Parameters.Append(objCmd.CreateParameter("@memberID", adInteger, adParamInput, 4, memberid ));
objCmd.Parameters.Append(objCmd.CreateParameter("@filename", adVarChar, adParamInput, 510, fileName));
objCmd.Execute(adExecuteNoRecords);
gblDelobjParams(objCmd);
</code>

h2. To do

Add some narrative
