<%
if not Session("login") = "" then
	Session("login") = ""
	Response.Redirect "login.asp?msg=" & Server.URLEncode("You are logout succesfully")
end if

%>