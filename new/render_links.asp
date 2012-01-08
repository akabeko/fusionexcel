<%
' Dependancies: The parent file must included libraries before run this files '
Dim OFFSET, lang, link_type
Dim objXml, lang_index
' 1 - EN; 2 - BM; 3 - CHI '
lang = base_lang
link_type = 1
lang_index = lang

if Request("link_type") <> "" and IsNumeric(Request("link_type")) then
    link_type = CInt(Request("link_type"))
end if

Dim linkObjs, item

set objXml = GetIndexedLinks(link_type)
set linkObjs = objXml.selectNodes("links/link")

%>
<tr>
<td width="180" valign="top">
<!-- Siderbar Start -->
<%
if link_type = 1 then
    Dim articlesObj, objXml2
    set objXml2 = GetIndexedArticles(16)
    set articlesObj = objXml2.selectNodes("articles/article")
    Call render_sidebar(articlesObj, 16, 2, false, 10)
    
    set objXml2 = GetIndexedArticles(8)
    set articlesObj = objXml2.selectNodes("articles/article")
    Call render_sidebar(articlesObj, 8, 2, false, 20)
    
elseif link_type = 2 then
    
end if
%>
<!-- Siderbar end -->
</td>
<td width="10" valign="top">&nbsp;</td>
<td width="740" valign="top">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<% if link_type = 1 then %>
    <img src="img/QP_VIP.jpg" width="740" height="170" />
<% elseif link_type = 2 then %>
    <img src="img/banner_testimonials_video.jpg" width="740" height="170" />
<% end if %>
</td>
</tr>
<tr>
<td height="8"></td>
</tr>
<tr>
<td valign="top">

</td>
</tr>
</table>
</td>
</tr>