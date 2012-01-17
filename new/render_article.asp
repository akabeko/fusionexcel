<%
' Libraries and others param define on the parent files '
Dim OFFSET, objXml
Dim category_code

category_code = 1

if Request("category_code") <> "" and IsNumeric(Request("category_code")) then
    category_code = CInt(Request("category_code"))
end if

set objXml = GetIndexedArticles(category_code)
set articlesObj = objXml.selectNodes("articles/article")
Dim index_image_url, title, publish, publish_start_date, article_id_local, category_code_local
Dim counter
%>
</tr>
<tr>
<td width="180" valign="top">
<!-- Siderbar Start -->
<%
Dim limit, header, sidebar_type
    header = false
if category_code = 1 or category_code = 2 or category_code = 4 or category_code = 8 then
    limit = 20
    sidebar_type = 1
else
    limit = 999999

    sidebar_type = 2
end if

if (category_code >= 32 and category_code <= 128) or category_code = 256 then
    header = true
end if
%>
<% Call render_sidebar(articlesObj, category_code, sidebar_type, header, limit) %>
<!-- Siderbar end -->
</td>
<td width="10" valign="top">&nbsp;</td>
<td width="740" valign="top" id="id_content">
<table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<% Call render_header_image(category_code) %>
</td>
</tr>
<tr>
<td height="8"></td>
</tr>
<tr>
<td valign="top" bgcolor="#999999">
<table width="100%" border="0" cellspacing="1" cellpadding="10">
<tbody>
<tr>
<td valign="top" bgcolor="#EEF0FC">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td valign="top" class="conthead">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td valign="top"><strong>
<% if articleObj.item(0).selectNodes(lang_index_chr & "/alt_title").length > 0 then %>
<% if articleObj.item(0).selectSingleNode(lang_index_chr & "/alt_title").text <> "" then %>
<%= articleObj.item(0).selectSingleNode(lang_index_chr & "/alt_title").text %>
<% else %>
<%= articleObj.item(0).selectSingleNode(lang_index_chr & "/title").text %>
<% end if %>
<% else %>
<%= articleObj.item(0).selectSingleNode(lang_index_chr & "/title").text %>
<% end if %>
</strong></td>
</tr>
<tr>
<td valign="top">&nbsp;</td>
</tr>
</tbody>
</table>
</td>
</tr>
<tr>
<td valign="top" class="content" id="">
<%= articleObj.item(0).selectSingleNode(lang_index_chr & "/content").text %>
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
</td>
</tr>