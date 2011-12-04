<%@ Language=VBScript %>
<%
option explicit
Response.Expires = -1
Server.ScriptTimeout = 600
Session.CodePage = 65001
Dim page_title, article, article_id, RecordSet, sql, uploadsDirVar
Dim category_group, category_code

category_group = 1
category_code = 0
page_title = "Fusion Excel Content Management System"
uploadsDirVar = "C:\inetpub\scripts\fusionexcel\fusionexcel\trunk\images\" 

%>
<!--#include file="../data/dbCon.asp" -->
<!--#include file="freeaspupload.asp" -->
<!--#include file="header.asp" -->
<%
call OpenDatabase()

if Request("category_group") <> "" then
	category_group = CInt(Request("category_group"))
end if

if Request("id") <> "" then
	article_id = Request("id")
end if

if Request.ServerVariables("REQUEST_METHOD") = "POST" and Request("action") <> "" then
	SaveFiles()
	Response.Redirect("article.asp?article=" & article & "&action=edit&id=" & article_id & "&and=" & category_code )
elseif Request.ServerVariables("REQUEST_METHOD") = "POST" and Request("action") = "" and Request("search") = "" then
	sql = "DELETE FROM tbl_article WHERE id IN (" & Request("action_article_id") & ")"
	call ExecuteQuery(sql)
	Response.Redirect("article.asp?article=" & article & "&and=" & category_code )
end if

if Request("action") <> "" then
	Dim publish, publish_start_date, preview_image_url
	Dim title, content, meta_description, meta_keywords, meta_robots, meta_author
	Dim title_bm, content_bm, meta_description_bm, meta_keywords_bm, meta_robots_bm, meta_author_bm
	Dim title_chi, content_chi, meta_description_chi, meta_keywords_chi, meta_robots_chi, meta_author_chi
	Dim sequence, order_year
	if Request("action") = "edit" and CInt(Request("id")) > 0 then
		sql = "SELECT * FROM tbl_article WHERE id= " & Request("id")
		call CreateRecordSet(RecordSet, sql)
		publish = RecordSet("publish")
		publish_start_date = RecordSet("publish_start_date")
		
		title = RecordSet("title")
		content = RecordSet("content")
		meta_description = RecordSet("meta_description")
		meta_keywords = RecordSet("meta_keywords")
		meta_robots = RecordSet("meta_robots")
		meta_author = RecordSet("meta_author")
		
		title_bm = RecordSet("title_bm")
		content_bm = RecordSet("content_bm")
		meta_description_bm = RecordSet("meta_description_bm")
		meta_keywords_bm = RecordSet("meta_keywords_bm")
		meta_robots_bm = RecordSet("meta_robots_bm")
		meta_author_bm = RecordSet("meta_author_bm")
		
		title_chi = RecordSet("title_chi")
		content_chi = RecordSet("content_chi")
		meta_description_chi = RecordSet("meta_description_chi")
		meta_keywords_chi = RecordSet("meta_keywords_chi")
		meta_robots_chi = RecordSet("meta_robots_chi")
		meta_author_chi = RecordSet("meta_author_chi")
		
		preview_image_url = RecordSet("preview_image_url")
		
		sequence = RecordSet("sequence")
		order_year = RecordSet("order_year")
		
		category_code = RecordSet("category_code")
	else
		publish = Request("publish")
		publish_start_date = Request("publish_start_date")
		
		title = Request("title")
		content = Request("content")
		meta_description = Request("meta_description")
		meta_keywords = Request("meta_keywords")
		meta_robots = Request("meta_robots")
		meta_author = Request("meta_author")
		
		title_bm = Request("title_bm")
		content_bm = Request("content_bm")
		meta_description_bm = Request("meta_description_bm")
		meta_keywords_bm = Request("meta_keywords_bm")
		meta_robots_bm = Request("meta_robots_bm")
		meta_author_bm = Request("meta_author_bm")
		
		title_chi = Request("title_chi")
		content_chi = Request("content_chi")
		meta_description_chi = Request("meta_description_chi")
		meta_keywords_chi = Request("meta_keywords_chi")
		meta_robots_chi = Request("meta_robots_chi")
		meta_author_chi = Request("meta_author_chi")
		
		preview_image_url = ""
		
		if Request("order_year") <> "" then
			order_year = Request("order_year")
		else
			order_year = Year(Now())
		end if
		
		if Request("sequence") <> "" then
			sequence = Request("sequence")
		else
			Dim sequenceRecordSet
			sql = "SELECT MAX(sequence) + 1 as new_sequence FROM tbl_article WHERE order_year = " & order_year
			Call CreateRecordSet(sequenceRecordSet, sql)
			sequence = sequenceRecordSet("new_sequence")
		end if
	end if
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
		$('#id_publish_start_date').datepicker();
		$('.input_form').submit(function() {
			var year = $('#id_order_year').val();
			var sequence = trimNumber($('#id_sequence').val());
			var categoryCodeLength = $('input[name="category_code"]:checked').length;
			if(!((parseFloat(sequence) == parseInt(sequence)) && !isNaN(sequence))) {
				alert("Please enter integer value for Sequence Number");
				return false;
			}
			else if(!((parseFloat(year) == parseInt(year)) && !isNaN(year))) {
				alert("Please enter integer value for Sequence Year");
				return false;
			}
			else if(year < 1950) {
				alert("Sequence Year must more than 1950");
				return false;
			}
			else if(categoryCodeLength == 0) {
				alert("Please select the Category");
				return false;
			}
		});
	});
	function trimNumber(s) {
		while (s.substr(0,1) == '0' && s.length > 1) { s = s.substr(1, 9999); }
		return s;
	}
