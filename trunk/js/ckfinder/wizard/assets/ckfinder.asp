<%
option explicit

dim errMessage, errNumber, oCKFinder_Factory

' Let's load the config.asp file, but avoid crashing if there's any error.
on error resume next
%>
<!-- #INCLUDE FILE="../../config.asp" -->
<%
if (err.number<>0) then
	errNumber = err.Number
	errMessage = err.description
	if (instr(errMessage, "MapPath")) then
		if (baseUrl<>"") and (baseDir="") then
			response.write "You have set as baseUrl """ & baseUrl & """ but it can't be mapped automatically to a folder.<br>" & _
				"You must specifiy in the baseDir parameter what's the proper folder for that url"
			response.end
		end if
	end if
	response.write "Error loading the config file<br>"
	response.write "error number: " & errNumber & ", message: " & errMessage
	response.end
end if
on error goto 0
%>
<!-- #INCLUDE FILE="../../core/connector/asp/Utils/FileSystem.asp" -->
<%

call parseRequest()

function parseRequest()
	dim what, ok, xml, tempFolder, systemTempFolder
	dim oTmp, tFolder, i, aTypesSize
	what = request("what")

	ok = true
	select case what

		case "enabled"
			if (CheckAuthentication()) then
				response.write "enabled"
			else
				response.write "disabled"
			end if

		case "debug"
			if (CKFinder_Debug) then
				response.write "debug"
			else
				response.write "normal"
			end if

		case "basedir"
			Response.ContentType	= "text/xml"
			response.write "<?xml version=""1.0""?>" & _
				"<baseDir>" & _
					"<Path>" & baseDir & "</Path>" & _
					"<validate>" & ValidateWritableFolder(baseDir, true, "OK") & "</validate>" & _
				"</baseDir>"

		case "tempfolder"
			Set oTmp = server.CreateObject("Scripting.FileSystemObject")
			Set tfolder = oTmp.GetSpecialFolder(2)
			systemTempFolder =  tfolder.path
			Set tfolder = nothing
			Set oTmp = nothing

			tempFolder = systemTempFolder
			if (CKFinderTempPath<>"") then tempFolder = CKFinderTempPath

			Response.ContentType	= "text/xml"
			response.write "<?xml version=""1.0""?>" & _
				"<tempfolder>" & _
					"<TempPath>" & systemTempFolder & "</TempPath>" & _
					"<CKFinderTempPath>" & CKFinderTempPath & "</CKFinderTempPath>" & _
					"<validate>" & ValidateWritableFolder(tempFolder, false, "OK") & "</validate>" & _
				"</tempfolder>"

		case "resources"
			Response.ContentType	= "text/xml"
			response.write "<?xml version=""1.0""?>" & _
				"<ResourceTypes>"

			aTypesSize = ubound(ResourceTypes)
			For i=0 To aTypesSize
				response.write GenerateResourceInfo( ResourceTypes(i) )
			next
			response.write "</ResourceTypes>"

		Case "fileupload"
			response.write ProcessUpload()

		Case "CreateTestFile"
			response.write CreateTestFile()

		Case "CreateTestImage"
			response.write CreateTestImage()

		' checks for an image that doesn't have its thumbnail created:
		Case "GetTestImage"
			response.write GetTestImage()

		case "loopback"
			response.write LoadUrl(AspNetUrl())

		case "Component"
			response.write Images.Item("component")

		case ""
			' Nothing for empty command

		case "SessionVars"
			if Session.Contents.Count =0 then
				response.write "There are no Session variables set at the server."
			else
				response.write "Current session variables at the server:<br>"
				dim e, sValue
				on error resume next
				for each e in Session.Contents
					sValue=Session(e)
					response.write "&nbsp;&nbsp;&nbsp;&nbsp;" & e & ": " & sValue & "<br>" & vbcrlf
				next
				response.write "-End of session variables dump-"
			end if

		case "Execution"
			CopyScripts

		case "ClearExecution"
			DeleteScripts

		case else
			response.write "Unexpected command: " & what
	end select
end function



function GetTestImage()
	dim destiny, oUFS
	set oUFS = new CKFinder_Connector_Utils_FileSystem

	destiny = GetResourceFolder("Images")

	dim oFiles, oFile, extension, txt, thumbsFolder
	thumbsFolder = oUFS.combinePaths(Thumbnails.Item("directory"), "Images")

	Set oFiles = oUFS.GetFiles( destiny )
	For Each oFile in oFiles
		' search for images:
		extension = oUFS.GetExtension(oFile.name)
		' Or extension="jpeg"  bug in 1.2.3
		If (extension="jpg") then 'Or extension="bmp" Or extension="png" Or extension="gif") then
			'check if the thumbnail exists:
			if not(oUFS.FileExists( oUFS.combinePaths(thumbsFolder, oFile.name) ) ) then
				GetTestImage = oFile.name
				exit function
			end if
		end if
	Next

	GetTestImage = ""
end function


Function CreateTestFile()
		dim destiny, oUFS
		set oUFS = new CKFinder_Connector_Utils_FileSystem
		destiny = GetResourceFolder("Files")

		oUFS.createDirectoryRecursively destiny

		if (CopyFile(oUFS, destiny, "hello.txt")) then
			CreateTestFile = "OK"
		else
			CreateTestFile = "Copy of test file failed"
		end if
end function

Function CreateTestImage()
		dim destiny, oUFS
		set oUFS = new CKFinder_Connector_Utils_FileSystem
		destiny = GetResourceFolder("Images")

		oUFS.createDirectoryRecursively destiny

		if (CopyFile(oUFS, destiny, "test.jpg")) then
			CreateTestImage = "OK"
		else
			CreateTestImage = "Copy of test image failed"
		end if
end function

Function CopyScripts()
	dim destiny, oUFS
	set oUFS = new CKFinder_Connector_Utils_FileSystem
	destiny = GetResourceFolder("Files")

	oUFS.createDirectoryRecursively destiny
	CopyFile oUFS, destiny, "hello.asp"
	CopyFile oUFS, destiny, "hello.aspx"
	CopyFile oUFS, destiny, "hello.php"
end function

private function CopyFile(oUFS, destiny, name)
	dim source, destinyFile
	source = server.mapPath(name)
	destinyFile = oUFS.combinePaths(destiny, name)
	oUFS.DeleteFile(destinyFile)
	CopyFile = oUFS.CopyFile(source, destinyFile)
end function

Function DeleteScripts()
	dim destiny, oUFS
	set oUFS = new CKFinder_Connector_Utils_FileSystem
	destiny = GetResourceFolder("Files")

	DeleteFile oUFS, destiny, "hello.asp"
	DeleteFile oUFS, destiny, "hello.aspx"
	DeleteFile oUFS, destiny, "hello.php"
end function

private function DeleteFile(oUFS, destiny, name)
	dim source, destinyFile
	source = server.mapPath(name)
	destinyFile = oUFS.combinePaths(destiny, name)
	oUFS.DeleteFile(destinyFile)
end function

private function GetResourceFolder(ResourceName)
	dim aTypesSize, i

	aTypesSize = ubound(ResourceTypes)
	For i=0 To aTypesSize
		if( ResourceTypes(i).Item("name") = ResourceName) then
			GetResourceFolder = ResourceTypes(i).Item("directory")
			exit function
		end if
	next
end function

Function ProcessUpload()
	Dim aCType
	aCType = Split(Request.ServerVariables("HTTP_CONTENT_TYPE"), ";")
	if ( uBound(aCType) < 0 ) then
		ProcessUpload = "Invalid data"
		Exit Function
	end if
	If aCType(0) <> "multipart/form-data" Then
		ProcessUpload = "Content type incorrect"
		Exit function
	End If

	Dim nTotalSize
	nTotalSize	= Request.TotalBytes
	If nTotalSize < 1 Then
		ProcessUpload = "Length of upload data incorrect"
		Exit function
	End If

	Dim nTotalBytes, nPartBytes, ReadBytes
	ReadBytes = 0
	nTotalBytes = Request.TotalBytes

	On Error Resume next
	Do While ReadBytes < nTotalBytes

		nPartBytes = 64 * 1024 ' 64k
		If nPartBytes + ReadBytes > nTotalBytes Then
			nPartBytes = nTotalBytes - ReadBytes
		End If
		Request.BinaryRead(nPartBytes)
		ReadBytes = ReadBytes + nPartBytes

		If (Err.number<>0) Then
			ProcessUpload = "Error processing data: " & Err.description
			Exit function
		End If
	Loop
	On Error goto 0

	ProcessUpload = "OK"
End Function

function GenerateResourceInfo( resource )
	GenerateResourceInfo = "<ResourceType " & _
		" name=""" & resource.Item("name") & """" & _
		" maxsize=""" & parseNumber(resource.Item("maxSize")) & """" & _
		"/>"
end function

function ValidateWritableFolder(path, checkFolderCreation, okMessage)
	dim message
	message = okMessage

' Verify that the folder does exists and that it's writeable.
	dim oUFS, testFile, testFolder
	set oUFS = new CKFinder_Connector_Utils_FileSystem
	if not(oUFS.FolderExists(path)) then
		message = "The folder '" & path & "' doesn't exist. Please create it and make it writeable"
	else
		' Now check that we can create a file in it.
		testFile = oUFS.combinePaths(path, "testFile.txt")
		on error resume next
		oUFS.CreateTextFile testFile, "just some text"
		if (err.number<>0) then
			errNumber = err.Number
			errMessage = err.description
			message = "Error writing a file in '" & path & "'" & vbcrlf
			message = message & "Error number: " & errNumber & ", message: " & errMessage & vbcrlf
			message = message & "You must grant write permissions to the IUSR_machineName for this folder."
		else
			oUFS.DeleteFile testFile

			if (checkFolderCreation) then
				' And now a folder
				testFolder = oUFS.combinePaths(path, "testFolder")
				oUFS.createDirectoryRecursively testFolder
				if (err.number<>0) then
					errNumber = err.Number
					errMessage = err.description
					message = "Error creating a folder in '" & path & "' <br>"
					message = message & "error number: " & errNumber & ", message: " & errMessage & "<br>"
				else
					oUFS.DeleteFolder testFolder
				end if
			end if

		end if
		on error goto 0
	end if

	set oUFS = nothing

	ValidateWritableFolder = message
end function


' copied from ResourceTypeConfig
	''
	' Given a string, it returns a number, converting the sufixes as necessary
	' 1K -> 1024, 1M-> 10^20
	Private Function parseNumber( sNumber )
		Dim tmp, suffix
		If (sNumber="") Then
			parseNumber = 0
			Exit function
		End If

		tmp = 1
		suffix = UCase(Right(sNumber, 1))
		If (suffix="B") Then
			sNumber = Left(sNumber, Len(sNumber)-1)
			suffix = UCase(Right(sNumber, 1))
		End if
		If (suffix="K") Then
			tmp = 1024
			sNumber = Left(sNumber, Len(sNumber)-1)
		End if
		If (suffix="M") Then
			tmp = 1024 * 1024
			sNumber = Left(sNumber, Len(sNumber)-1)
		End if
		If (suffix="G") Then
			tmp = 1024 * 1024 * 1024
			sNumber = Left(sNumber, Len(sNumber)-1)
		End If

		If IsNumeric(sNumber) then
			parseNumber = CLng(sNumber) * tmp
		Else
			parseNumber = 0
		End if
	End function



	Private function AspNetUrl()
		Dim url
		url = ""
		If (UCase(Request.ServerVariables("HTTPS")) = "ON") Then
			url = "https://"
		Else
			url = "http://"
		End if
		url = url & Request.ServerVariables("SERVER_NAME")
'		url = url & Request.ServerVariables("LOCAL_ADDR")
		Dim port
		port = request.ServerVariables("SERVER_PORT")
		If (port<>"80") Then url = url & ":" & port
		url = url & replace(Request.ServerVariables("URL"), "/ckfinder.asp", "/hello.aspx")

		AspNetUrl = url
	End function

	Function getConfigValue(name)
		If (CKFinder_Config.Exists(name)) Then
			getConfigValue = CKFinder_Config.Item(name)
		Else
			getConfigValue = ""
		End if
	End function

	Private Function LoadUrl( sUrlToCall )
		Dim oXmlHttp
		Dim node, value

		Set oXmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0")

		oXmlHttp.Open "GET", sUrlToCall, False, Request.ServerVariables("AUTH_USER") & "", Request.ServerVariables("AUTH_PASSWORD") & ""
'		oXmlHttp.setRequestHeader "Host", Request.ServerVariables("SERVER_NAME")

		on error resume next
		oXmlHttp.Send

		if err.number<>0 then
			LoadUrl = "Error loading """ & sUrlToCall & """ " & vbcrlf & err.description
			exit function
		end if
		on error goto 0

		if ( (oXmlHttp.status = 200 or oXmlHttp.status = 304) and Not(IsNull(oXmlHttp.responseXML) ) And Not(IsNull( oXmlHttp.responseXML.firstChild)) ) then
		'	this.DOMDocument = oXmlHttp.responseXML ;
		Else
			LoadUrl = "Unable to LoadUrl (" & sUrlToCall & ") " & vbcrlf & oXmlHttp.responseText
			exit function
		End if

		if (oXmlHttp.responseText="hello") then
			LoadUrl = "OK"
		else
			LoadUrl = "Invalid response" & vbcrlf & oXmlHttp.responseText
		end if

		Set oXmlHttp = Nothing

	End Function

%>