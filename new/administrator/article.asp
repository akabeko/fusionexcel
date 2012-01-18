<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "[Article] Fusion Excel Content Management System"

Dim category_code
Dim RecordSet, sql, XMLObj

category_code = 1
%>
<!--#include file="header.asp" -->
<%

if Request.ServerVariables("REQUEST_METHOD") = "POST" then
    if Request("delete") = 1 then
        Call SetConnection(GetArticleDbPath())
        Call OpenDatabase()
        sql = "DELETE FROM article WHERE article_id IN (" & Request("action_article_id") & ")"
        call ExecuteQuery(sql)
        call DeleteArticleFiles(Request("action_article_id"))
        call ReindexData(category_code)
        Response.Redirect("article.asp")
    end if
end if
%>
<script type="text/javascript">
	function deleteConfirm() {
		var checkedVal = $("#id_article_list input:checked");
		if(checkedVal.length > 0) {
			if(confirm("Delete " + checkedVal.length + " record(s)?")) {
				$("#id_article_list").submit();
			}
		}
	}
</script>
<div style="float: left; margin-top: 15px;">
	<form method="post" action="article.asp?search=title">
		<label for="id_search_text">Search: </label><input type="text" name="search_query" id="id_search_text" value="" size="50" style="border-radius: 5px; border: 1px solid #CCC;" />
	</form>
</div>
<div id="button_navigator">
	<a href="javascript::void(0)" onclick="deleteConfirm()" class="delete-btn" title="Delete Selected"></a>
	<a href="article-edit.asp?action=add" class="new-btn" title="New Article"></a>
</div>
<br />
<%
	if Request("category_code") <> "" then
		category_code = CInt(Request("category_code"))
	end if
	
	sql = "SELECT article_id, title, publish, category_code, modified, modified_by, order_year, sequence, sequence_indexed FROM article a"
	sql = sql & " WHERE a.category_code > 0"
	sql = sql & " AND (((category_code \ " & category_code & ") mod 2) = 1)"
	if Request("search") = "title" then
		if Request("search_query") <> "" then
			sql = sql & " AND title LIKE '%" & Replace(Request("search_query"), " ", "%") & "%'"
		end if
	end if
	sql = sql & " ORDER BY sequence_indexed DESC"

	Call SetConnection(GetArticleDbPath())
	Call OpenDatabase()
	Call CreateRecordSet(RecordSet, sql)
%>
<form method="post" id="id_article_list" action="article.asp?delete=1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="article_list listing">
		<thead>
			<tr>
				<td>&nbsp;</td>
				<td>ID</td>
				<td>Title</td>
				<td>Published</td>
				<td width="130px">Last Modified</td>
				<td>Last Modified By</td>
				<td width="100px">Category</td>
				<td>Sequence</td>
			</tr>
		</thead>
		<tbody>
		<% Do While not RecordSet.EOF %>
			<tr>
				<td><input type="checkbox" name="action_article_id" value="<%= RecordSet("article_id") %>" <% if RecordSet("article_id") >= 1 and RecordSet("article_id") <= 10 then %> disabled="disabled="<% end if %> /></td>
				<td><%= RecordSet("article_id") %></td>
				<td><a href='article-edit.asp?action=edit&amp;id=<%= RecordSet("article_id") %>'><%= RecordSet("title") %></a></td>
				<% if RecordSet("publish") then %>
					<td style="background: green; color: white;">Yes</td>
				<% else %>
					<td style="background: red; color: white;">No</td>
				<% end if %>
				<td><%= RecordSet("modified") %></td>
				<td><%= RecordSet("modified_by") %></td>
				<td><%= getCategoriesNameById(RecordSet("category_code")) %></td>
				<td><%= RecordSet("order_year") %>-<%= PadDigits(RecordSet("sequence"), 4) %></td>
			</tr>
		<% RecordSet.MoveNext %>
		<% Loop %>
		</tbody>
	</table>
</form>
<%
call CloseRecordSet(RecordSet)
%>
<!--#include file="footer.asp" -->