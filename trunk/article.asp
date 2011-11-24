<!--#include file="data/dbCon.asp" -->
<%
call OpenDatabase()

Dim article_id, lang
article = 0
lang = "en"

if not Request("article_id") = "" then
	if IsNumeric(Request("article_id")) then
		article_id = Request("article_id")
	end if
end if

if Request("lang") <> "" then
	if Request("lang") = "chi" then
		lang = "chi"
	elseif Request("lang") = "en" then
		lang = "en"
	end if
end if

if lang = "chi" then
	sql = "SELECT id, title_chi as title, content_chi as content, meta_robots_chi as meta_robots, meta_author_chi as meta_author, meta_description_chi as meta_description, meta_keywords_chi as meta_keywords FROM tbl_article WHERE publish = true AND id = " & article_id
elseif lang = "bm" then
	sql = "SELECT id, title_bm as title, content_bm as content, meta_robots_bm as meta_robots, meta_author_bm as meta_author, meta_description_bm as meta_description, meta_keywords_bm as meta_keywords FROM tbl_article WHERE publish = true AND id = " & article_id
else
	sql = "SELECT id, title, content, meta_robots, meta_author, meta_description, meta_keywords FROM tbl_article WHERE publish = true AND id = " & article_id
end if

call CreateRecordSet(RecordSet, sql)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<title>FusionExcel - News & Events - News & Events Page 01 of 27.</title>
<meta name="description" content="<% if RecordSet("meta_description") <> "" then %><%= RecordSet("meta_description") %><% else %><% end if %>">
<meta name="keywords" content="<% if RecordSet("meta_keywords") <> "" then %><%= RecordSet("meta_keywords") %><% else %>FusionExcel International<% end if %>">
<meta charset="ISO-8859-1" />
<meta name="robots" content="<% if RecordSet("meta_robots") <> "" then %><%= RecordSet("meta_robots") %><% else %>all<% end if %>">
<meta name="distribution" content="global" /> 
<meta name="author" content="<% if RecordSet("meta_author") <> "" then %><%= RecordSet("meta_author") %><% else %>FusionExcel International<% end if %>">
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
        </tr>
        <tr>
          <td width="180" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td colspan="2">
					    <script type="text/javascript">
							var iframesrc="news_list.asp?lang=<%= Request("lang") %>&category=<%= Request("categoery") %>&type=sidebar"
							document.write('<iframe id="datamain" name="myframe" src="'+iframesrc+'" ALLOWTRANSPARENCY="true" width="180px" height="1145px" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>')
						</script>
                      </td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td width="10" valign="top">&nbsp;</td>
          <td width="740" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td><img src="img/banner_news.jpg" width="740" height="170" /></td>
              </tr>
              <tr>
                <td height="8"></td>
              </tr>
              <tr>
                <td valign="top" bgcolor="#999999">
					<table width="100%" border="0" cellspacing="1" cellpadding="10">
						<tbody>
							<tr>
								<td height="950" valign="top" bgcolor="#EEF0FC">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tbody>
											<tr>
												<td valign="top" class="conthead">
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tbody>
															<tr>
																<td valign="top"><strong><%= RecordSet("title") %></strong></td>
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
													<%= RecordSet("content") %>
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
            </tbody></table>
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
