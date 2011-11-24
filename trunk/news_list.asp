<%@ CodePage=65001 %>
<!--#include file="data/dbCon.asp" -->
<%
DIM OFFSET, lang, category_code, index

lang = "en"
category_code = 7
OFFSET = 50

if Request("category") <> "" then
	if Request("category") = "charity" then
		category_code = 2
	elseif Request("category") = "sponsorships" then
		category_code = 4
	end if
end if

if Request("lang") <> "" then
	if Request("lang") = "chi" then
		lang = "chi"
	elseif Request("lang") = "bm" then
		lang = "bm"
	end if
end if

%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="<% if lang = "chi" then %>zh<% else %>en<% end if %>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<link href="css/fe.css" rel="stylesheet" type="text/css">
</head>
<body>
						
<%
call OpenDatabase()

if Request("type") = "sidebar" then
	if lang = "chi" then
		sql = "SELECT TOP 20 id, title_chi as title FROM tbl_article WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY sequence_indexed DESC"
	elseif lang = "bm" then
		sql = "SELECT TOP 20 id, title_bm as title FROM tbl_article WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY sequence_indexed DESC"
	else
		sql = "SELECT TOP 20 id, title FROM tbl_article WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY sequence_indexed DESC"
	end if
elseif Request("type") = "" then
	page = 1
	if not Request("page") = "" then
		if IsNumeric(Request("page")) then
			page = CInt(Request("page"))
		end if
	end if
	sql = "SELECT Count(tbl_article.id) AS total FROM tbl_article WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true"
	call CreateRecordSet(RecordSet_Count, sql)
	total_post = RecordSet_Count("total")
	total_page = Round(total_post / OFFSET, 0)
	if total_page = 0 AND total_post > 0 then
		total_page = 1
	end if
	next_page = page + 1
	prev_page = page - 1
	if prev_page < 1 then
		prev_page = 1
	end if
	
	Dim postCounterAfterPaginated
	postCounterAfterPaginated = total_post - ((page - 1) * OFFSET)
	
	if lang = "chi" then
		sql = "SELECT TOP " & OFFSET &  " * FROM ( SELECT * FROM ( SELECT TOP " & postCounterAfterPaginated & " * FROM ( SELECT id, title_chi as title, sequence_indexed FROM tbl_article ta WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY ta.sequence_indexed ASC) ) subTa ORDER BY subTa.sequence_indexed DESC )"
	elseif lang = "bm" then
		sql = "SELECT TOP " & OFFSET &  " * FROM ( SELECT * FROM ( SELECT TOP " & postCounterAfterPaginated & " * FROM ( SELECT id, title_bm as title, sequence_indexed FROM tbl_article ta WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY ta.sequence_indexed ASC) ) subTa ORDER BY subTa.sequence_indexed DESC )"
	else
		sql = "SELECT TOP " & OFFSET &  " * FROM ( SELECT * FROM ( SELECT TOP " & postCounterAfterPaginated & " * FROM ( SELECT id, title, sequence_indexed FROM tbl_article ta WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY ta.sequence_indexed ASC) ) subTa ORDER BY subTa.sequence_indexed DESC )"
	end if

else
	if lang = "chi" then
		sql = "SELECT TOP 20 id, title_chi as title, preview_image_url FROM tbl_article WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY sequence_indexed DESC"
	elseif lang = "bm" then
		sql = "SELECT TOP 20 id, title_bm as title, preview_image_url FROM tbl_article WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY sequence_indexed DESC"
	else
		sql = "SELECT TOP 20 id, title as title, preview_image_url FROM tbl_article WHERE (((" & category_code & " + 1 \ (category_code + 1) ) mod 2) = 1) AND publish = true ORDER BY sequence_indexed DESC"
	end if
end if

call CreateRecordSet(RecordSet, sql)

if Request("type") = "sidebar" then
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #5A71AB">
	<tbody>
		<tr>
			<td width="15px" background="img/header.gif"></td>
			<% if category_code = 2 then %>
				<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = "chi" then %>慈善活动<% elseif lang = "bm" then %>Acara Amal<% else %>Charities<% end if %></td>
			<% elseif category_code = 4 then %>
				<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = "chi" then %>赞助<% elseif lang = "bm" then %>Tajaan<% else %>Sponsorships<% end if %></td>
			<% else %>
				<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = "chi" then %>新闻与活动<% elseif lang = "bm" then %>Berita dan Aktiviti<% else %>News &amp; Events<% end if %></td>
			<% end if %>
		</tr>
		<tr valign="top">
			<td colspan="2" bgcolor="#5A71AB" class="left-news">
				<ul>
				<% Do While not RecordSet.EOF %>
					<li><a href="article.asp?lang=<%= Request("lang") %>&amp;category=<%= Request("categoery") %>&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= Replace(RecordSet("title"), " ", "") %>" target="_top"><%= RecordSet("title") %></a></li>
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
					<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<%= Request("category") %>" target="_top">
						<img src="img/more.gif" width="46px" height="15px" border="0" />
					</a>
				</div>
			</td>
		</tr>
	</tbody>
