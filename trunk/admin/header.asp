<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><%= title %></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="css/style.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="http://www.google.com/jsapi"></script>
	<script type="text/javascript">
		google.load("jquery", "1");
	</script>
	<script type="text/javascript" src="../js/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="../js/ckfinder/ckfinder.js"></script>
</head>
<body>
	<div id="wrap">
		<div id="header">
			<% if not Session("login") = "" then %>
			<div id="navigation_menu">
				<ul>
					<li>
						Article
						<ul>
							<li><a href="article.asp?article=news">News &amp; Events</a></li>
						</ul>
					</li>
				</ul>
			</div>
			<% end if %>
		</div>