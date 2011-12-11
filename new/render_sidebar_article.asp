<!--#include file="libraries.asp" -->
<%
Dim LIMIT, OFFSET, lang, category_code
Dim objXml, lang_index
' 1 - EN; 2 - BM; 3 - CHI '
lang = base_lang
' 1 - News & Event, 2 - Charities, 3 - Sponsorship '
category_code = 1
OFFSET = 20

lang_index = lang

if Request("category_code") <> "" and IsNumeric(Request("category_code")) then
    category_code = CInt(Request("category_code"))
end if

Dim articlesObj, item

set objXml = GetIndexedArticles(category_code)
set articlesObj = objXml.selectNodes("articles/article")
Dim index_image_url, title, article_id, publish, publish_start_date
Dim counter
counter = 0
%>
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

<%
for each item in articlesObj
    article_id = item.childNodes(0).text
    title = item.childNodes(lang_index).text
    index_image_url = item.childNodes(4).text
    publish = item.childNodes(5).text
    publish_start_date = item.childNodes(6).text
    
    if LCASE(publish) = "true" then
        if (IsDate(publish_start_date) and CDate(publish_start_date) < now()) or publish_start_date = "" then
            %><li><a href="article.asp?lang=<%= lang %>article_id=<%= article_id %>&amp;title=<%= Replace(title, " ", "") %>" target="_top" title="<%= title %>"><%= title %></li><%
            counter = counter + 1
        end if
    end if
    if counter >= OFFSET then
        Exit For
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