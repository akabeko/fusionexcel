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
	if not publish_start_date = "" then
		RecordSet.Fields("publish_start_date") = Request.Form("publish_start_date")
	end if
	if not publish_end_date = "" then
		RecordSet.Fields("publish_end_date") = Request.Form("publish_end_date")
	end if
	RecordSet.Fields("meta_description") = Request.Form("meta_description")
	RecordSet.Fields("meta_keywords") = Request.Form("meta_keywords")
	RecordSet.Fields("meta_robots") = Request.Form("meta_robots")
	RecordSet.Fields("meta_author") = Request.Form("meta_author")
	RecordSet.Fields("content") = Request.Form("content")
	
	RecordSet.Fields("title_bm") = Request.Form("title_bm")
	RecordSet.Fields("content_bm") = Request.Form("content_bm")
	RecordSet.Fields("meta_description_bm") = Request.Form("meta_description_bm")
	RecordSet.Fields("meta_keywords_bm") = Request.Form("meta_keywords_bm")
	RecordSet.Fields("meta_robots_bm") = Request.Form("meta_robots_bm")
	RecordSet.Fields("meta_author_bm") = Request.Form("meta_author_bm")
	
	RecordSet.Fields("title_chi") = Request.Form("title_chi")
	RecordSet.Fields("content_chi") = Request.Form("content_chi")
	RecordSet.Fields("meta_description_chi") = Request.Form("meta_description_chi")
	RecordSet.Fields("meta_keywords_chi") = Request.Form("meta_keywords_chi")
	RecordSet.Fields("meta_robots_chi") = Request.Form("meta_robots_chi")
	RecordSet.Fields("meta_author_chi") = Request.Form("meta_author_chi")
	
	RecordSet.Fields("created_by") = Session("login")
	RecordSet.Fields("modified_by") = Session("login")
	
	RecordSet.Update
	article_id = RecordSet("id")
	RecordSet.Close
	
	call CloseRecordSet(RecordSet)
	
	Response.Redirect("article.asp?article=" & Request("article") & "&action=edit&id=" & article_id)
	
elseif Request("submit") = "Update" and CInt(Request("id")) > 0 then
	sql = "SELECT * FROM tbl_article WHERE id = " & Request("id")
	call CreateRecordSet(RecordSet, sql)
	RecordSet.Fields("title") = Request.Form("title")
	RecordSet.Fields("publish") = Request.Form("publish")
	RecordSet.Fields("category") = Request.Form("category")
	if not publish_start_date = "" then
		RecordSet.Fields("publish_start_date") = Request.Form("publish_start_date")
	end if
	if not publish_end_date = "" then
		RecordSet.Fields("publish_end_date") = Request.Form("publish_end_date")
	end if
	RecordSet.Fields("meta_description") = Request.Form("meta_description")
	RecordSet.Fields("meta_keywords") = Request.Form("meta_keywords")
	RecordSet.Fields("meta_robots") = Request.Form("meta_robots")
	RecordSet.Fields("meta_author") = Request.Form("meta_author")
	RecordSet.Fields("content") = Request.Form("content")
	
	RecordSet.Fields("title_bm") = Request.Form("title_bm")
	RecordSet.Fields("content_bm") = Request.Form("content_bm")
	RecordSet.Fields("meta_description_bm") = Request.Form("meta_description_bm")
	RecordSet.Fields("meta_keywords_bm") = Request.Form("meta_keywords_bm")
	RecordSet.Fields("meta_robots_bm") = Request.Form("meta_robots_bm")
	RecordSet.Fields("meta_author_bm") = Request.Form("meta_author_bm")
	
	RecordSet.Fields("title_chi") = Request.Form("title_chi")
	RecordSet.Fields("content_chi") = Request.Form("content_chi")
	RecordSet.Fields("meta_description_chi") = Request.Form("meta_description_chi")
	RecordSet.Fields("meta_keywords_chi") = Request.Form("meta_keywords_chi")
	RecordSet.Fields("meta_robots_chi") = Request.Form("meta_robots_chi")
	RecordSet.Fields("meta_author_chi") = Request.Form("meta_author_chi")
	
	RecordSet.Update
	RecordSet.Close
	call CloseRecordSet(RecordSet)
end if
	
if Request("action") = "edit" and CInt(Request("id")) > 0 then
	sql = "SELECT * FROM tbl_article WHERE id = " & Request("id")
	call CreateRecordSet(RecordSet, sql)
%>
<script type="text/javascript">
	$(function() {
		$('#tabs').tabs();
		$('#id_title, #id_content, #id_meta_description, #id_meta_keywords, #id_meta_robots, #id_meta_author').blur(function() {
			var id_chi = "#" + $(this).attr('id') + "_chi";
			var id_bm = "#" + $(this).attr('id') + "_bm";
			if($(id_chi).val() == "") {
				$(id_chi).val($(this).val());
			}
			if($(id_bm).val() == "") {
				$(id_bm).val($(this).val());
			}
		});
		$('#id_publish_start_date, #id_publish_end_date').datepicker();
	});
