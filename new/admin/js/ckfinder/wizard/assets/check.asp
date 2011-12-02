<% Option Explicit %>
<%
dim what, ok, msg
what = request("what")

ok = true
select case what
	case "createobject"
		msg = testObject("Scripting.FileSystemObject")
		if msg<>"" then
			ok = false
			response.write msg
		end if

		msg = testObject("ADODB.Stream")
		if msg<>"" then
			ok = false
			response.write msg
		end if

		msg = testObject("Scripting.Dictionary")
		if msg<>"" then
			ok = false
			response.write msg
		end if

		msg = testObject("Msxml2.ServerXMLHTTP.3.0")
		if msg<>"" then
			ok = false
			response.write msg
		end if

		msg = testObject("Msxml2.ServerXMLHTTP.6.0")
		if msg<>"" then
			ok = false
			response.write msg
		end if

		if ok then response.write "OK, CreateObject works"

	case "ckfinder"
		dim baseFolder, UFS
		baseFolder = getBasePath()

		set UFS = New CKFinder_Connector_Utils_FileSystem
		if not(UFS.FileExists(Server.MapPath(baseFolder & "ckfinder.asp"))) then
			ok = false
			response.write "Error: the integration file is missing.<br>"
		end if
		if not(UFS.FileExists(Server.MapPath(baseFolder & "config.asp"))) then
			ok = false
			response.write "Error: the configuration file is missing.<br>"
		end if
		if not(UFS.FileExists(Server.MapPath(baseFolder & "core/connector/asp/connector.asp"))) then
			ok = false
			response.write "Error: the main connector file is missing.<br>"
		end if
		set UFS = Nothing
		if ok then response.write "OK, CKFinder exists"

'	case "ServerVars"
'		response.write ServerVars()

	' Asp version
	Case "version"
		response.write ScriptEngineMajorVersion & "." & ScriptEngineMinorVersion

	case else
		response.status = 500
		response.write "Error, you must specify what do you want to check"

end select


response.end

function getBasePath()
	dim sValue, i, j
	sValue=request.ServerVariables("URL")
	for i=1 to 3
		j = instrrev(sValue, "/")
		sValue = left(sValue, j-1)
	next
	getBasePath = sValue & "/"
end function

Function testObject(name)
	Dim oTmp
	testObject = ""
	on error resume next
	Set oTmp = server.CreateObject(name)
	if err.number<>0 then
		testObject = "Error: the call to server.CreateObject(""" & name & """) " & _
			" has failed with error number " & err.number & " and message '" & err.description  & "'<br>"
	end if
	set oTmp = nothing
	err.clear
End Function

' Utility class, simplified version

class CKFinder_Connector_Utils_FileSystem
	''
	' Reference to Scripting.FileSystemObject
	'
	Private oFSO

	' A file that might be used by Asp.net to verify that the call is from this script.
	Private tempFilePath

	Private Sub Class_Initialize()
		Set oFSO = server.CreateObject("Scripting.FileSystemObject")
		tempFilePath = ""
	End Sub

	Private Sub Class_Terminate()
		' If there was a temp file created, delete it.
		cleanUpTempFile

		Set oFSO = nothing
	End sub

	''

	Public Function FileExists(filename)
		If (filename = "") Then
			FileExists = False
			Exit function
		End If

		FileExists = oFSO.FileExists(filename)
	End Function


	''
	' Deletes the temp File that was created
	'
	Private Sub cleanUpTempFile()
		' If there's no file exit
		If tempFilePath="" Then Exit Sub

		On Error Resume next
		' Call the delete routine
		' In some scenarios it might be possible to create the file but not to delete it
		DeleteFile tempFilePath

		' Reset the variable
		tempFilePath = ""
	End sub

end class

private function ServerVars
	dim e, sValue, txt
	txt = ""
	for each e in request.ServerVariables
		sValue=request.ServerVariables(e)
		txt=txt & e & ": " & sValue & vbcrlf
	next
	ServerVars = txt
end function
%>