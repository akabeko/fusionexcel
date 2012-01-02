<%
' Libraries and others param define on the parent files '
Dim LIMIT, OFFSET, objXml
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
<td width="180" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td colspan="2">
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid #5A71AB">
<tbody>
<tr>
<td width="15px" background="img/header.gif"></td>
<% if category_code >= 32 and category_code <= 128 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>见证篇<% elseif lang = 2 then %>Testimoni<% else %>Testimonials<% end if %></td>
</tr>
<td colspan="2" bgcolor="#FFF" class="left-news">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="25px" height="30px" align="center" background="img/buttonbg_lightblue.gif">
<img src="img/buttonbg_lightblue_icon.gif" width="15px" height="15px">
<td>
<td width="163px" background="img/buttonbg_lightblue.gif">
<a href="test_MLP.html"><% if lang = 3 then %>商家忠诚计划<% elseif lang = 2 then %>Program Kesetiaan Pedagang<% else %>Merchant Loyalty Program<% end if %></a>
</td>
</tr>
<tr>
<td width="25px" height="30px" align="center" background="img/buttonbg_lightblue.gif">
<img src="img/buttonbg_lightblue_icon.gif" width="15px" height="15px">
<td>
<td width="163px" background="img/buttonbg_lightblue.gif">
<a href="news.asp?category_code=32"><% if lang = 3 then %>宇宙天然能量石<% elseif lang = 2 then %>Loket Kuantum<% else %>Quantum Pendant<% end if %></a>
</td>
</tr>
<tr>
<td width="25px" height="30px" align="center" background="img/buttonbg_lightblue.gif">
<img src="img/buttonbg_lightblue_icon.gif" width="15px" height="15px">
<td>
<td width="163px" background="img/buttonbg_lightblue.gif">
<a href="news.asp?category_code=64"><% if lang = 3 then %>量子美容肥皂<% elseif lang = 2 then %>Bar Kecantikan Kuantum<% else %>Quantum Beautybar<% end if %></a>
</td>
</tr>
<tr>
<td width="25px" height="30px" align="center" background="img/buttonbg_lightblue.gif">
<img src="img/buttonbg_lightblue_icon.gif" width="15px" height="15px">
<td>
<td width="163px" background="img/buttonbg_lightblue.gif">
<a href="news.asp?category_code=128"><% if lang = 3 then %>宇宙天然能量充电器(QC)<% elseif lang = 2 then %>Pengecas Kuantum (QC)<% else %>Quantum Charger (QC)<% end if %></a>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td width="15px" background="img/header.gif"></td>
<% end if %>
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
<% elseif category_code = 256 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>产品注册<% elseif lang = 2 then %> Pendaftaran Produk<% else %>Product Registration<% end if %></td>
</tr>
<tr>
<td colspan="2" bgcolor="#FFF" class="left-news">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="25px" height="30px" align="center" background="img/buttonbg_lightblue.gif">
<img src="img/buttonbg_lightblue_icon.gif" width="15px" height="15px">
</td>
<td width="163px" background="img/buttonbg_lightblue.gif">
<a href="products_registration.html"><% if lang = 3 then %>产品注册<% elseif lang = 2 then %>Pendaftaran Produk<% else %>Product Registration<% end if %></a>
</td>
</tr>
</table>
</td>
</tr>
<tr>
<td width="15px" background="img/header.gif"></td>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>产品<% elseif lang = 2 then %>Produk<% else %>Products<% end if %></td>
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
        article_id_local = item.childNodes(0).text
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
            %><li><a href="article.asp?article_id=<%= article_id_local %>&amp;title=<%= Replace(title, " ", "") %>" target="_top" title="<%= title %>"><%= title %></li><%
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
</table></td>
<td width="10" valign="top">&nbsp;</td>
<td width="740" valign="top">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<% if category_code = 2 then %>
<td><img src="img/banner_charities.jpg" width="740" height="170" /></td>
<% elseif category_code = 4 then %>
<td><img src="img/banner_sponsor.jpg" width="740" height="170" /></td>
<% elseif category_code = 8 then %>
<td><img src="img/banner_companyspokesmen.jpg" width="740" height="170" /></td>
<% elseif category_code = 16 then %>
<td><img src="img/banner_corporate.jpg" width="740" height="170" /></td>
<% elseif category_code = 32 then %>
<td><img src="img/banner_testimonial.jpg" width="740" height="170" /></td>
<% elseif category_code = 64 then %>
<td><img src="img/banner_beauty.jpg" width="740" height="170" /></td>
<% elseif category_code = 128 then %>
<td><img src="img/banner_qc.jpg" width="740" height="170" /></td>
<% elseif category_code = 256 then %>
<td><img src="img/banner_quantumscience.jpg" width="740" height="170" /></td>
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
<td valign="top" class="conthead">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
<td valign="top" class="content">
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