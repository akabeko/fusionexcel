<%@ CodePage=65001 %>
<!--#include file="libraries.asp" -->
<%
Dim category
category = "news"

if Request("category_code") <> "" then
	category = Request("category_code")
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="<% if base_lang = 3 then %>zh<% else %>en<% end if %>">
<head>
<title>FusionExcel</title>
<meta name="keywords" content="" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="robots" content="all" /> 
<meta name="distribution" content="global" /> 
<meta name="author" content="FusionExcel International" /> 
<meta name="designer" content="KLHunter.com - Web Design Management" />
<meta name="copyright" content="FusionExcel International © All Rights Reserved" />

<link href="fe.css" rel="stylesheet" type="text/css" />
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
        </tr>
        <!--#include file="render_links.asp" -->
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
