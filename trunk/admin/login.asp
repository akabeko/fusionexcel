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
	<div>
		<form method="post">
			<p><label>Username: </label><input type="text" name="username" id="username" maxlength="20" /></p>
			<p><label>Passsword: </label><input type="password" name="password" id="password" maxlength="20" /></p>
			<p style="color: red;"><%= Request("msg") %></p>
			<input type="submit" value="Login" name="submit" />
		</form>
	</div>
<!--#include file="footer.asp" -->