</table>
<%
elseif Request("type") = "main" then
	index = 0
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tbody>
		<tr>
			<td height="35" bgcolor="#e8edf0" class="fe2"><% if lang = "chi" then %>新闻与活动<% elseif lang = "bm" then %>Berita dan Aktiviti<% else %>News & Events<% end if %></td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<td colspan="3" align="center" bgcolor="#e8edf0"><a href="article.asp?lang=<%= Request("lang") %>&amp;category=<%= Request("categoery") %>&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= Replace(RecordSet("title"), " ", "_") %>" target="_top"><img src="<%= RecordSet("preview_image_url") %>" width="355" height="149" style="border:#999 solid 1px" title="<%= RecordSet("title") %>"></a></td>
						</tr>
						<tr>
							<td width="48%" height="5" align="right" bgcolor="#e8edf0"></td>
							<td width="10" height="5" bgcolor="#e8edf0"></td>
							<td width="48%" height="5" bgcolor="#e8edf0"></td>
						</tr>
						<tr class="fe3">
							<td colspan="3" align="center" bgcolor="#e8edf0">
								<img src="img/bar_arrow.gif" width="12" height="12">
								<a href="article.asp?lang=<%= Request("lang") %>&amp;category=<%= Request("category") %>&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= Replace(RecordSet("title"), " ", "_") %>" target="_top"><%= RecordSet("title") %></a>
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
<% RecordSet.MoveNext %>
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
									<li><a href="article.asp?lang=<%= Request("lang") %>&amp;category=<%= Request("category") %>&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= Replace(RecordSet("title"), " ", "_") %>" target="_top" title="<%= RecordSet("title") %>"><% if Len(RecordSet("title")) > 50 then %><%= Left(RecordSet("title"), 55) %>...</a><% else %><%= RecordSet("title") %><% end if %></li>
								<%
									RecordSet.MoveNext
									index = index + 1
									if index >= 20 then
										Exit Do
									end if
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
		  <td height="20" align="center" bgcolor="#e8edf0"><a href="news.asp?lang=<%= Request("lang")%>&amp;category=<%= Request("category") %>" target="_top"><img src="img/more.gif" width="46" height="15" border="0"></a></td>
		</tr>
	</tbody>
</table>
<%
else
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
												<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<% Request("category") %>&amp;page=1" target="_top">Latest</a>&nbsp;|&nbsp;
												<% if page > 1 and page =< total_page then %>
													<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<% Request("category") %>&amp;page=<%= prev_page %>" target="_top">Back</a>&nbsp;|&nbsp;
												<% end if %>
												<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<% Request("category") %>&amp;page=<% if page >= total_page then %><%= total_page %><% else %><%= next_page %><% end if %>" target="_top">Next</a>&nbsp;|&nbsp;
												<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<% Request("category") %>&amp;page=<%= total_page %>" target="_top">Last</a>
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
										<li><a href="article.asp?lang=<%= Request("lang") %>&amp;category=<%= Request("categoery") %><%= Request("lang") %>&amp;category=<% Request("category") %>&amp;article_id=<%= RecordSet("id") %>&amp;title=<%= Replace(RecordSet("title"), " ", "_") %>" target="_top"><%= RecordSet("title") %></a></li>
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
												<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<% Request("category") %>&amp;page=1" target="_top">Latest</a>&nbsp;|&nbsp;
												<% if page > 1 and page =< total_page then %>
													<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<% Request("category") %>&amp;page=<%= prev_page %>" target="_top">Back</a>&nbsp;|&nbsp;
												<% end if %>
												<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<% Request("category") %>&amp;page=<% if page >= total_page then %><%= total_page %><% else %><%= next_page %><% end if %>" target="_top">Next</a>&nbsp;|&nbsp;
												<a href="news.asp?lang=<%= Request("lang") %>&amp;category=<% Request("category") %>&amp;page=<%= total_page %>" target="_top">Last</a>
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