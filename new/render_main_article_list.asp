<!--#include file="libraries.asp" -->
<%
Dim LIMIT, OFFSET, lang, category_code
Dim objXml, lang_index
' 1 - EN; 2 - BM; 3 - CHI '
lang = base_lang
' 1 - News & Event, 2 - Charities, 3 - Sponsorship '
category_code = 1
OFFSET = 20

if Request("category_code") and IsNumeric(Request("category_code")) then
    category_code = CInt(Request("category_code"))
end if

lang_index = lang


Dim articlesObj, item

set objXml = GetIndexedArticles(category_code)
set articlesObj = objXml.selectNodes("articles/article")
Dim index_image_url, title, article_id, publish, publish_start_date, category_code_local
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="<% if lang = "chi" then %>zh<% else %>en<% end if %>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<link href="<%= GetFrontendCSSPath() %>fe.css" rel="stylesheet" type="text/css">
</head>
<body>
<%
Dim firstArticleIndex, index, counter
index = 0
counter = 0
firstArticleIndex = 0
for each item in articlesObj
    category_code_local = CInt(item.childNodes(10).text)
    if (((category_code_local \ category_code) mod 2) = 1) then
        article_id = item.childNodes(0).text
        title = item.childNodes(lang_index).text
        index_image_url = item.childNodes(4).text
        publish = item.childNodes(5).text
        publish_start_date = item.childNodes(6).text
        this_category_code = item.childNodes(10).text
        
        if (((category_code \ this_category_code) mod 2) = 1) then
            if LCASE(publish) = "true" then
                Dim is_publish
                is_publish = true
                if publish_start_date <> "" then
                    if IsDate(publish_start_date) then
                        if CDate(publish_start_date) < now() then
                            is_publish = true
                        else
                            is_publish = false
                        end if
                    end if
                end if
                if is_publish  then
                    %>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td height="35px" bgcolor="#e8edf0" class="fe2"><span style="margin-left: 10px;"><% if lang = 2 then %>Berita and Aktiviti<% elseif lang = 3 then %>新闻与活动<% else %>News &amp; Events<% end if %></span></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td colspan="3" align="center" bgcolor="#e8edf0">
                                                    <a href="article.asp?lang=<%= lang %>&amp;category=<%= category_code %>&amp;article_id=<%= article_id %>&amp;title=<%= Replace(title, " ", "") %>" target="_top">
                                                        <img src="<%= index_image_url %>" width="355px" height="149px" style="border:#999 solid 1px" title="<%= title %>">
                                                    </a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="48%" height="5" align="right" bgcolor="#e8edf0"></td>
                                                <td width="10" height="5" bgcolor="#e8edf0"></td>
                                                <td width="48%" height="5" bgcolor="#e8edf0"></td>
                                            </tr>
                                            <tr class="fe3">
                                                <td colspan="3" align="center" bgcolor="#e8edf0">
                                                    <img src="img/bar_arrow.gif" width="12" height="12">
                                                    <a href="article.asp?lang=<%= lang %>&amp;category=<%= category_code %>&amp;article_id=<%= article_id %>&amp;title=<%= Replace(title, "", "_") %>" target="_top"><%= title %></a>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <%
                    Exit For
                end if
            end if
        end if
        firstArticleIndex = firstArticleIndex + 1
    end if
next
%>
<table width="100%" height="460px" border="0" cellpadding="0" cellspacing="0">
<tbody>
<tr>
<td width="100" height="282" valign="top">
<table width="376px" border="0" cellpadding="0" cellspacing="0" bgcolor="#e8edf0">
<tbody>
<tr>
<td valign="top" bgcolor="#e8edf0" class="left-news_myo">
<ul>
<%
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
        
        if LCASE(publish) = "true" and index > firstArticleIndex then
            %><li><a href="article.asp?article_id=<%= article_id %>&amp;title=<%= Replace(title, " ", "_") %>" target="_top" title="<%= title %>"><% if Len(title) > 50 then %><%= Left(title, 50) %>...</a><% else %><%= title %><% end if %></li><%
            counter = counter + 1
        end if
        index = index + 1
        if counter >= OFFSET then
            Exit For
        end if
    end if
next
%>
</ul>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
<tr valign="bottom">
<td height="20" align="center" bgcolor="#e8edf0"><a href="news.asp?lang=<%= lang %>&amp;category_code=1" target="_top"><img src="img/more.gif" width="46" height="15" border="0"></a></td>
</tr>
</tbody>
</table>
</body>
</html>