<%
Dim ConnectionString, Connection
ConnectionString = ""

Function SetConnection(dbPath)
	ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source="
	ConnectionString = ConnectionString & Server.MapPath(dbPath)
End Function

Function OpenDatabase()
	if ConnectionString = "" then
		Response.Write "No connection string was provided"
		Response.End
	end if
	Response.Write ConnectionString
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

Function ExecuteQuery(sql)
	Connection.Execute sql
End Function

Dim XMLString, XMLObj

Function SetXMLPath(xmlPath)
	XMLString = xmlPath
End Function

Function OpenXML()
	if XMLString = "" then
		Response.Write "No XML string was provided"
		Response.End
	end if
	set XMLObj = Server.CreateObject("Microsoft.XMLDOM")
	XMLObj.async = false
	XMLObj.load (Server.MapPath(XMLString))
End Function

%>