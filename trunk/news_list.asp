<!--#include file="data/dbCon.asp" -->
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="css/fe.css" rel="stylesheet" type="text/css">
</head>
<body>
						
<%
call OpenDatabase()

OFFSET = 50

if Request("type") = "sidebar" then
	sql = "SELECT TOP 20 id, title FROM tbl_article WHERE category = 'news' AND publish = true ORDER BY created"
elseif Request("type") = "" then
	page = 1
	if not Request("page") = "" then
		if IsNumeric(Request("page")) then
			page = CInt(Request("page"))
		end if
	end if
	endPos = page * OFFSET
	startPos = endPos - OFFSET
	if startPos <= 0 then
		startPos = 1
	end if
	sql = "SELECT id, title FROM tbl_article WHERE category = 'news' AND publish = true ORDER BY created"
else
	sql = "SELECT id, title FROM tbl_article WHERE category = 'news' AND publish = true ORDER BY created"
end if

call CreateRecordSet(RecordSet, sql)

if Request("type") = "sidebar" then
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #5A71AB">
	<tbody>
		<tr>
			<td width="15px" background="img/header.gif"></td>
			<td width="163" height="25px" background="img/header.gif" class="smallhead">News & Events</td>
		</tr>
		<tr valign="top">
			<td colspan="2" bgcolor="#5A71AB" class="left-news">
				<ul>
				<% Do While not RecordSet.EOF %>
					<li><a href="article.asp?category=news&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= RecordSet("title") %>" target="_top"><%= RecordSet("title") %></a></li>
				<%
					RecordSet.MoveNext
				Loop
				%>
				</ul>
			</td>
		</tr>
		<tr>
			<td colspan="2" bgcolor="#5A71AB" align="right">
				<div style="margin-right: 10px; margin-bottom: 10px;">
					<a href="news.asp" target="_top">
						<img src="img/more.gif" width="46px" height="15px" border="0" />
					</a>
				</div>
			</td>
		</tr>
	</tbody>
</table>
<%
elseif Request("type") = "main" then
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tbody>
		<tr>
			<td height="35" bgcolor="#e8edf0" class="fe2">&nbsp;&nbsp; 	News &amp; Events</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<td colspan="3" align="center" bgcolor="#e8edf0"><a href="article.asp?category=news&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= RecordSet("title") %>" target="_top"><img src="./Welcome to FusionExcel International_files/home_23092011.jpg" width="355" height="149" style="border:#999 solid 1px" title="<%= RecordSet("title") %>"></a></td>
						</tr>
						<tr>
							<td width="48%" height="5" align="right" bgcolor="#e8edf0"></td>
							<td width="10" height="5" bgcolor="#e8edf0"></td>
							<td width="48%" height="5" bgcolor="#e8edf0"></td>
						</tr>
						<tr class="fe3">
							<td colspan="3" align="center" bgcolor="#e8edf0">
								<img src="./Welcome to FusionExcel International_files/bar_arrow.gif" width="12" height="12">
								<a href="article.asp?category=news&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= RecordSet("title") %>" target="_top"><%= RecordSet("title") %></a>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
	  </tr>
	  <tr>
		<td height="5" bgcolor="#e8edf0"></td>
	  </tr>
	</tbody>
</table>
<%= RecordSet.MoveNext %>
<table width="100%" height="358" border="0" cellpadding="0" cellspacing="0">
	<tbody>
		<tr>
			<td width="100" height="282" valign="top">
				<table width="376px" border="0" cellpadding="0" cellspacing="0" bgcolor="#e8edf0">
					<tbody>
						<tr>
							<td valign="top" bgcolor="#e8edf0" class="left-news_myo">
								<ul>
								<% Do While not RecordSet.EOF %>
									<li><a href="article.asp?category=news&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= RecordSet("title") %>" target="_top"><%= RecordSet("title") %></a></li>
								<%
									RecordSet.MoveNext
								Loop
								%>
								</ul>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr valign="bottom">
		  <td height="20" align="center" bgcolor="#e8edf0"><a href="news.asp"><img src="./Welcome to FusionExcel International_files/more.gif" width="46" height="15" border="0"></a></td>
		</tr>
	</tbody>
</table>
<%
else

sql = "SELECT Count(tbl_article.id) AS total FROM tbl_article WHERE category='news' AND publish = true"
call CreateRecordSet(RecordSet_Count, sql)
total_post = RecordSet_Count("total")
page = Request("page")
total_page = Round(total_post / OFFSET, 0)
if total_page = 0 AND total_post > 0 then
	total_page = 1
end if
%>
<table width="100%" border="0" cellspacing="1" cellpadding="10" height="1512px">
	<tbody>
		<tr>
			<td height="943px" valign="top" bgcolor="#EEF0FC">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<td height="30" align="right" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tbody>
										<tr>
											<td width="55%" align="right" class="smallcont">Page <%= page %> of <%= total_page %></td>
											<td align="right" class="smallcont">
												<a href="news.asp?page=1">Latest</a>&nbsp;|&nbsp;
												<a href="news.asp?page=2">Next</a>&nbsp;|&nbsp;
												<a href="news.asp?page=">Last</a>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
						<tr>
							<td class="news-eve">
								<ul>
									<% Do While not RecordSet.EOF %>
										<li><a href="article.asp?category=news&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= RecordSet("title") %>" target="_top"><%= RecordSet("title") %></a></li>
									<%
										RecordSet.MoveNext
									Loop
									%>
								</ul>
							</td>
						</tr>
						<tr>
							<td height="30" align="right" valign="bottom">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
									<tbody>
										<tr>
											<td width="55%" align="right" class="smallcont">Page <%= page %> of <%= total_page %></td>
											<td align="right" class="smallcont">
												<a href="news.asp?page=1">Latest</a>&nbsp;|&nbsp;
												<a href="news.asp?page=2">Next</a>&nbsp;|&nbsp;
												<a href="news.asp?page=">Last</a>
											</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<%
end if
call CloseRecordSet(RecordSet)
call CloseDatabase()
%>
</body>
</html>