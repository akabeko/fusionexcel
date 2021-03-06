﻿<%@ Language=VBScript %>
<%
option explicit
Response.Expires = -1
Response.CharSet = "utf-8"
Server.ScriptTimeout = 600
Session.CodePage = 65001

Dim page_title
page_title = "Fusion Excel Content Management System"

Dim article_id, RecordSet, sql, uploadsDirVar
uploadsDirVar = Server.MapPath("/images/")
%>
<!--#include file="../libraries.asp" -->
<!--#include file="freeaspupload.asp" -->
<!--#include file="header.asp" -->
<%

Dim publish, publish_start_date, index_image_url
Dim title, content, meta_description, meta_keywords, meta_robots, meta_author
Dim title_bm, content_bm, meta_description_bm, meta_keywords_bm, meta_robots_bm, meta_author_bm
Dim title_chi, content_chi, meta_description_chi, meta_keywords_chi, meta_robots_chi, meta_author_chi
Dim alt_title, alt_title_bm, alt_title_chi
Dim sequence, order_year
Dim category_code

article_id = 0

if Request("action") = "" or Request("action") = "add" then
    publish = Request("publish")
    publish_start_date = Request("publish_start_date")
    index_image_url = Request("index_image_url")
    sequence = Request("sequence")
    order_year = Request("order_year")
	category_code = Request("category_code")

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
    
    alt_title = Request("alt_title")
    alt_title_bm = Request("alt_title_bm")
    alt_title_chi = Request("alt_title_chi")
elseif Request("action") = "edit" then
	if Request("id") = "" or not IsNumeric(Request("id")) then
		Response.Write "Invalid Article ID"
		Response.End
	End If
	article_id = CInt(Request("id"))
	sql = "SELECT title, index_image_url, publish_start_date, publish, sequence, order_year, category_code, content_filename FROM article WHERE article_id = " & article_id
	Call SetConnection(GetArticleDbPath())
	Call OpenDatabase()
	Call CreateRecordSet(RecordSet, sql)
	
	if RecordSet.EOF then
		Response.Write "Error: Article not found"
		Response.End
	End If
    Dim xmlContent
	title = RecordSet("title")
	publish = RecordSet("publish")
	publish_start_date = RecordSet("publish_start_date")
	index_image_url = RecordSet("index_image_url")
	sequence = RecordSet("sequence")
	order_year = RecordSet("order_year")
	category_code = RecordSet("category_code")
	set xmlContent = getArticleContent(RecordSet("content_filename"))
    if xmlContent.length > 0 then
        title = xmlContent.item(0).selectSingleNode("en/title").text
        content = xmlContent.item(0).selectSingleNode("en/content").text
        meta_description = xmlContent.item(0).selectSingleNode("en/meta/description").text
        meta_keywords = xmlContent.item(0).selectSingleNode("en/meta/keyword").text
        meta_robots = xmlContent.item(0).selectSingleNode("en/meta/robots").text
        meta_author = xmlContent.item(0).selectSingleNode("en/meta/author").text
        
        title_bm = xmlContent.item(0).selectSingleNode("bm/title").text
        content_bm = xmlContent.item(0).selectSingleNode("bm/content").text
        meta_description_bm = xmlContent.item(0).selectSingleNode("bm/meta/description").text
        meta_keywords_bm = xmlContent.item(0).selectSingleNode("bm/meta/keyword").text
        meta_robots_bm = xmlContent.item(0).selectSingleNode("bm/meta/robots").text
        meta_author_bm = xmlContent.item(0).selectSingleNode("bm/meta/author").text
        
        title_chi = xmlContent.item(0).selectSingleNode("chi/title").text
        content_chi = xmlContent.item(0).selectSingleNode("chi/content").text
        meta_description_chi = xmlContent.item(0).selectSingleNode("chi/meta/description").text
        meta_keywords_chi = xmlContent.item(0).selectSingleNode("chi/meta/keyword").text
        meta_robots_chi = xmlContent.item(0).selectSingleNode("chi/meta/robots").text
        meta_author_chi = xmlContent.item(0).selectSingleNode("chi/meta/author").text
        
        if xmlContent.item(0).selectNodes("en/alt_title").length > 0 then
            alt_title = xmlContent.item(0).selectSingleNode("en/alt_title").text
        end if
        if xmlContent.item(0).selectNodes("bm/alt_title").length > 0 then
            alt_title_bm = xmlContent.item(0).selectSingleNode("bm/alt_title").text
        end if
        if xmlContent.item(0).selectNodes("chi/alt_title").length > 0 then
            alt_title_chi = xmlContent.item(0).selectSingleNode("chi/alt_title").text
        end if
    End if
