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
<title>FusionExcel - 
<% if Request("category_code") = "2" then %>
<%if base_lang = 3 then %>慈善活动<% elseif base_lang = 2 then %>Acara Amal<% else %>Charities<% end if %>
<% elseif Request("category_code") = "4" then %>
<%if base_lang = 3 then %>赞助<% elseif base_lang = 2 then %>Tajaan<% else %>Sponsorshipsv<% end if %>
<% elseif Request("category_code") = "8" then %>
<%if base_lang = 3 then %>公司代言人<% elseif base_lang = 2 then %>Jurucakap Syarikat<% else %>Company Spokepersons<% end if %>
<% elseif Request("category_code") = "16" then %>
<%if base_lang = 3 then %>科技伙伴<% elseif base_lang = 2 then %>Rakan Kongsi Teknologi<% else %>Technology Partners<% end if %>
<% elseif Request("category_code") = "32" then %>
<%if base_lang = 3 then %>宇宙天然能量石<% elseif base_lang = 2 then %>Loket Kuantum<% else %>Testimonials (QP)<% end if %>
<% elseif Request("category_code") = "64" then %>
<%if base_lang = 3 then %>量子美容肥皂<% elseif base_lang = 2 then %>Bar Kecantikan Kuantum<% else %>Testimonials (QBB)<% end if %>
<% elseif Request("category_code") = "128" then %>
<%if base_lang = 3 then %>宇宙天然能量充电器<% elseif base_lang = 2 then %>Pengecas Kuantum<% else %>Testimonials (QC)<% end if %>
<% elseif Request("category_code") = "256" then %>
<%if base_lang = 3 then %>产品<% elseif base_lang = 2 then %>Produk<% else %>Products<% end if %>
<% else %>
<%if base_lang = 3 then %>新闻与活动<% elseif base_lang = 2 then %>Berita dan Aktiviti<% else %>News &amp; Events<% end if %>
<% end if %>
</title>
<meta name="keywords" content="
<% if Request("category_code") = "2" then %>
<%if base_lang = 3 then %>慈善活动<% elseif base_lang = 2 then %>Acara Amal<% else %>Charities<% end if %>
<% elseif Request("category_code") = "4" then %>
<%if base_lang = 3 then %>赞助<% elseif base_lang = 2 then %>Tajaan<% else %>Sponsorshipsv<% end if %>
<% elseif Request("category_code") = "8" then %>
<%if base_lang = 3 then %>公司代言人<% elseif base_lang = 2 then %>Jurucakap Syarikat<% else %>Company Spokepersons<% end if %>
<% elseif Request("category_code") = "16" then %>
<%if base_lang = 3 then %>科技伙伴<% elseif base_lang = 2 then %>Rakan Kongsi Teknologi<% else %>Technology Partners<% end if %>
<% elseif Request("category_code") = "32" then %>
<%if base_lang = 3 then %>宇宙天然能量石<% elseif base_lang = 2 then %>Loket Kuantum<% else %>Testimonials (QP)<% end if %>
<% elseif Request("category_code") = "64" then %>
<%if base_lang = 3 then %>量子美容肥皂<% elseif base_lang = 2 then %>Bar Kecantikan Kuantum<% else %>Testimonials (QBB)<% end if %>
<% elseif Request("category_code") = "128" then %>
<%if base_lang = 3 then %>宇宙天然能量充电器<% elseif base_lang = 2 then %>Pengecas Kuantum<% else %>Testimonials (QC)<% end if %>
<% elseif Request("category_code") = "256" then %>
<%if base_lang = 3 then %>产品<% elseif base_lang = 2 then %>Produk<% else %>Products<% end if %>
<% else %>
<%if base_lang = 3 then %>新闻与活动<% elseif base_lang = 2 then %>Berita dan Aktiviti<% else %>News &amp; Events<% end if %>
<% end if %>
" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="robots" content="all" /> 
<meta name="distribution" content="global" /> 
<meta name="author" content="FusionExcel International" /> 
<meta name="designer" content="KLHunter.com - Web Design Management" />
<meta name="copyright" content="FusionExcel International � All Rights Reserved" />

<link href="<%= GetFrontendCSSPath() %>fe.css" rel="stylesheet" type="text/css" />
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
        <!--#include file="render_article_list.asp" -->
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