</script>
<form enctype="multipart/form-data" method="post" class="input_form">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><label>Published</label>:</td>
			<td><input type="radio" name="publish" value="false" <% if RecordSet("publish") = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if RecordSet("publish") = true then %>checked="checked"<% end if %> /> Yes</td>
			<td><label for="id_category">Category</label>:</td>
			<td>
				<select id="id_category" name="category">
					<option value="news">News &amp; Events</option>
				</select>
			</td>
		</tr>
		<tr>
			<td><label for="id_publish_start_date">Start Publish Date</label>:</td>
			<td><input type="text" id="id_publish_start_date" name="publish_start_date" class="date" value="<%= RecordSet("publish_start_date") %>" /></td>
			<td><label for="id_publish_end_date">End Publish Date</label>:</td>
			<td><input type="text" id="id_publish_end_date" name="publish_end_date" class="date" value="<%= RecordSet("publish_end_date") %>" /></td>
		</tr>
		<tr>
			<td><label for="id_preview_image_url">Image Preview</label>:</td>
			<td colspan="3"><input type="file" name="preview_image_url" id="id_preview_image_url" />
		</tr>
	</table>
	<br />
	<div id="tabs">
		<ul>
			<li><a href="#tab-1">English</a></li>
			<li><a href="#tab-2">BM</a></li>
			<li><a href="#tab-3">Chinese</a></li>
		</ul>
		<div id="tab-1">
			<div style="width: 73%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_title" name="title" value="<%= RecordSet("title") %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor1" name="content" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= RecordSet("content") %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description" name="meta_description" style="width: 150px; height: 80px;"><%= RecordSet("meta_description") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords" name="meta_keywords" style="width: 150px; height: 80px;"><%= RecordSet("meta_keywords") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots" name="meta_robots" value="<%= RecordSet("meta_robots") %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author" name="meta_author" value="<%= RecordSet("meta_author") %>" /></td>
					</tr>
				</table>
			</div>
			<br clear="both" />
		</div>
		<div id="tab-2">
			<div style="width: 73%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_title_bm" name="title_bm" value="<%= RecordSet("title_bm") %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor2" name="content_bm" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= RecordSet("content_bm") %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description_bm" name="meta_description_bm" style="width: 150px; height: 80px;"><%= RecordSet("meta_description_bm") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords_bm" name="meta_keywords_bm" style="width: 150px; height: 80px;"><%= RecordSet("meta_keywords_bm") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots_bm" name="meta_robots_bm" value="<%= RecordSet("meta_robots_bm") %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author_bm" name="meta_author_bm" value="<%= RecordSet("meta_author_bm") %>" /></td>
					</tr>
				</table>
			</div>
			<br clear="both" />
		</div>
		<div id="tab-3">
			<div style="width: 73%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_title_chi" name="title_chi" value="<%= RecordSet("title_chi") %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor3" name="content_chi" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= RecordSet("content_chi") %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description_chi" name="meta_description_chi" style="width: 150px; height: 80px;"><%= RecordSet("meta_description_chi") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords_chi" name="meta_keywords_chi" style="width: 150px; height: 80px;"><%= RecordSet("meta_keywords_chi") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots_chi" name="meta_robots_chi" value="<%= RecordSet("meta_robots_chi") %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author_chi" name="meta_author_chi" value="<%= RecordSet("meta_author_chi") %>" /></td>
					</tr>
				</table>
			</div>
			<br clear="both" />
		</div>
	</div>

	<br clear="both" />
	<div>
		<input type="submit" name="submit" value="Update" />
	</div>

	<script type="text/javascript">
		CKEDITOR.replace('editor1', {
			filebrowserBrowseUrl: '/js/ckfinder/ckfinder.html',
			filebrowserImageBrowseUrl: '/js/ckfinder/ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '/js/ckfinder/ckfinder.html?type=Flash',
			filebrowserUploadUrl: '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
		CKEDITOR.replace('editor2', {
			filebrowserBrowseUrl: '/js/ckfinder/ckfinder.html',
			filebrowserImageBrowseUrl: '/js/ckfinder/ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '/js/ckfinder/ckfinder.html?type=Flash',
			filebrowserUploadUrl: '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
		CKEDITOR.replace('editor3', {
			filebrowserBrowseUrl: '/js/ckfinder/ckfinder.html',
			filebrowserImageBrowseUrl: '/js/ckfinder/ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '/js/ckfinder/ckfinder.html?type=Flash',
			filebrowserUploadUrl: '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
	</script>
</form>
<% elseif (Request("action") = "edit" and Request("id") = "") or Request("action") = "add" then %>
<script type="text/javascript">
	$(function() {
		$('#tabs').tabs();
		$('#id_title, #id_content, #id_meta_description, #id_meta_keywords, #id_meta_robots, #id_meta_author').blur(function() {
			var id_chi = "#" + $(this).attr('id') + "_chi";
			var id_bm = "#" + $(this).attr('id') + "_bm";
			if($(id_chi).val() == "") {
				$(id_chi).val($(this).val());
			}
			if($(id_bm).val() == "") {
				$(id_bm).val($(this).val());
			}
		});
		$('#id_publish_start_date, #id_publish_end_date').datepicker();
	});
</script>
<form method="post" class="input_form">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><label>Published</label>:</td>
			<td><input type="radio" name="publish" value="false" <% if Request("publish") = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if Request("publish") = true then %>checked="checked"<% end if %> /> Yes</td>
			<td><label for="id_category">Category</label>:</td>
			<td>
				<select id="id_category" name="category">
					<option value="news">News &amp; Events</option>
				</select>
			</td>
		</tr>
		<tr>
			<td><label for="id_publish_start_date">Start Publish Date</label>:</td>
			<td><input type="text" id="id_publish_start_date" name="publish_start_date" class="date" value="<%= Request("publish_start_date") %>" /></td>
			<td><label for="id_publish_end_date">End Publish Date</label>:</td>
			<td><input type="text" id="id_publish_end_date" name="publish_end_date" class="date" value="<%= Request("publish_end_date") %>" /></td>
		</tr>
	</table>
	<br />
	<div id="tabs">
		<ul>
			<li><a href="#tab-1">English</a></li>
			<li><a href="#tab-2">BM</a></li>
			<li><a href="#tab-3">Chinese</a></li>
		</ul>
		<div id="tab-1">
			<div style="width: 73%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_title" name="title" value="<%= Request("title") %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor1" name="content" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= Request("content") %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description" name="meta_description" style="width: 150px; height: 80px;"><%= Request("meta_description") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords" name="meta_keywords" style="width: 150px; height: 80px;"><%= Request("meta_keywords") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots" name="meta_robots" value="<%= Request("meta_robots") %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author" name="meta_author" value="<%= Request("meta_author") %>" /></td>
					</tr>
				</table>
			</div>
			<br clear="both" />
		</div>
		<div id="tab-2">
			<div style="width: 73%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_title_bm" name="title_bm" value="<%= Request("title_bm") %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor2" name="content_bm" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= Request("content_bm") %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description_bm" name="meta_description_bm" style="width: 150px; height: 80px;"><%= Request("meta_description_bm") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords_bm" name="meta_keywords_bm" style="width: 150px; height: 80px;"><%= Request("meta_keywords_bm") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots_bm" name="meta_robots_bm" value="<%= Request("meta_robots_bm") %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author_bm" name="meta_author_bm" value="<%= Request("meta_author_bm") %>" /></td>
					</tr>
				</table>
			</div>
			<br clear="both" />
		</div>
		<div id="tab-3">
			<div style="width: 73%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_title_chi" name="title_chi" value="<%= Request("title_chi") %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor3" name="content_chi" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= Request("content_chi") %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description_chi" name="meta_description_chi" style="width: 150px; height: 80px;"><%= Request("meta_description_chi") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords_chi" name="meta_keywords_chi" style="width: 150px; height: 80px;"><%= Request("meta_keywords_chi") %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots_chi" name="meta_robots_chi" value="<%= Request("meta_robots_chi") %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author_chi" name="meta_author_chi" value="<%= Request("meta_author_chi") %>" /></td>
					</tr>
				</table>
			</div>
			<br clear="both" />
		</div>
	</div>

	<br clear="both" />
	<div>
		<input type="submit" name="submit" value="Add" />
	</div>

	<script type="text/javascript">
		CKEDITOR.replace('editor1', {
			filebrowserBrowseUrl: '/js/ckfinder/ckfinder.html',
			filebrowserImageBrowseUrl: '/js/ckfinder/ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '/js/ckfinder/ckfinder.html?type=Flash',
			filebrowserUploadUrl: '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
		CKEDITOR.replace('editor2', {
			filebrowserBrowseUrl: '/js/ckfinder/ckfinder.html',
			filebrowserImageBrowseUrl: '/js/ckfinder/ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '/js/ckfinder/ckfinder.html?type=Flash',
			filebrowserUploadUrl: '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '/js/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
		CKEDITOR.replace('editor3', {
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
<div id="button_navigator">
	<a href="/admin/article.asp?action=add<% if not article = "" then %>&amp;article=<%= article %><% end if %>">New Article</a>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="article_list">
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
	
	sql = sql & " ORDER BY created DESC"
	
	call CreateRecordSet(RecordSet, sql)
	
	Do While not RecordSet.EOF
%>
		<tr>
			<td><%= RecordSet("id") %></td>
			<td><a href='/admin/article.asp?action=edit&amp;id=<%= RecordSet("id") %><% if not article = "" then %>&amp;article=<%= article %><% end if %>'><%= RecordSet("title") %></a></td>
			<td><% if RecordSet("publish") then %>Yes<% else %>No<% end if %></td>
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