<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "Fusion Excel Content Management System "

Dim RecordSet, sql, link_type

link_type = 1

if Request("link_type") <> "" then
    if IsNumeric(Request("link_type")) then
        link_type = CInt(Request("link_type"))
    End if
End if

if link_type = 1 then
    page_title = "[VIP QP Wearers] " & page_title
elseif link_type = 2 then
    page_title = "[Videos] " & page_title
end if
%>
<!--#include file="header.asp" -->
<%

if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    if Request("delete") = 1 then
        call SetConnection(GetLinksDbPath())
        call OpenDatabase()
        sql = "DELETE FROM links WHERE link_id IN (" & Request("action_link_id") & ")"
        call ExecuteQuery(sql)
        call ReindexLinks()
        Response.Redirect("links.asp")
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
	<form method="post" action="links.asp?search=title">
		<label for="id_search_text">Search: </label><input type="text" name="search_query" id="id_search_text" value="" size="50" style="border-radius: 5px; border: 1px solid #CCC;" />
	</form>
</div>
<div id="button_navigator">
	<a href="javascript::void(0)" onclick="deleteConfirm()" class="delete-btn" title="Delete Selected"></a>
	<a href="link-edit.asp?action=add" class="new-btn" title="New VIP QP Wearers"></a>
</div>
<br />
<%

sql = "SELECT link_id, article_id, article_name, link_title, publish, modified, modified_by, link_type, external_url, order_index FROM links"'
if Request("search") = "title" and Request("search_query") <> "" then
    sql = sql & " WHERE link_title LIKE '%" & Replace(Request("search_query"), " ", "%") & "%' "
    sql = sql & " OR article_name LIKE '%"  & Replace(Request("search_query"), " ", "%") & "%' "
    sql = sql & " AND link_type = " & link_type
end if
sql = sql & " ORDER BY order_index DESC"

call SetConnection(GetLinksDbPath())
call OpenDatabase()
call CreateRecordSet(RecordSet, sql)
%>
<form method="post" id="id_links_list" action="links.asp?delete=1">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="link_list listing">
        <thead>
            <tr>
                <td>&nbsp;</td>
                <td>ID</td>
                <td>Article Title/ External URL</td>
                <td>Link Title</td>
                <td>Publish</td>
                <td>Last Modified</td>
                <td>Last Modified By</td>
                <td>Order</td>
            </tr>
        </thead>
        <tbody>
        <% Do While not RecordSet.EOF %>
            <tr>
                <td><input type="checkbox" name="action_link_id" value="<%= RecordSet("link_id") %>" /></td>
                <td><%= RecordSet("link_id") %></td>
                <td>
                    <% if RecordSet("link_type") = 1 then %>
                        <a href="article-edit.asp?action=edit&amp;id=<%= RecordSet("article_id") %>" target="_blank"><%= RecordSet("article_name") %></a>
                    <% elseif RecordSet("link_type") = 2 then %>
                        <a href="<%= RecordSet("external_url") %>" target="_blank"><%= RecordSet("external_url") %></a>
                    <% end if %>
                </td>
                <td><a href="link-edit.asp?action=edit&amp;id=<%= RecordSet("link_id") %>"><%= RecordSet("link_title") %></a></td>
                <% if RecordSet("publish") then %>
                    <td style="background: green; color: white;">Yes</td>
                <% else %>
                    <td style="background: red; color: white;">No</td>
                <% end if %>
                <td><%= RecordSet("modified") %></td>
                <td><%= RecordSet("modified_by") %></td>
                <td><%= RecordSet("order_index") %></td>
            </tr>
            <% RecordSet.MoveNext %>
        <% Loop %>
        </tbody>
    </table>
</form>
<% call CloseRecordSet(RecordSet) %>
<!--#include file="footer.asp" -->