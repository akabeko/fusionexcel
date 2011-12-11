<!--#include file="libraries.asp" -->
<%
Dim articleObj, lang, article_id
Dim lang_index
' 1 - EN; 2 - BM; 3 - CHI '
lang = base_lang
' 1 - News & Event, 2 - Charities, 3 - Sponsorship '
lang_index = lang
lang_index_chr = "en"

article_id = 0

if lang = 2 then
    lang_index_chr = "bm"
elseif lang = 3 then
    lang_index_chr = "chi"
end if

if Request("category_code") and IsNumeric(Request("category_code")) then
    category_code = CInt(Request("category_code"))
end if

if Request("article_id") <> "" and IsNumeric(Request("article_id")) then
    article_id = CInt(Request("article_id"))
end if

set articleObj = getArticleContent(article_id & ".xml")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<title>FusionExcel - News & Events - News & Events Page 01 of 27.</title>
<meta name="description" content="<% if articleObj.item(0).selectSingleNode(lang_index_chr & "/meta/description").text <> "" then %><%= articleObj.item(0).selectSingleNode(lang_index_chr & "/meta/description").text %><% else %><% end if %>">
<meta name="keywords" content="<% if articleObj.item(0).selectSingleNode(lang_index_chr & "/meta/keyword").text <> "" then %><%= articleObj.item(0).selectSingleNode(lang_index_chr & "/meta/keyword").text %><% else %>FusionExcel International<% end if %>">
<meta charset="ISO-8859-1" />
<meta name="robots" content="<% if articleObj.item(0).selectSingleNode(lang_index_chr & "/meta/robots").text<> "" then %><%= articleObj.item(0).selectSingleNode(lang_index_chr & "/meta/robots").text %><% else %>all<% end if %>">
<meta name="distribution" content="global" /> 
<meta name="author" content="<% if articleObj.item(0).selectSingleNode(lang_index_chr & "/meta/author").text <> "" then %><%= articleObj.item(0).selectSingleNode(lang_index_chr & "/meta/author").text %><% else %>FusionExcel International<% end if %>">
<meta name="designer" content="KLHunter.com - Web Design Management" />
<meta name="copyright" content="FusionExcel International ?All Rights Reserved" />
<link href="/css/fe.css?1" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
body {
	background-image: url(img/bg.gif);
	margin-left: 0px;
	margin-top: 20px;
	margin-right: 0px;
	margin-bottom: 20px;
}
-->
</style>
</head>
<body>
<table width="950" border="0" align="center" cellpadding="0" cellspacing="10" bgcolor="#FFFFFF">
  <!--DWLayoutTable-->
  <tr>
    <td valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr valign="top">
          <td colspan="3" height="114px"><script type="text/javascript">
				var iframesrc="topframe.asp"
				document.write('<iframe id="datamain" name="myframe" src="'+iframesrc+'" ALLOWTRANSPARENCY="true" width="930px" height="114px" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>')
	    </script>
          </td>
            <!--#include file="render_article.asp" -->
            </table></td>
        </tr>
        <tr>
          <td colspan="3" height="10"></td>
        </tr>
        <tr>
          <td colspan="3"><iframe src="iframe_bottom.html" width="930" height="28" marginwidth="0" marginheight="0" frameborder="0" scrolling="No"></iframe></td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
