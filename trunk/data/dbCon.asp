<%
Dim ConnectionString, Connection
ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" & Server.MapPath("/data/fusionexcel.mdb")

Function OpenDatabase()
	set Connection = Server.CreateObject("ADODB.Connection")
	Connection.open ConnectionString
End Function

Function CloseDatabase()
	connection.Close
End Function

Function CreateRecordSet(rsName, sql)
	set rsName = Server.CreateObject("ADODB.RecordSet")
	rsName.CursorType = 2
	rsName.LockType = 3
	rsName.Open sql, Connection
End Function

Function CloseRecordSet(rsName)
	set rsName = Nothing
End Function

%>