end if
%>
<script type="text/javascript">
	$(function() {
        <% if Request("success") = "1" then %>
            $('#dialog').dialog({
                autoOpen: true,
                show: "fade",
                hide: "fade",
                modal: true,
                resizeable: false,
                buttons: {
                    Ok: function() {
                        $(this).dialog("close");
                    }
                }
            });
        <% end if %>
		$('#tabs').tabs();
        $('.url-category').change(function() {
            var base_url = $('#id-preview-url').attr('data-base-url');
            $('#id-preview-url').val(base_url + "&" + $(this).val());
            $('#id-preview-url').focus();
            $('#id-preview-url').select();
        });
        $('#id-preview-url').click(function(){
            $(this).focus();
            $(this).select();
        });
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
		$('.date').datepicker();
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
		
		CKEDITOR.replace('id_content', {
			filebrowserBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html',
			filebrowserImageBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html?type=Flash',
			filebrowserUploadUrl: '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
		CKEDITOR.replace('id_content_bm', {
			filebrowserBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html',
			filebrowserImageBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html?type=Flash',
			filebrowserUploadUrl: '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
		CKEDITOR.replace('id_content_chi', {
			filebrowserBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html',
			filebrowserImageBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html?type=Images',
			filebrowserFlashBrowseUrl: '<%= GetCKFinderPath() %>ckfinder.html?type=Flash',
			filebrowserUploadUrl: '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Files',
			filebrowserImageUploadUrl : '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Images&currentFolder=/images/',
			filebrowserFlashUploadUrl : '<%= GetCKFinderPath() %>core/connector/asp/connector.asp?command=QuickUpload&type=Flash'
		});
	});
	function trimNumber(s) {
		while (s.substr(0,1) == '0' && s.length > 1) { s = s.substr(1, 9999); }
		return s;
	}
</script>
<% if Request("success") = "1" then %>
    <div id="dialog">
        Data update successfully!
    </div>
<% end if %>
<form method="POST" enctype="multipart/form-data" accept-charset="utf-8" class="input_form" action="article-save.asp?id=<%= article_id %>&amp;action=<%= Request("action") %>">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td><label>Publish</label>:</td>
			<td><input type="radio" name="publish" value="false" <% if publish = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if publish = true then %>checked="checked"<% end if %> /> Yes</td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td><label for="id_publish_start_date">Start Publish Date</label>:</td>
			<td><input type="text" id="id_publish_start_date" name="publish_start_date" class="date" value="<% if publish_start_date <> "" then %><% if CDate(publish_start_date) then %><%= Month(CDate(publish_start_date)) %>/<%= Day(CDate(publish_start_date)) %>/<%= Year(CDate(publish_start_date)) %><% end if %><% end if %>" readonly="readonly" /><a href="javascript:void(0)" onclick="$('#id_publish_start_date').val('');" style="font-size:9px;"><u>Clear</u></a></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td><label for="id_order">Sequence Number</label>:</td>
			<td><input type="text" id="id_sequence" name="sequence" value="<% if sequence = "" then %><%= PadDigits(getLatestArticleSequence(), 4) %><% else %><%= PadDigits(sequence, 4) %><% end if %>" maxlength="4" /></td>
			<td><label for="id_order_year">Sequence Year</label>:</td>
			<td><input type="text" id="id_order_year" name="order_year" class="date_year" value="<% if order_year = "" then %><%= Year(Now()) %><% else %><%= order_year %><% end if %>" maxlength="4" /></td>
		</tr>
		<tr>
			<td><label for="id_category">Category</label>:</td>
			<td colspan="3">
				<%
					Dim categories, index
					categories = getCategoriesList()
					For index = 0 to UBound(categories, 2)
                        if categories(1, index) <> "" then
                        %>
                            <input type="checkbox" name="category_code" id="id_<%= categories(1, index) %>" value="<%= categories(0, index) %>" <% if category_code > 0 and categories(0, index) > 0 then %><% if (((category_code \ categories(0, index)) mod 2) = 1) then %> checked="checked"<% end if %><% end if %> />
                            <label style="font-weight: normal" for="id_<%= categories(1, index) %>"><%= categories(1, index) %></label>
                        <%
                        end if
					Next
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
                    <tr>
                        <td><label for="id_alt_title">Alternate Title</label>:</td>
						<td colspan="3"><input type="text" id="id_alt_title" name="alt_title" value="<%= alt_title %>" maxlength="255" size="80" /></td>
                    </tr>
				</table>
				<br />
				<textarea id="id_content" name="content" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= content %></textarea>
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
						<td><label for="id_title_bm">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_title_bm" name="title_bm" value="<%= title_bm %>" maxlength="255" size="80" /></td>
					</tr>
                    <tr>
                        <td><label for="id_alt_title_bm">Alternate Title</label>:</td>
						<td colspan="3"><input type="text" id="id_alt_title_bm" name="alt_title_bm" value="<%= alt_title_bm %>" maxlength="255" size="80" /></td>
                    </tr>
				</table>
				<br />
				<textarea id="id_content_bm" name="content_bm" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= content_bm %></textarea>
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
						<td><label for="id_title_chi">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_title_chi" name="title_chi" value="<%= title_chi %>" maxlength="255" size="80" /></td>
					</tr>
                    <tr>
                        <td><label for="id_alt_title_chi">Alternate Title</label>:</td>
						<td colspan="3"><input type="text" id="id_alt_title_chi" name="alt_title_chi" value="<%= alt_title_chi %>" maxlength="255" size="80" /></td>
                    </tr>
				</table>
				<br />
				<textarea id="id_content_chi" name="content_chi" rows="15" cols="80" style="width: 80%; border: 0px !important;"><%= content_chi %></textarea>
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
		<input type="file" name="index_image_url" id="id_index_image_url" /><br />
		<% if index_image_url <> "" then %><a href="<%= index_image_url %>" target="_blank"><img src="<%= index_image_url %>" /></a><% end if %>
	</div>

	<br clear="both" />
    <label>Preview Url:</label>
    <input type="text" size="100" id="id-preview-url" data-base-url="<%= "article.asp?id=" & Request("id") %>" value="<%=  "article.asp?id=" & Request("id") %>" readonly="readonly" />
    <br />
    <%
        categories = getCategoriesList()
        For index = 0 to UBound(categories, 2)
            if categories(1, index) <> "" then
            %>
                <input type="radio" name="url-category" class="url-category" id="id_url_category_<%= categories(0, index) %>" value="category_code=<%= categories(0, index) %>" />
                <label style="font-weight: normal" for="id_url_category_<%= categories(0, index) %>"><%= categories(1, index) %></label>
            <%
            end if
        Next
    %>
    <br /><br clear="both" />
	<div>
		<input type="submit" name="submit" value="<% if Request("action") = "edit" then %>Update<% else %>Add<% end if %>" />
        <input type="button" name="back" value="Cancel" onclick="window.location = 'article.asp'" />
	</div>
</form>
<!--#include file="footer.asp" -->
<%
call CloseRecordSet(RecordSet)
call CloseDatabase()
%>