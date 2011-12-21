<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "[Service Centres] Fusion Excel Content Management System"

Dim RecordSet, sql
%>
<!--#include file="header.asp" -->
<%

if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    if Request("delete") = 1 then
        call SetConnection(GetSCDbPath())
        call OpenDatabase()
        sql = "DELETE FROM service_centres WHERE service_centre_id IN (" & Request("action_service_centre_id") & ")"
        call ExecuteQuery(sql)
        call RedindexServiceCentres()
        Response.Redirect("services_centres.asp")
    end if
end if
%>
<script type="text/javascript">
	function deleteConfirm() {
		var checkedVal = $("#id_service_centres_list input:checked");
		if(checkedVal.length > 0) {
			if(confirm("Delete " + checkedVal.length + " record(s)?")) {
				$("#id_service_centres_list").submit();
			}
		}
	}
</script>
<div style="float: left; margin-top: 15px;">
	<form method="post" action="service_centres.asp?search=title">
		<label for="id_search_text">Search: </label><input type="text" name="search_query" id="id_search_text" value="" size="50" style="border-radius: 5px; border: 1px solid #CCC;" />
	</form>
</div>
<div id="button_navigator">
	<a href="javascript::void(0)" onclick="deleteConfirm()" class="delete-btn" title="Delete Selected"></a>
	<a href="service_centre-edit.asp?action=add" class="new-btn" title="New Service Centre"></a>
</div>
<br />
<%

sql = "SELECT service_centre_id, country_name, publish, modified, modified_by FROM service_centres"
if Request("search") = "title" and Request("search_query") <> "" then
    sql = sql & " WHERE country_name LIKE '%" & Replace(Request("search_query"), " ", "%") & "%'"
end if
sql = sql & " ORDER BY order_index"

call SetConnection(GetSCDbPath())
call OpenDatabase()
call CreateRecordSet(RecordSet, sql)
%>
<form method="post" id="id_service_centres_list" action="service_centres.asp?delete=1">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="service_centres_list listing">
        <thead>
            <tr>
                <td>&nbsp;</td>
                <td>ID</td>
                <td>Services Centres Title</td>
                <td>Publish</td>
                <td>Last Modified</td>
                <td>Last Modified By</td>
            </tr>
        </thead>
        <tbody>
        <% Do While not RecordSet.EOF %>
            <tr>
                <td><input type="checkbox" name="action_service_centre_id" value="<%= RecordSet("service_centre_id") %>" /></td>
                <td><%= RecordSet("service_centre_id") %></td>
                <td><a href="service_centre-edit.asp?action=edit&amp;id=<%= RecordSet("service_centre_id") %>"><%= RecordSet("country_name") %></a></td>
                <% if RecordSet("publish") then %>
                    <td style="background: green; color: white;">Yes</td>
                <% else %>
                    <td style="background: red; color: white;">No</td>
                <% end if %>
                <td><%= RecordSet("modified") %></td>
                <td><%= RecordSet("modified_by") %></td>
            </tr>
            <% RecordSet.MoveNext %>
        <% Loop %>
        </tbody>
    </table>
</form>
<% call CloseRecordSet(RecordSet) %>
<!--#include file="footer.asp" -->