</script>
<form runat="server" method="POST" enctype="multipart/form-data" accept-charset="utf-8" class="input_form">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><label>Published</label>:</td>
			<td><input type="radio" name="publish" value="false" <% if publish = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if publish = true then %>checked="checked"<% end if %> /> Yes</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td><label for="id_publish_start_date">Start Publish Date</label>:</td>
			<td><input type="text" id="id_publish_start_date" name="publish_start_date" class="date" value="<%= publish_start_date %>" /></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td><label for="id_order">Sequence Number</label>:</td>
			<td><input type="text" id="id_sequence" name="sequence" value="<% if sequence = "" then %>0001<% else %><%= PadDigits(sequence, 4) %><% end if %>" maxlength="4" /></td>
			<td><label for="id_order_year">Sequence Year</label>:</td>
			<td><input type="text" id="id_order_year" name="order_year" class="date_year" value="<% if order_year = "" then %><%= Year(Now()) %><% else %><%= order_year %><% end if %>" maxlength="4" /></td>
		</tr>
		<tr>
			<td><label for="id_category">Category</label>:</td>
			<td colspan="3">
				<%
					Dim RefRecordSet
					sql = "SELECT * FROM ref_category"
					Call CreateRecordSet(RefRecordSet, sql)
					Do While not RefRecordSet.EOF
				%>
					<input type="checkbox" name="category_code" id="id_<%= RefRecordSet("category_name") %>" value="<%= RefRecordSet("category_code") %>" <% if (((category_code \ RefRecordSet("category_code")) mod 2) = 1) then %> checked="checked"<% end if %> />
					<label style="font-weight: normal" for="id_<%= RefRecordSet("category_name") %>"><%= RefRecordSet("category_name") %></label>
				<%
						RefRecordSet.MoveNext
					Loop
				%>
			</td>
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
						<td colspan="3"><input type="text" id="id_title" name="title" value="<%= title %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor1" name="content" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= content %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description" name="meta_description" style="width: 150px; height: 80px;"><%= meta_description %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords" name="meta_keywords" style="width: 150px; height: 80px;"><%= meta_keywords %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots" name="meta_robots" value="<%= meta_robots %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author" name="meta_author" value="<%= meta_author %>" /></td>
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
						<td colspan="3"><input type="text" id="id_title_bm" name="title_bm" value="<%= title_bm %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor2" name="content_bm" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= content_bm %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description_bm" name="meta_description_bm" style="width: 150px; height: 80px;"><%= meta_description_bm %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords_bm" name="meta_keywords_bm" style="width: 150px; height: 80px;"><%= meta_keywords_bm %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots_bm" name="meta_robots_bm" value="<%= meta_robots_bm %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author_bm" name="meta_author_bm" value="<%= meta_author_bm %>" /></td>
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
						<td colspan="3"><input type="text" id="id_title_chi" name="title_chi" value="<%= title_chi %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor3" name="content_chi" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= content_chi %></textarea>
			</div>
			<div style="width: 25%; float: right; padding: 10px;" class="sidebar">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2"><b>Meta Information</b></td>
					</tr>
					<tr>
						<td><label for="id_meta_description">Description</label>:</td>
						<td><textarea id="id_meta_description_chi" name="meta_description_chi" style="width: 150px; height: 80px;"><%= meta_description_chi %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_keywords">Keywords</label>:</td>
						<td><textarea id="id_meta_keywords_chi" name="meta_keywords_chi" style="width: 150px; height: 80px;"><%= meta_keywords_chi %></textarea></td>
					</tr>
					<tr>
						<td><label for="id_meta_robots">Robots</label>:</td>
						<td><input type="text" id="id_meta_robots_chi" name="meta_robots_chi" value="<%= meta_robots_chi %>" /></td>
					</tr>
					<tr>
						<td><label for="id_meta_author">Author</label>:</td>
						<td><input type="text" id="id_meta_author_chi" name="meta_author_chi" value="<%= meta_author_chi %>" /></td>
					</tr>
				</table>
			</div>
			<br clear="both" />
		</div>
	</div>
	<br />
	<div id="image">
		<label for="id_preview_image_url">Index Photo</label>:
		<input type="file" name="preview_image_url" id="id_preview_image_url" /><br />
		<% if preview_image_url <> "" then %><a href="<%= preview_image_url %>" target="_blank"><img src="<%= preview_image_url %>" /></a><% end if %>
	</div>

	<br clear="both" />
	<div>
		<input type="submit" name="submit" value="<% if Request("action") = "edit" then %>Update<% else %>Add<% end if %>" />
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
	<%
		if Request("category_code") <> "" then
			category_code = CInt(Request("category_code"))
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
		<%
			sql = "SELECT id, title, publish, modified, modified_by, MIN(category_name) as category_name, order_year, sequence, sequence_indexed FROM tbl_article ar "
			sql = sql & " INNER JOIN ref_category rc ON (((ar.category_code \ rc.category_code) mod 2) > 0)"
			sql = sql & " WHERE rc.category_group_code =  " & category_group
			if category_code <> "" and category_code > 0 then
				sql = sql & " AND ar.category_code > 0"
				sql = sql & " AND (((ar.category_code \ " & category_code & ") mod 2) = 1)"
			end if
			
			if Request("search") = "title" then
				if Request("search_query") <> "" then
					sql = sql & " AND title LIKE '%" & Replace(Request("search_query"), " ", "%") & "%'"
				end if
			end if
			
			sql = sql & " GROUP BY id, title, publish, modified, modified_by, order_year, sequence, sequence_indexed"
			sql = sql & " ORDER BY sequence_indexed DESC"

			call CreateRecordSet(RecordSet, sql)
			
			Do While not RecordSet.EOF
		%>
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
		<%
				RecordSet.MoveNext
			Loop
		%>
			</tbody>
		</table>
	</form>
