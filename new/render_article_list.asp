<%
' Dependancies: The parent file must included libraries before run this files '
Dim LIMIT, OFFSET, lang, category_code
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
Dim index_image_url, title, article_id, publish, publish_start_date, category_code_local
Dim firstArticleIndex, counter
index = 0
counter = 0
%>
<tr>
<td width="180" valign="top">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td colspan="2">
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #5A71AB">
<tbody>
<tr>
<td width="15px" background="img/header.gif"></td>
<% if category_code = 2 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>慈善活动<% elseif lang = 2 then %>Acara Amal<% else %>Charities<% end if %></td>
<% elseif category_code = 4 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>赞助<% elseif lang = 2 then %>Tajaan<% else %>Sponsorships<% end if %></td>
<% elseif category_code = 8 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>公司代言人<% elseif lang = 2 then %>Jurucakap Syarikat<% else %>Company Spokepersons<% end if %></td>
<% elseif category_code = 16 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>科技伙伴<% elseif lang = 2 then %>Rakan Kongsi Teknologi<% else %>Technology Partners<% end if %></td>
<% elseif category_code = 32 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>宇宙天然能量石<% elseif lang = 2 then %>Loket Kuantum<% else %>Testimonials (QP)<% end if %></td>
<% elseif category_code = 64 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>量子美容肥皂<% elseif lang = 2 then %>Bar Kecantikan Kuantum<% else %>Testimonials (QBB)<% end if %></td>
<% elseif category_code = 128 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>宇宙天然能量充电器<% elseif lang = 2 then %>Pengecas Kuantum<% else %>Testimonials (QC)<% end if %></td>
<% else %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>新闻与活动<% elseif lang = 2 then %>Berita dan Aktiviti<% else %>News &amp; Events<% end if %></td>
<% end if %>
</tr>
<tr valign="top">
<td colspan="2" bgcolor="#5A71AB" class="left-news">
<ul>
<%
OFFSET = 20
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
            %><li><a href="article.asp?article_id=<%= article_id %>&amp;title=<%= Replace(title, " ", "") %>" target="_top" title="<%= title %>"><%= title %></li><%
            counter = counter + 1
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
<td colspan="2" bgcolor="#5A71AB" align="right">
<div style="margin-right: 10px; margin-bottom: 10px;">
<a href="news.asp?lang=<%= lang %>&amp;category_code=<%= category_code %>" target="_top">
<img src="img/more.gif" width="46px" height="15px" border="0" />
</a>
</div>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</td>
<td width="10" valign="top">&nbsp;</td>
<td width="740" valign="top">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<% if category_code = 2 then %>
<td><img src="img/banner_charities.jpg" width="740" height="170" /></td>
<% elseif category_code = 4 then %>
<td><img src="img/banner_sponsor.jpg" width="740" height="170" /></td>
<% else %>
<td><img src="img/banner_news.jpg" width="740" height="170" /></td>
<% end if %>
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
total_page = Round(total_record / OFFSET, 0)

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