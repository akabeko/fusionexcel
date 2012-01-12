<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "[Events] Fusion Excel Content Management System "

Dim RecordSet, sql
%>
<!--#include file="header.asp" -->
<%

if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    if Request("delete") = 1 then
        call SetConnection(GetLinksDbPath())
        call OpenDatabase()
        sql = "DELETE FROM events WHERE event_id IN (" & Request("action_event_id") & ")"
        call ExecuteQuery(sql)
        call ReindexLinks()
        Response.Redirect("events.asp")
    end if
end if
%>
<script type="text/javascript">
	function deleteConfirm() {
		var checkedVal = $("#id_links_list input:checked");
		if(checkedVal.length > 0) {
			if(confirm("Delete " + checkedVal.length + " record(s)?")) {
				$("#id_links_list").submit();
			}
		}
	}
</script>
<div style="float: left; margin-top: 15px;">
	<form method="post" action="events.asp?search=title">
		<label for="id_search_text">Search: </label><input type="text" name="search_query" id="id_search_text" value="" size="50" style="border-radius: 5px; border: 1px solid #CCC;" />
	</form>
</div>
<div id="button_navigator">
	<a href="javascript::void(0)" onclick="deleteConfirm()" class="delete-btn" title="Delete Selected"></a>
	<a href="event-edit.asp?action=add" class="new-btn" title="New Event"></a>
</div>
<br />
<%

sql = "SELECT event_id, event_country, event_city, event_name, event_date, publish, last_modified, last_modified_by FROM events"'
if Request("search") = "title" and Request("search_query") <> "" then
    sql = sql & " WHERE event_name LIKE '%" & Replace(Request("search_query"), " ", "%") & "%' "
end if
sql = sql & " ORDER BY event_date DESC"

call SetConnection(GetEventsDbPath())
call OpenDatabase()
call CreateRecordSet(RecordSet, sql)
%>
<form method="post" id="id_events_list" action="events.asp?delete=1">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="event_list listing">
        <thead>
            <tr>
                <td>&nbsp;</td>
                <td>ID</td>
                <td>Country</td>
                <td>City</td>
                <td>Event Name</td>
                <td>Publish</td>
                <td>Last Modified</td>
                <td>Last Modified By</td>
            </tr>
        </thead>
        <tbody>
        <% Do While not RecordSet.EOF %>
            <tr>
                <td><input type="checkbox" name="action_link_id" value="<%= RecordSet("event_id") %>" /></td>
                <td><%= RecordSet("event_id") %></td>
                <td><%= RecordSet("event_country") %></td>
                <td><%= RecordSet("event_city") %></td>
                <td><a href="event-edit.asp?action=edit&amp;id=<%= RecordSet("event_id") %>"><%= RecordSet("event_name") %></a></td>
                <% if RecordSet("publish") then %>
                    <td style="background: green; color: white;">Yes</td>
                <% else %>
                    <td style="background: red; color: white;">No</td>
                <% end if %>
                <td><%= RecordSet("last_modified") %></td>
                <td><%= RecordSet("last_modified_by") %></td>
            </tr>
            <% RecordSet.MoveNext %>
        <% Loop %>
        </tbody>
    </table>
</form>
<% call CloseRecordSet(RecordSet) %>
<!--#include file="footer.asp" -->