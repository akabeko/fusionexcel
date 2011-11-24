<%
Dim category
category = "news"

if Request("category") <> "" then
	category = Request("category")
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<title>FusionExcel - News & Events - News & Events</title>
<meta name="keywords" content="News & Events" />
<meta name="description" content="Lists of News and Events in page 02 of 25." />
<meta charset="ISO-8859-1" />
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
        <tr>
          <td width="180" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td colspan="2">
					    <script type="text/javascript">
							// CMS Code Start Here
							var iframesrc="news_list.asp?type=sidebar&lang=<%= Request("lang") %>&category=<%= Request("category") %>"
							document.write('<iframe id="datamain" name="myframe" src="'+iframesrc+'" ALLOWTRANSPARENCY="true" width="180px" height="1145px" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>')
							// End of CMS code
						</script>
                      </td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td width="10" valign="top">&nbsp;</td>
          <td width="740" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
				<% if category = "charity" then %>
					<td><img src="img/banner_charities.jpg" width="740" height="170" /></td>
				<% elseif category = "sponsorships" then %>
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
					<script type="text/javascript">
						// CMS Code Start Here
						var iframesrc="news_list.asp?lang=<%= Request("lang") %>&category=<%= Request("category") %><% if not Request("page") = "" then %>&page=<%= Request("page") %><% end if %>"
						document.write('<iframe id="datamain" name="myframe" src="'+iframesrc+'" ALLOWTRANSPARENCY="true" width="740px" height="1512px" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>')
						// End of CMS Code
					</script>
                </td>
              </tr>
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
