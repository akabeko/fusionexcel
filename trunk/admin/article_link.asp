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
Call OpenDatabase()
if Request("action") <> "" then
	Dim RecordSet
	sql = "SELECT * FROM tbl_article_link WHERE article_link_id = " & Request("id")
	Call CreateRecordSet(RecordSet, sql)
%>

<%
elseif Request("action") = "" then
	Dim RecordSet
	sql = "SELECT * FROM tbl_article_link tal"
	sql = sql & " INNER JOIN ref_link_type rlt ON tal.link_type_code = rlt.link_type_code"
	Call CreateRecordSet(RecordSet, sql)
%>
<table width="100%" cellpadding="0" cellspacing="0">
	<thead>
		<tr>
			<td>ID</td>
			<td>Title</td>
			<td>Article Link</td>
			<td>Last Modified</td>
			<td>Last Modified By</td>
		</tr>
	</thead>
	<tbody>
	<%
		Do While Not RecordSet.EOF
	%>
	<tr>
		<td><%= RecordSet("article_link_id") %></td>
		<td><a href="article_link.asp?action=edit&amp;id=<%= <%= RecordSet("article_link_title") %></td>
		<td><a href="article.asp?action=edit&amp;id=<%= RecordSet("article_id") %>" target="_blank">View Article</a></td>
		<td><%= RecordSet("last_modified") %></td>
		<td><%= RecordSet("last_modified_by") %></td>
	</tr>
	<% 
			RecordSet.MoveNext
		Loop
	%>
	</tbody>
</table>
<%
end if
%>