<!--#include file="libraries.asp" -->
<%
Dim LIMIT, OFFSET, lang
Dim objXml, lang_index
Dim prev_page, page, next_page
Dim obj, item
' 1 - EN; 2 - BM; 3 - CHI '
lang = base_lang
lang_index = lang

page = 1

if Request("page") <> "" and IsNumeric(Request("page")) then
    page = CInt(Request("page"))
end if

prev_page = page
next_page = page

set objXml = GetIndexedArticles("service_centres")
set obj = objXml.selectNodes("service_centres/service_centre")
Dim service_centre_id, country_name, is_main, content_filename
Dim counter
index = 0
counter = 0
%>
<td width="180" valign="top">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td colspan="2">
<table width="180"  border="0" cellspacing="0" cellpadding="1">
<tr>
<td bgcolor="#5A71AB">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="8" height="25" background="img/header.gif">&nbsp;</td>
<% if lang = 2 then %>
<td width="168" background="img/header.gif" class="smallhead">Pusat Servis</td>
<% elseif lang = 3 then %>
<td width="168" background="img/header.gif" class="smallhead">服务中心</td>
<% else %>
<td width="168" background="img/header.gif" class="smallhead">Service Centres</td>
<% end if %>
</tr>
</table>
</td>
<tr>
<td height="5"></td>
</tr>
<%
OFFSET = 9999
for each item in obj
    service_centre_id_local = item.childNodes(0).text
    country_name = item.childNodes(lang_index).text
    is_main = item.childNodes(4).text
    content_filename = item.childNodes(5).text
    
    if LCase(is_main) = "true" then
        service_centre_id = service_centre_id_local
    end if
    %>
    <tr>
    <td bgcolor="#5A71AB">
    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td width="25" height="23" align="center" background="img/buttonbg_lightblue.gif"><img src="img/buttonbg_lightblue_icon.gif" width="15" height="15" /></td>
    <td width="163" background="img/buttonbg_lightblue.gif"><a class="iflink" href="service_centres.asp?id=<%= service_centre_id_local %>&amp;title=<%= Server.HTMLEncode(Replace(country_name, " ", "")) %>" target="_top" title="<%= country_name %>"><%= country_name %></td>
    </tr>
    </table>
    </td>
    </tr>
    <tr>
    <td height="3"></td>
    </tr>
    <%
next
%>
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
                                <td><img src="img/banner_servicecentres.jpg" width="740" height="170" /></td>
                            </tr>
                            <tr>
                                <td height="8"></td>
                            </tr>
                            <tr>
                                <td valign="top" bgcolor="#999999">
                                    <table width="100%" border="0" cellspacing="1" cellpadding="10">
                                        <tr>
                                            <td valign="top" bgcolor="#EEF0FC">
<%
if Request("id") <> "" and IsNumeric(Request("id")) then
    service_centre_id = Cint(Request("id"))
end if
set obj = getSCContent(service_centre_id & ".xml")
Dim lang_index_chr
lang_index_chr = "en"
if lang = 2 then
    lang_index_chr = "bm"
elseif lang = 3 then
    lang_index_chr = "chi"
end if
%>
<%= obj.item(0).selectSingleNode(lang_index_chr & "/content").text %>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>