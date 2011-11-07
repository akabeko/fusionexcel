<%
if Session("login") = "" then
	Response.Redirect("login.asp")
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><%= page_title %></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="css/style.css?1" rel="stylesheet" type="text/css" />
	<link href="../css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="../js/jquery-1.6.4.min.js"></script>
	<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom.min.js"></script>
	<script type="text/javascript" src="../js/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="../js/ckfinder/ckfinder.js"></script>
</head>
<body>
	<div id="wrap">
		<div id="header">
			<div id="navigation_menu">
				<ul>
					<li>
						Article
						<ul>
							<li><a href="article.asp?article=news&amp;category_group=1">News &amp; Events</a></li>
							<li><a href="article.asp?article=news&amp;category_group=1&amp;category_code=2">Charities</a></li>
							<li><a href="article.asp?article=news&amp;category_group=1&amp;category_code=4">Sponsorship</a></li>
						</ul>
					</li>
					<li>
						VIP QP Weares
						<ul>
							<li><a href="">VIP QP Wearers</a></li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
		<div id="main">