<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "Fusion Excel Content Management System"
Dim old_password, new_password, retype_password, error_msg

if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    old_password = Request("old_password")
    new_password = Request("new_password")
    retype_password = Request("retype_password")
    if new_password = "" then
        error_msg = "Please select your new password"
    elseif Len(new_password) < 6 then
        error_msg = "Please choose your password with more than 6 character"
    elseif new_password <> retype_password then
        error_msg = "The retype password doesn't same with the new password"
    else
        Dim RecordSet, sql
        sql = "SELECT password FROM tbl_users WHERE username = '" & Session("login") & "'"
        
        call SetConnection(GetUserDbPath())
        call OpenDatabase()
        call CreateRecordSet(RecordSet, sql)
        
        if not RecordSet.EOF then
            if old_password <> RecordSet("password") then
                error_msg = "The password you entered doesn't seem is same with the previous password"
            else
                RecordSet("password") = new_password
                RecordSet.Update
                Response.Redirect("reset-password.asp?success=1")
            end if
        End if
    end if
end if
%>
<!--#include file="header.asp" -->
<h1>Change Password</h1>
<form method="post" class="input_form">
<table border="0" cellspacing="0" cellpadding="0" width="100%">
    <tr>
        <td width="150px"><label for="id_old_password">Old Password: </label></td>
        <td><input type="password" name="old_password" id="id_old_password" value="<%= old_password %>" />
    </tr>
    <tr>
        <td><label for="id_new_password">New Password: </label></td>
        <td><input type="password" name="new_password" id="id_new_password" value="<%= new_password %>" />
    </tr>
    <tr>
        <td><label for="id_retype_password">Retype Password: </label></td>
        <td><input type="password" name="retype_password" id="id_retype_password" value="<%= retype_password %>" />
    </tr>
    <% if error_msg <> "" then %>
    <tr>
        <td></td>
        <td><p style="color: red">Error: <%= error_msg %></p></td>
    </tr>
    <% elseif Request("success") = 1 then %>
    <tr>
        <td></td>
        <td><p style="color: green">Password updated successfully</p></td>
    </tr>
    <% end if %>
    <tr>
        <td></td>
        <td><input type="submit" name="submit" value="Update Password" /></td>
    </tr>
</table>
</form>
<!--#include file="footer.asp" -->