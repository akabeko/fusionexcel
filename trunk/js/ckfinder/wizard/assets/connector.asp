<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<%
' CKFinder
' ========
' http://www.ckfinder.com
' Copyright (C) 2007-2008 Frederico Caldeira Knabben (FredCK.com)
'
' The software, this file and its contents are subject to the CKFinder
' License. Please read the license.txt file before using, installing, copying,
' modifying or distribute this file or part of its contents. The contents of
' this file is part of the Source Code of CKFinder.
%>
<!-- #INCLUDE file="../../core/connector/asp/core/factory.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/core/AccessControlConfig.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/core/folderHandler.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/core/xml.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/core/config.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/core/ImagesConfig.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/core/ThumbnailsConfig.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/core/ResourceTypeConfig.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/core/connector.asp" -->

<!-- #INCLUDE file="../../core/connector/asp/errorHandler/Errors.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/errorHandler/base.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/errorHandler/FileUpload.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/errorHandler/QuickUpload.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/errorHandler/http.asp" -->

<!-- #INCLUDE file="../../core/connector/asp/commandHandler/commandHandlerBase.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/XmlCommandHandlerBase.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/init.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/GetFolders.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/GetFiles.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/CreateFolder.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/DeleteFolder.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/RenameFile.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/RenameFolder.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/DownloadFile.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/DeleteFile.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/FileUpload.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/QuickUpload.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/commandHandler/Thumbnail.asp" -->

<!-- #INCLUDE file="../../core/connector/asp/utils/FileSystem.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/utils/Image.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/utils/Netrube_upload.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/utils/RegExp.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/utils/Time.asp" -->
<!-- #INCLUDE file="../../core/connector/asp/utils/xmlNode.asp" -->

<!-- #INCLUDE FILE="../../config.asp" -->

<%
CKFinder_Debug = true
' Create a single instance of the factory that will take care of the rest of the objects
Set oCKFinder_Factory = new CKFinder_Factory

Dim sCommand
sCommand = request.queryString("command")

if (sCommand ="UsedComponent") then
	response.write oCKFinder_Factory.UtilsImage.ComponentName
else
	oCKFinder_Factory.Connector.executeCommand(sCommand)
end If


' Skeleton
Class CKFinder_Connector_Core_Hooks
    Public function run(eventName, args)
		run = true
	End function
End Class

Public Sub CKFinder_AddHook(eventName, handler)
End Sub

Public Sub CKFinder_AddPlugin(name)
End Sub

%>