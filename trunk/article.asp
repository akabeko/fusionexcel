<!--#include file="data/dbCon.asp" -->
<%
call OpenDatabase()

Dim article_id
article = 0
if not Request("article_id") = "" then
	if IsNumeric(Request("article_id")) then
		article_id = Request("article_id")
	end if
end if

sql = "SELECT id, title, content FROM tbl_article WHERE category = 'news' AND publish = true AND id = " & article_id

call CreateRecordSet(RecordSet, sql)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0090)http://www.fusionexcel.com/news_FeDonatesAndSponsorsRM123660000ToVariousOrganisations.html -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>FusionExcel – News &amp; Events – FE Donates And Sponsors RM 1,236,600.00 To Various Organisations, 25th September 2011!</title>
<meta charset="ISO-8859-1">
<meta name="robots" content="all">
<meta name="distribution" content="global">
<meta name="author" content="FusionExcel International">
<meta name="designer" content="KLHunter.com - Web Design Management">
<meta name="copyright" content="FusionExcel International © All Rights Reserved">

<link href="./article_files/fe.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
body {
	background-image: url(img/bg.gif);
	margin-left: 0px;
	margin-top: 20px;
	margin-right: 0px;
	margin-bottom: 20px;
}
a:link {
	text-decoration: none;
	color: #00F;
}
a:visited {
	text-decoration: none;
	color: #00F;
}
a:hover {
	text-decoration: none;
	color: #F00;
}
a:active {
	text-decoration: none;
	color: #F00;
}
-->
</style>

<script src="chrome-extension://lifbcibllhkdhoafpjfnlhfpfgnpldfl/document_iterator.js"></script><script src="chrome-extension://lifbcibllhkdhoafpjfnlhfpfgnpldfl/find_proxy.js"></script><script src="chrome-extension://lifbcibllhkdhoafpjfnlhfpfgnpldfl/get_html_text.js"></script><script src="chrome-extension://lifbcibllhkdhoafpjfnlhfpfgnpldfl/global_constants.js"></script><script src="chrome-extension://lifbcibllhkdhoafpjfnlhfpfgnpldfl/name_injection_builder.js"></script><script src="chrome-extension://lifbcibllhkdhoafpjfnlhfpfgnpldfl/number_injection_builder.js"></script><script src="chrome-extension://lifbcibllhkdhoafpjfnlhfpfgnpldfl/string_finder.js"></script><script src="chrome-extension://lifbcibllhkdhoafpjfnlhfpfgnpldfl/change_sink.js"></script><meta name="document_iterator.js"><meta name="find_proxy.js"><meta name="get_html_text.js"><meta name="global_constants.js"><meta name="name_injection_builder.js"><meta name="number_injection_builder.js"><meta name="string_finder.js"><meta name="change_sink.js"></head>

<body>

<table width="950" border="0" align="center" cellpadding="0" cellspacing="10" bgcolor="#FFFFFF">
  <!--DWLayoutTable-->
  <tbody><tr>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tbody><tr valign="top">
        <td colspan="3" height="114px"><script type="text/javascript">
				//var iframesrc="topframe.asp"
				//document.write('<iframe id="datamain" name="myframe" src="'+iframesrc+'" ALLOWTRANSPARENCY="true" width="930px" height="114px" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>')
	    </script><iframe id="datamain" name="myframe" src="./article_files/topframe.htm" allowtransparency="true" width="930px" height="114px" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
        </td>
      </tr>
      <tr>
        <td width="180" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody><tr>
            <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody><tr>
                  <td colspan="2">
					<script type="text/javascript">
					var iframesrc="news_list.asp?type=sidebar"
					document.write('<iframe id="datamain" name="myframe" src="'+iframesrc+'" ALLOWTRANSPARENCY="true" width="180px" height="1100px" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>')
					</script>
                  </td>
                </tr>
            </tbody></table></td>
          </tr>
        </tbody></table></td>
        <td width="10" valign="top">&nbsp;</td>
        <td width="740" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody><tr>
            <td><img src="./article_files/banner_news.jpg" width="740" height="170"></td>
          </tr>
          <tr>
            <td height="8"></td>
          </tr>
          <tr>
            <td valign="top" bgcolor="#999999"><table width="100%" border="0" cellspacing="1" cellpadding="10">
              <tbody><tr>
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
            </tbody></table></td>
          </tr>
        </tbody></table></td>
      </tr>
      <tr>
        <td colspan="3" height="10"></td>
      </tr>
      <tr>
        <td colspan="3"><iframe src="./article_files/iframe_bottom.htm" width="930" height="28" marginwidth="0" marginheight="0" frameborder="0" scrolling="No"></iframe></td>
      </tr>
    </tbody></table>
   </td>
  </tr>
</tbody></table>

</body></html>
<%
call CloseRecordSet(RecordSet)
call CloseDatabase()
%>