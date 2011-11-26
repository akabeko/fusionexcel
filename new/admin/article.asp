<!--#include file="../data/dbController.asp" -->
<%
Dim page_title
page_title = "Fusion Excel Content Management System"

Dim category_code

category_code = 1
%>
<!--#include file="header.asp" -->
<% if Request("action") = "" then %>
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
<div style="float: left;">
	<form method="post" action="article.asp?article=news&amp;category_group=<%= Request("category_group") %>&amp;search=title">
		<label for="id_search_text">Search: </label><input type="text" name="search_query" id="id_search_text" value="" size="50" style="border-radius: 5px; border: 1px solid #CCC;" />
	</form>
</div>
<div id="button_navigator">
	<a href="javascript::void(0)" onclick="deleteConfirm()">Delete Selected</a>
	<a href="article.asp?action=add<% if not article = "" then %>&amp;article=<%= article %><% end if %>">New Article</a>
</div>
<br />
<%
	if Request("category_code") <> "" then
		category_code = CInt(Request("category_code"))
	end if
	
	sql = "SELECT id, title, publish, modified, modified_by, order_year, sequence, sequence_indexed FROM article a "
	sql = sql & "WHERE a.category_code > 0"
	sql = sql & "AND (((" & category_code & " \ a.category_code) mod 2) = 1)"
	if Request("search") = "title" then
		if Request("search_query") <> "" then
			sql = sql & " AND title LIKE '%" & Replace(Request("search_query"), " ", "%") & "%'"
		end if
	end if
	sql = sql & "ORDER BY sequence_indexed DESC"
	
	Call SetConnection(GetArticleDbPath())
	Call CreateRecordSet(RecordSet, sql)
%>
<form method="post" id="id_article_list">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="article_list">
		<thead>
			<tr>
				<td>&nbsp;</td>
				<td>ID</td>
				<td>Title</td>
				<td>Published</td>
				<td width="130px">Last Modified</td>
				<td>Last Modified By</td>
				<td>Category</td>
				<td>Sequence</td>
			</tr>
		</thead>
		<tbody>
		<% Do While not RecordSet.EOF %>
			<tr>
				<td><input type="checkbox" name="action_article_id" value="<%= RecordSet("id") %>" /></td>
				<td><%= RecordSet("id") %></td>
				<td><a href='article.asp?action=edit&amp;id=<%= RecordSet("id") %><% if not article = "" then %>&amp;article=<%= article %><% end if %>'><%= RecordSet("title") %></a></td>
				<% if RecordSet("publish") then %>
					<td style="background: green; color: white;">Yes</td>
				<% else %>
					<td style="background: red; color: white;">No</td>
				<% end if %>
				<td><%= RecordSet("modified") %></td>
				<td><%= RecordSet("modified_by") %></td>
				<td><%= RecordSet("category_name") %></td>
				<td><%= RecordSet("order_year") %>-<%= PadDigits(RecordSet("sequence"), 4) %></td>
			</tr>
		<% RecordSet.MoveNext %>
		<% Loop %>
		</tbody>
	</table>
</form>
<!--#include file="footer.asp" -->