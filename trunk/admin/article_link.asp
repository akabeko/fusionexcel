<%@ Language=VBScript %>
<%
	option explicit
	Response.Expires = -1
	Server.ScriptTimeout = 600
	Session.CodePage = 65001
	Dim page_title, sql
	page_title = "Fusion Excel Content Management System"
	uploadsDirVar = "C:\inetpub\scripts\fusionexcel\fusionexcel\trunk\images\" 
%>
<!--#include file="../data/dbCon.asp" -->
<!--#include file="freeaspupload.asp" -->
<!--#include file="header.asp" -->

<%
	if Request("action") <> "" then
%>

<%
	elseif Request("action") = "" then
		sql
%>


<%
	end if
%>