<%
end if 
call CloseRecordSet(RecordSet)
call CloseDatabase()

Function SaveFiles
	Dim Upload, fileName, fileSize, ks, i, fileKey, sameSequence, sameOrderYear
	Set Upload = New FreeASPUpload
    Upload.Save(uploadsDirVar)
	
	SaveFiles = ""
    ks = Upload.UploadedFiles.keys
    if (UBound(ks) <> -1) then
        for each fileKey in Upload.UploadedFiles.keys
            SaveFiles = Upload.UploadedFiles(fileKey).FileName
        next
    else
        SaveFiles = ""
    end if
	
	if Upload.Form("submit") = "Add" then
		sql = "SELECT * FROM tbl_article"
		call CreateRecordSet(RecordSet, sql)
		RecordSet.AddNew
	else
		sql = "SELECT * FROM tbl_article WHERE id = " & article_id
		call CreateRecordSet(RecordSet, sql)
	end if
	
	if SaveFiles <> "" then
		RecordSet.Fields("preview_image_url") = "/images/" & SaveFiles
	end if
	
	if RecordSet.Fields("sequence") = CInt(Upload.Form("sequence")) then
		sameSequence = True
	else
		sameSequence = False
	end if
	
	if RecordSet.Fields("order_year") = CInt(Upload.Form("order_year")) then
		sameOrderYear = True
	else
		sameOrderYear = False
	end if
	
	
	RecordSet.Fields("title") = Upload.Form("title")
	RecordSet.Fields("publish") = Upload.Form("publish")
	if not Upload.Form("publish_start_date") = "" then
		RecordSet.Fields("publish_start_date") = Upload.Form("publish_start_date")
	end if
	RecordSet.Fields("meta_description") = Upload.Form("meta_description")
	RecordSet.Fields("meta_keywords") = Upload.Form("meta_keywords")
	RecordSet.Fields("meta_robots") = Upload.Form("meta_robots")
	RecordSet.Fields("meta_author") = Upload.Form("meta_author")
	RecordSet.Fields("content") = Upload.Form("content")
	
	RecordSet.Fields("title_bm") = Upload.Form("title_bm")
	RecordSet.Fields("content_bm") = Upload.Form("content_bm")
	RecordSet.Fields("meta_description_bm") = Upload.Form("meta_description_bm")
	RecordSet.Fields("meta_keywords_bm") = Upload.Form("meta_keywords_bm")
	RecordSet.Fields("meta_robots_bm") = Upload.Form("meta_robots_bm")
	RecordSet.Fields("meta_author_bm") = Upload.Form("meta_author_bm")
	
	RecordSet.Fields("title_chi") = Upload.Form("title_chi")
	RecordSet.Fields("content_chi") = Upload.Form("content_chi")
	RecordSet.Fields("meta_description_chi") = Upload.Form("meta_description_chi")
	RecordSet.Fields("meta_keywords_chi") = Upload.Form("meta_keywords_chi")
	RecordSet.Fields("meta_robots_chi") = Upload.Form("meta_robots_chi")
	RecordSet.Fields("meta_author_chi") = Upload.Form("meta_author_chi")
	
	RecordSet.Fields("created_by") = Session("login")
	RecordSet.Fields("modified_by") = Session("login")
	
	
	
	Dim OrderRecordSet
	sql = "SELECT COUNT(*) as 'counter' FROM tbl_article WHERE (category = 'news' OR category = 'charity' OR category = 'sponsorship') AND order_year = " & Upload.Form("order_year") & " AND sequence = " & Upload.Form("sequence")
	call CreateRecordSet(OrderRecordSet, sql)
	if OrderRecordSet.Fields("'counter'") > 0 then
		if Upload.Form("submit") = "Add" then
			sql = "UPDATE tbl_article SET sequence = sequence + 1 WHERE (category = 'news' OR category = 'charity' OR category = 'sponsorship') AND order_year = " & Upload.Form("order_year")
			call ExecuteQuery(sql)
		else
			if not sameSequence or not sameOrderYear then
				sql = "UPDATE tbl_article SET sequence = sequence + 1 WHERE (category = 'news' OR category = 'charity' OR category = 'sponsorship') AND order_year = " & Upload.Form("order_year") & " AND sequence >= " & Upload.Form("sequence")
				call ExecuteQuery(sql)
			end if
		end if
		
	end if
	
	RecordSet.Fields("sequence") = Upload.Form("sequence")
	RecordSet.Fields("order_year") = Upload.Form("order_year")
	
	Dim category_codes, code
	category_codes = Split(Upload.Form("category_code"), ",")
	
	for each code in category_codes
		category_code = category_code + CInt(code)
	next
	
	RecordSet.Fields("category_code") = category_code
	
	RecordSet.Update
	article_id = RecordSet("id")
	RecordSet.Close
	
	call CloseRecordSet(RecordSet)
	sql = "UPDATE tbl_article SET sequence_indexed = Val(format(order_year) + '' + format(sequence, '0000'))"
	Call ExecuteQuery(sql)
	
End Function

Function PadDigits(n, totalDigits)
	PadDigits = Right(String(totalDigits, "0") & n , totalDigits)
End Function
%>
<!--#include file="footer.asp" -->