<!--#include virtual="/data/dbCon.asp" -->
<%
if not Session("login") = "" then
	Response.Redirect("index.asp")
end if

if Request("submit") = "Login" then
	username = Request("username")
	password = Request("password")
	
	call OpenDatabase()
	sql = "SELECT * FROM tbl_users WHERE username='" & username & "' AND password='" & password & "'"
	
	call CreateRecordSet(RecordSet, sql)
	
	if not RecordSet.EOF then
		Session("login") = username
		Response.Redirect("index.asp")
	else
		Response.Redirect("login.asp?msg=") & Server.URLEncode("Invalid username or password")
	end if
	
	call CloseRecordSet(RecordSet)
	call CloseDatabase()
end if


%>
<!--#include file="header.asp" -->
	<div id="login_wrap">
		<div id="login_box">
			<form method="post">
				<table width="100%" cellpadding="0" cellspacing"0" border="0">
					<tr>
						<td><label>Username: </label></td>
						<td><input type="text" name="username" id="username" maxlength="20" /></td>
					</tr>
					<tr>
						<td><label>Passsword: </label></td>
						<td><input type="password" name="password" id="password" maxlength="20" /></td>
					</tr>
					<tr>
						<td colspan="2"><p style="color: red;"><%= Request("msg") %></p></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><input type="submit" value="Login" name="submit" /></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
<!--#include file="footer.asp" -->