<%
	if Session("login") = "" then
		Response.Redirect("login.asp")
	end if
	page_title = "Fusion Excel Content Management System"
%>
<!--#include file="header.asp" -->
<!--#include file="footer.asp" -->