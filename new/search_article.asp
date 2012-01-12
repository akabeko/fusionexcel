<%
' Dependancies: The parent file must included libraries before run this files '
Dim OFFSET, lang, sql, RecordSet
Dim objXml, lang_index
Dim prev_page, page, next_page
' 1 - EN; 2 - BM; 3 - CHI '
lang = base_lang
' 1 - News & Event, 2 - Charities, 3 - Sponsorship '
lang_index = lang

page = 1

if Request("page") <> "" and IsNumeric(Request("page")) then
    page = CInt(Request("page"))
end if

prev_page = page
next_page = page

Dim articlesObj, item

set objXml = GetIndexedArticles(1)
set articlesObj = objXml.selectNodes("articles/article")

%>
<tr>
<td width="180" valign="top">
<!-- Siderbar Start -->
<% Call render_sidebar(articlesObj, 1, 1, false, 20) %>
<!-- Siderbar end -->
</td>
<td width="10" valign="top">&nbsp;</td>
<td width="740" valign="top">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td height="8"></td>
</tr>
<tr>
<td valign="top" bgcolor="#999999">
<table width="100%" border="0" cellspacing="1" cellpadding="10">
<tbody>
<tr>
<td valign="top" bgcolor="#EEF0FC">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tbody>
<%
OFFSET = 50
Dim total_record, total_page
total_record = articlesObj.length
total_page = total_record / OFFSET

if total_page > Round(total_record / OFFSET, 0) then
    total_page = total_page + 1
end if

total_page = Round(total_page, 0)

if total_page = 0 and total_record > 1 then
    total_page = 1
end if

if page > total_page then
    page = total_page
end if

if total_page > next_page then
    next_page = next_page + 1
end if

prev_page = prev_page - 1
if prev_page < 1 then
    prev_page = 1
end if

%>
<!-- searchbox -->
<tr>
<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td width="100">&nbsp;</td>
<td height="50" valign="middle">
<div class="cse-branding-bottom">
<div class="cse-branding-form">
<form action="search.asp" id="ces-search-box">
<div>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
<tbody>
<tr>
<td height="28" bgcolor="#285375">
<span class="conthead style1" style="color:#FFFFFF; padding-left:10px;">Search</span>
</td>
</tr>
<tr>
<td height="50" valign="middle">
<div align="center"><span style="color: blue; font-weight:bold; font-family: arial; font-size: 14px;">Search For : </span><input name="x" type="text" value="<%= Request("x") %>" size="50" /> <input type="submit" name="sa" value="Search" /></div>
</td>
</tr>
</tbody>
</table>
</td>
<td width="100">&nbsp;</td>
</tr>
</tbody>
</table>
</td>
</tr>
<!-- end of searchbox -->
<%
Dim filestream, file, fc
Dim candidate_ids, xmlContent, match_found

set filestream = CreateObject("Scripting.FileSystemObject")
set file = filestream.GetFolder(Server.MapPath(GetArticlePath("")))
set fc = file.files

Dim article_id, content, title, counter

counter = 0

if Request("x") <> "" and Len(Request("x")) >= 4 then
    For Each f1 in fc
        set xmlContent = getArticleContent(f1.name)
        
        article_id =  CInt(Replace(f1.name, ".xml", ""))
        if base_lang = 1 then
            content = xmlContent.item(0).selectSingleNode("en/content").text
            title = xmlContent.item(0).selectSingleNode("en/title").text
        elseif base_lang = 2 then
            content = xmlContent.item(0).selectSingleNode("bm/content").text
            title = xmlContent.item(0).selectSingleNode("bm/title").text
        elseif base_lang = 3 then
            content = xmlContent.item(0).selectSingleNode("chi/content").text
            title = xmlContent.item(0).selectSingleNode("chi/title").text
        end if
        
        if InStr(title, Request("x")) or InStr(content, Request("x")) then
            if candidate_ids <> "" then
                candidate_ids = candidate_ids & "," & article_id
            else
                candidate_ids = article_id
            end if
            counter = counter + 1
        end if
    Next
end if

if counter > 0 then
    match_found = "Found " & counter & " item(s)"
else
    match_found = "No match found"
end if

%>
<tr><td height="25"></td></tr>
<tr>
<td height="25" valign="middle" bgcolor="#285375">
<span class="conthead style1" style="color:#ffffff; padding-left: 10px;">Results</span>
</td>
</tr>
<tr><td height="10"></td></tr>
<tr>
<td valign="top" style="padding: 10px;" class="content">
Your Search: <b><%= Request(x) %></b> <%= match_found %>
<hr />
</td>
</tr>
<tr>
<td>
<%



%>
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
</table>
</td>
</tr>