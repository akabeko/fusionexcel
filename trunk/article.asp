<!--#include file="data/dbCon.asp" -->
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="css/fe.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
call OpenDatabase()

sql = "SELECT id, title, content FROM tbl_article WHERE category = 'news' AND publish = true"
call CreateRecordSet(RecordSet, sql)
%>
<table width="376px" border="0" cellpadding="0" cellspacing="0" bgcolor="#e8edf0">
	<tbody>
		<tr>
			<td valign="top" bgcolor="#e8edf0" class="left-news_myo">
				<ul>
<% Do While not RecordSet.EOF %>
					<li><a href="article.asp" target="_top"><%= RecordSet("title") %></a></li>
<%
	RecordSet.MoveNext
Loop
%>
				</ul>
			</td>
		</tr>
	</tbody>
</table>
<%
call CloseRecordSet(RecordSet)
call CloseDatabase()
%>
</body>
</html>