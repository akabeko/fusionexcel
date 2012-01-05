<%
if maintenance = 1 then
    Response.Redirect("maintenance.asp")
end if
if Session("login") = "" then
    Dim redirect_url
    redirect_url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("URL") & "?" & Request.Querystring
	Response.Redirect("login.asp?redirect_url=" & Server.URLEncode(redirect_url))
end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//ZH" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<title><%= page_title %></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link href="css/style.css?1" rel="stylesheet" type="text/css" />
	<link href="css/dropdownmenu/dropdownmenu.css" rel="stylesheet" type="text/css" />
	<link href="css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="js/jquery-1.6.4.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>
	<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="js/ckfinder/ckfinder.js"></script>
	<script type="text/javascript">
		$(function() {
			$("ul.subnav").parent().append("<span></span>"); //Only shows drop down trigger when js is enabled (Adds empty span tag after ul.subnav*)  
			$("ul.topnav li span").click(function() { //When trigger is clicked...  
				//Following events are applied to the subnav itself (moving subnav up and down)  
				$(this).parent().find("ul.subnav").slideDown('fast').show(); //Drop down the subnav on click  
				$(this).parent().hover(function() {  
				}, function(){  
					$(this).parent().find("ul.subnav").slideUp('slow'); //When the mouse hovers out of the subnav, move it back up  
				});  
				//Following events are applied to the trigger (Hover events for the trigger)  
			}).hover(function() {  
				$(this).addClass("subhover"); //On hover over, add class "subhover"  
			}, function(){  //On Hover Out  
				$(this).removeClass("subhover"); //On hover out, remove class "subhover"  
			});
			
			$("ul.topnav li span").hover(function() { //When trigger is clicked...  
				//Following events are applied to the subnav itself (moving subnav up and down)  
				$(this).parent().find("ul.subnav").slideDown('fast').show(); //Drop down the subnav on click  
				$(this).parent().hover(function() {  
				}, function(){  
					$(this).parent().find("ul.subnav").slideUp('slow'); //When the mouse hovers out of the subnav, move it back up  
				});  
				//Following events are applied to the trigger (Hover events for the trigger)  
			}).hover(function() {  
				$(this).addClass("subhover"); //On hover over, add class "subhover"  
			}, function(){  //On Hover Out  
				$(this).removeClass("subhover"); //On hover out, remove class "subhover"  
			});
		});
	</script>
</head>
<body>
	<div id="wrap">
		<div id="header">
			<div id="navigation_menu">
				<ul class="topnav">
					<li>
						<a href="article.asp">Article</a>
						<ul class="subnav">
							<li><a href="article.asp?category_code=1">News &amp; Events</a></li>
							<li><a href="article.asp?category_code=2">Charities</a></li>
							<li><a href="article.asp?category_code=4">Sponsorship</a></li>
                            <li><a href="article.asp?category_code=8">Company Spokepersons</a></li>
                            <li><a href="article.asp?category_code=16">Technology Partners</a></li>
                            <li><a href="article.asp?category_code=32">Testimonial (Quantum Pendant)</a></li>
                            <li><a href="article.asp?category_code=64">Testimonial (Quantum Beauty Bar)</a></li>
                            <li><a href="article.asp?category_code=128">Testimonial (Quantum Charger)</a></li>
                            <li><a href="article.asp?category_code=256">Products</a></li>
						</ul>
					</li>
					<li>
						<a href="service_centres.asp">Service Center</a>
					</li>
                    <li>
						<a href="links.asp">VIP QP Wearers</a>
					</li>
                    <li>
                        <a href="under-construction.asp">User Admin Account</a>
                    </li>
                    <li>
                        <a href="logout.asp">Logout</a>
                    </li>
				</ul>
			</div>
		</div>
		<div id="main">