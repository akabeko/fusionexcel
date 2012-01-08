<%
' Dependancies: The parent file must included libraries before run this files '
Dim OFFSET, lang, category_code
Dim objXml, lang_index
Dim prev_page, page, next_page
' 1 - EN; 2 - BM; 3 - CHI '
lang = base_lang
' 1 - News & Event, 2 - Charities, 3 - Sponsorship '
category_code = 1
lang_index = lang

page = 1

if Request("category_code") and IsNumeric(Request("category_code")) then
    category_code = CInt(Request("category_code"))
end if

if Request("page") <> "" and IsNumeric(Request("page")) then
    page = CInt(Request("page"))
end if

prev_page = page
next_page = page

Dim articlesObj, item

set objXml = GetIndexedArticles(category_code)
set articlesObj = objXml.selectNodes("articles/article")
Dim firstArticleIndex

%>
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
<td width="740" valign="top">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
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
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td height="30" align="right" valign="top">
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
<table width="100%" border="0" cellspacing="0" cellpadding="2">
<tbody>
<tr>
<td width="55%" align="right" class="smallcont">Page <%= page %> of <%= total_page %></td>
<td align="right" class="smallcont">
<a href="news.asp?category_code=<%= category_code %>&amp;page=1" target="_top">Latest</a>&nbsp;|&nbsp;
<% if page > 1 and page =< total_page then %>
    <a href="news.asp?category_code=<%= category_code %>&amp;page=<%= prev_page %>" target="_top">Back</a>&nbsp;|&nbsp;
<% end if %>
<a href="news.asp?category_code=<%= category_code %>&amp;page=<% if page >= total_page then %><%= total_page %><% else %><%= next_page %><% end if %>" target="_top">Next</a>&nbsp;|&nbsp;
<a href="news.asp?category_code=<%= category_code %>&amp;page=<%= total_page %>" target="_top">Last</a>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
<tr>
<td class="news-eve">
<ul>
<%
Dim index
index = 0
counter = 0

for each item in articlesObj
    category_code_local = CInt(item.childNodes(10).text)
    if (((category_code_local \ category_code) mod 2) = 1) then
        article_id = item.childNodes(0).text
        title = item.childNodes(lang_index).text
        index_image_url = item.childNodes(4).text
        publish = item.childNodes(5).text
        publish_start_date = item.childNodes(6).text
        
        if (IsDate(publish_start_date)) then
            if CDate(publish_start_date) >= now() then
                publish = "False"
            end if
        end if
                
        if LCASE(publish) = "true" then
            if index >= (page * OFFSET - OFFSET) then
                %><li><a href="article.asp?category_code=<%= category_code %>&amp;article_id=<%= article_id %>&amp;title=<%= Replace(title, " ", "") %>" target="_top" title="<%= title %>"><%= title %></a></li><%
                counter = counter + 1
            end if
            index = index + 1
        end if
        if counter >= OFFSET then
            Exit For
        end if
    end if
next
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
<a href="news.asp?category_code=<%= category_code %>&amp;page=1" target="_top">Latest</a>&nbsp;|&nbsp;
<% if page > 1 and page =< total_page then %>
    <a href="news.asp?category_code=<%= category_code %>&amp;page=<%= prev_page %>" target="_top">Back</a>&nbsp;|&nbsp;
<% end if %>
<a href="news.asp?category_code=<%= category_code %>&amp;page=<% if page >= total_page then %><%= total_page %><% else %><%= next_page %><% end if %>" target="_top">Next</a>&nbsp;|&nbsp;
<a href="news.asp?category_code=<%= category_code %>&amp;page=<%= total_page %>" target="_top">Last</a>
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
</table>
</td>
</tr>