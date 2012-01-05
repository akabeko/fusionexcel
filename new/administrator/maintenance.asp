<!--#include file="../libraries.asp" -->
<%
    if maintenance = 0 then
        Response.Redirect("Default.asp")
    end if
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//ZH" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<title>Under Maintenance</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link href="css/style.css?1" rel="stylesheet" type="text/css" />
</head>

<body>
    <div style="width: 300px; margin: auto;">
        <div style="margin-top: 100px;">
            <img src="images/maintenance.jpg" />
            The site is under maintenance, please try again later.
        </div>
    </div>
</body>
</html>