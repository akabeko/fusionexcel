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


' XML Function '
Dim XMLString

Function SetXMLPath(xmlPath)
	XMLString = xmlPath
End Function

Function OpenXML()
	Dim objXML
	if XMLString = "" then
		Response.Write "No XML string was attached"
		Response.End
	end if
	set objXML = Server.CreateObject("Msxml2.DOMDocument")
	objXML.async = false
	objXML.load(Server.MapPath(XMLString))
	If objXML.parseError.errorCode then
		Response.Write "Error Parsing XML<br/>"
		Response.Write "Reason: " & objXML.parseError.reason & " Error Line: " & objXML.parseError.line
		Response.End
	End If
	
	set OpenXML = objXML
End Function

Function SaveXML(objXML, path)
    objXML.Save Server.MapPath(path)
End Function

Function CreateXML()
    set CreateXML = Server.CreateObject("Microsoft.XMLDOM")
End Function


' XPath Function @ Associate with XMLString & SetXMLPath '
Function OpenXpath()
    Dim objXML
    if XMLString = "" then
		Response.Write "No XML string was attached"
		Response.End
	end if
    set objXML = Server.CreateObject("Msxml2.DOMDocument.3.0")
    objXML.async = false
End Function
%>