<!--#include file="../libraries.asp" -->
<%
if not Session("login") = "" then
	Response.Redirect("Default.asp")
end if

if Request("submit") = "Login" then
	username = Request("username")
	password = Request("password")
	
	call SetConnection(GetUserDbPath())
	call OpenDatabase()
	sql = "SELECT * FROM tbl_users WHERE username='" & username & "' AND password='" & password & "'"
	
	call CreateRecordSet(RecordSet, sql)
	
	if not RecordSet.EOF then
		Session("login") = username
		Session.Timeout = 360
        if Request("redirect_url") <> "" then
            Response.Redirect(Request("redirect_url"))
        else
            Response.Redirect("Default.asp")
        end if
	else
        Dim query_string
        query_string = "msg=" & Server.URLEncode("Invalid username or password")
        if Request("redirect_url") <> "" then
            query_string = query_string & "&redirect_url=" & Server.URLEncode(Request("redirect_url"))
        End if
		Response.Redirect("login.asp?" & query_string)
	end if
	
	call CloseRecordSet(RecordSet)
	call CloseDatabase()
end if


%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><%= title %></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="css/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div id="wrap">
		<div id="main">
			<div id="login_wrap">
				<div id="login_box">
					<form method="post">
						<table width="100%" cellpadding="0" cellspacing"0" border="0">
							<tr>
								<td colspan="2"><h1>Fusion Excel Content Management</h1></td>
							</tr>
							<tr>
								<td><label>Username: </label></td>
								<td><input type="text" name="username" id="username" maxlength="20" /></td>
							</tr>
							<tr>
								<td><label>Passsword: </label></td>
								<td><input type="password" name="password" id="password" maxlength="20" /></td>
							</tr>
							<tr>
								<td colspan="2" class="error"><%= Request("msg") %></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td><input type="submit" value="Login" name="submit" /></td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>