<% Function render_sidebar(obj, category_code, sidebar_type, header, limit) %>
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="id_sidebar">
<tr>
<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-bottom: 25px;">
<tr>
<td colspan="2">
<table width="100%" border="0" cellspacing="0" cellpadding="0"<% if sidebar_type = 1 then %> style="border: 1px solid #5A71AB;"<% end if %>>
<tbody>
<tr>
<td width="15px" background="img/header.gif"></td>

<!-- Extra header on sidebar -->
<% if header = true then %>
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
<% end if %>
<% end if %>
<!-- End of extra header -->

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
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>产品<% elseif lang = 2 then %>Produk<% else %>Products<% end if %></td>
<% elseif category_code = 512 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>收益计划<% elseif lang = 2 then %>Pelan Pendapatan<% else %>Income Plan<% end if %></td>
<% elseif category_code = 1024 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>疑问回答<% elseif lang = 2 then %>FAQ<% else %>FAQ<% end if %></td>
<% elseif category_code = 2048 then %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>见证录影<% elseif lang = 2 then %>Videos<% else %>Videos<% end if %></td>
<% else %>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>新闻与活动<% elseif lang = 2 then %>Berita dan Aktiviti<% else %>News &amp; Events<% end if %></td>
<% end if %>
</tr>
<tr valign="top">
<!-- Sidebar type 1 -->
<% if sidebar_type = 1 then %>
<td colspan="2" bgcolor="#5A71AB" class="left-news">
<ul>
<!-- End of Sidebar type 1 -->
<% end if %>
<%
Dim counter, OFFSET, index
OFFSET = limit
index = 0
counter = 0
Dim article_id, title, index_image_url, publish, publish_start_date, category_code_local, item
for each item in obj
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
            if sidebar_type = 1 then
                %><li><a href="article.asp?category_code=<%= category_code %>&amp;article_id=<%= article_id %>&amp;title=<%= Replace(title, " ", "") %>" target="_top" title="<%= title %>"><%= title %></a></li><%
            else
            %>
                <tr><td height="3" colspan="2"></td></tr>
                <tr>
                    <td colspan="2" bgcolor="#5A71AB">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="25" height="23" align="center" background="img/buttonbg_lightblue.gif">
                                        <img src="img/buttonbg_lightblue_icon.gif" width="15" height="15">
                                    </td>
                                    <td width="163" background="img/buttonbg_lightblue.gif">
                                        <a style="max-height: 30px; max-width: 150px;" class="iflink" href="article.asp?category_code=<%= category_code %>&amp;article_id=<%= article_id %>&amp;title=<%= Replace(title, " ", "") %>" target="_top" title="<%= title %>"><%= title %></a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            <%
            end if
            counter = counter + 1
        end if
        if counter >= OFFSET then
            Exit For
        end if
    end if
next
%>
<!-- Sidebar type 1 -->
<% if sidebar_type = 1 then %>
</ul>
</td>
<% end if %>
<!-- End of Sidebar type 1 -->
</tr>
<% if not limit > 99999 and sidebar_type = 1 then %>
<tr>
<td colspan="2" bgcolor="#5A71AB" align="right">
<div style="margin-right: 10px; margin-bottom: 10px;">
<a href="news.asp?lang=<%= lang %>&amp;category_code=<%= category_code %>" target="_top">
<img src="img/more.gif" width="46px" height="15px" border="0" />
</a>
</div>
</td>
</tr>
<% end if %>
</tbody>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
<% End Function %>