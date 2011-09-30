<!--#include virtual="/data/dbCon.asp" -->
<%
	title = "Fusion Excel Content Management System"
	call OpenDatabase()
%>
<!--#include file="header.asp" -->

<%
Dim article
if Request("article") = "news" then
	article = "news"
end if

if Request("submit") = "Add" then
	sql = "SELECT * FROM tbl_article"
	call CreateRecordSet(RecordSet, sql)
	RecordSet.AddNew
	RecordSet.Fields("title") = Request.Form("title")
	RecordSet.Fields("publish") = Request.Form("publish")
	RecordSet.Fields("category") = Request.Form("category")
	RecordSet.Fields("publish_start_date") = Request.Form("publish_start_date")
	RecordSet.Fields("publish_end_date") = Request.Form("publish_end_date")
	RecordSet.Fields("meta_description") = Request.Form("meta_description")
	RecordSet.Fields("meta_keywords") = Request.Form("meta_keywords")
	RecordSet.Fields("meta_robots") = Request.Form("meta_robots")
	RecordSet.Fields("meta_author") = Request.Form("meta_author")
	RecordSet.Fields("content") = Request.Form("meta_content")
	RecordSet.Update
	RecordSet.Close
	call CloseRecordSet(RecordSet)
	
elseif Request("submit") = "Update" and CInt(Request("id")) > 0 then
	sql = "SELECT * FROM tbl_article WHERE id = " & Request("id")
	call CreateRecordSet(RecordSet, sql)
	RecordSet.Fields("title") = Request.Form("title")
	RecordSet.Fields("publish") = Request.Form("publish")
	RecordSet.Fields("category") = Request.Form("category")
	RecordSet.Fields("publish_start_date") = Request.Form("publish_start_date")
	RecordSet.Fields("publish_end_date") = Request.Form("publish_end_date")
	RecordSet.Fields("meta_description") = Request.Form("meta_description")
	RecordSet.Fields("meta_keywords") = Request.Form("meta_keywords")
	RecordSet.Fields("meta_robots") = Request.Form("meta_robots")
	RecordSet.Fields("meta_author") = Request.Form("meta_author")
	RecordSet.Fields("content") = Request.Form("meta_content")
	RecordSet.Update
	RecordSet.Close
	call CloseRecordSet(RecordSet)
end if
	
if Request("action") = "edit" and CInt(Request("id")) > 0 then
	sql = "SELECT * FROM tbl_article WHERE id = " & Request("id")
	call CreateRecordSet(RecordSet, sql)
%>
<form method="post">
	<div>
		<input type="text" name="title" value="<%= RecordSet("title") %>" maxlength="255" size="80" />
		<input type="radio" name="publish" value="false" <% if RecordSet("publish") = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if RecordSet("publish") = true then %>checked="checked"<% end if %> /> Yes
		<select name="category">
			<option value="news">News &amp; Events</option>
		</select>
		<input type="text" name="publish_start_date" class="date" value="<%= RecordSet("publish_start_date") %>" />
		<input type="text" name="publish_end_date" class="date" value="<%= RecordSet("publish_end_date") %>" />
		<textarea name="meta_description"><%= RecordSet("meta_description") %></textarea>
		<textarea name="meta_keywords"><%= RecordSet("meta_keywords") %></textarea>
		<input type="text" name="meta_robots" value="<%= RecordSet("meta_robots") %>" />
		<input type="text" name="meta_author" value="<%= RecordSet("meta_author") %>" />
		<textarea id="editor1" name="content" rows="15" cols="80" style="width: 80%"><%= RecordSet("content") %></textarea>
	</div>

	<input type="submit" name="submit" value="Update" />
	<script type="text/javascript">
		CKEDITOR.replace('editor1', {
			filebrowserBrowseUrl: '/js/ckfinder/ckfinder.html',
			filebrowserImageBrowseUrl: '/js/ckfinder/ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '/js/ckfinder/ckfinder.html?type=Flash',
			filebrowserUploadUrl: '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
	</script>
</form>
<% elseif Request("action") = "edit" and Request("id") = "" then %>
<form method="post">
	<div>
		<input type="text" name="title" value="<%= Request("title") %>" maxlength="255" size="80" />
		<input type="radio" name="publish" value="false" <% if Request("publish") = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if Request("publish") = true then %>checked="checked"<% end if %> /> Yes
		<select name="category">
			<option value="news">News &amp; Events</option>
		</select>
		<input type="text" name="publish_start_date" class="date" value="<%= Request("publish_start_date") %>" />
		<input type="text" name="publish_end_date" class="date" value="<%= Request("publish_end_date") %>" />
		<textarea name="meta_description"><%= Request("meta_description") %></textarea>
		<textarea name="meta_keywords"><%= Request("meta_keywords") %></textarea>
		<input type="text" name="meta_robots" value="<%= Request("meta_robots") %>" />
		<input type="text" name="meta_author" value="<%= Request("meta_author") %>" />
		<textarea id="editor1" name="content" rows="15" cols="80" style="width: 80%"><%= Request("content") %></textarea>
	</div>

	<input type="submit" name="save" value="Add" />
	<script type="text/javascript">
		CKEDITOR.replace('editor1', {
			filebrowserBrowseUrl: '/js/ckfinder/ckfinder.html',
			filebrowserImageBrowseUrl: '/js/ckfinder/ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '/js/ckfinder/ckfinder.html?type=Flash',
			filebrowserUploadUrl: '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
	</script>
</form>
<% elseif Request("action") = "" then %>
<table width="100%">
	<thead>
		<tr>
			<td>ID</td>
			<td>Title</td>
			<td>Published</td>
			<td>Last Modified</td>
			<td>Last Modified By</td>
			<td>Category</td>
		</tr>
	</thead>
	<tbody>
<%
	sql = "SELECT * FROM tbl_article"
	
	if not article = "" then
		sql = sql & " WHERE category = '" & article & "'"
	end if
	
	sql = sql & " ORDER BY created"
	
	call CreateRecordSet(RecordSet, sql)
	
	Do While not RecordSet.EOF
%>
		<tr>
			<td><%= RecordSet("id") %></td>
			<td><a href='/admin/article.asp?action=edit&amp;id=<%= RecordSet("id") %><% if not article = "" then %>&amp;article=<%= article %><% end if %>'><%= RecordSet("title") %></a></td>
			<td><%= RecordSet("publish") %></td>
			<td><%= RecordSet("modified") %></td>
			<td><%= RecordSet("modified_by") %></td>
			<td><%= RecordSet("category") %></td>
		</tr>
<%
		RecordSet.MoveNext
	Loop
%>
	</tbody>
</table>
<%
end if

call CloseRecordSet(RecordSet)
call CloseDatabase()

%>
<!--#include file="footer.asp" -->