<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "Fusion Excel Content Management System"

Dim service_centre_id, RecordSet, sql
%>
<!--#include file="header.asp" -->
<%
Dim content, content_bm, content_chi
Dim country_name, country_name_bm, country_name_chi
Dim publish, content_filename, order_index

service_centre_id = 0

if Request("action") = "" or Request("action") = "add" then
    publish = Request("publish")
    order_index = Request("order_index")
    country_name = Request("country_name")
    country_name_bm = Request("country_name_bm")
    country_name_chi = Request("country_name_chi")
    content = Request("content")
    content_bm = Request("content_bm")
    content_chi = Request("content_chi")
elseif Request("action") = "edit" then
    if Request("id") = "" or not IsNumeric(Request("id")) then
        Response.Write "Invalid Service Centre ID"
        Response.End
    end if
    service_centre_id = CInt(Request("id"))
    sql = "SELECT country_name, country_name_bm, country_name_chi, publish, order_index, content_filename FROM service_centres WHERE service_centre_id = " & service_centre_id
    call SetConnection(GetSCDbPath())
    call OpenDatabase()
    call CreateRecordSet(RecordSet, sql)
    
    if RecordSet.EOF then
        Response.Write "Error! Entry not found"
        Response.End
    end if
    Dim xmlContent
    country_name = RecordSet("country_name")
    country_name_bm = RecordSet("country_name_bm")
    country_name_chi = RecordSet("country_name_chi")
    publish = RecordSet("publish")
    order_index = RecordSet("order_index")
    content_filename = RecordSet("content_filename")
    set xmlContent = getSCContent(content_filename)
    if xmlContent.length > 0 then
        content = xmlContent.item(0).selectSingleNode("en/content").text
        content_bm = xmlContent.item(0).selectSingleNode("bm/content").text
        content_chi = xmlContent.item(0).selectSingleNode("chi/content").text
    end  if
end if


%>
<script type="text/javascript">
	$(function() {
		$('#tabs').tabs();
		$('#id_country_name, #id_content').blur(function() {
			var id_chi = "#" + $(this).attr('id') + "_chi";
			var id_bm = "#" + $(this).attr('id') + "_bm";
			if($(id_chi).val() == "") {
				$(id_chi).val($(this).val());
			}
			if($(id_bm).val() == "") {
				$(id_bm).val($(this).val());
			}
		});
		$('.input_form').submit(function() {
			var sequence = trimNumber($('#id_order_index').val());
			if(!((parseFloat(sequence) == parseInt(sequence)) && !isNaN(sequence))) {
				alert("Please enter integer value for Order Number");
				return false;
			}
		});
		
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
	});
	function trimNumber(s) {
		while (s.substr(0,1) == '0' && s.length > 1) { s = s.substr(1, 9999); }
		return s;
	}
</script>
<h1>Service Centre</h1>
<form method="POST" class="input_form" action="service_centre-save.asp?id=<%= service_centre_id %>&amp;action=<%= Request("action") %>">
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
			<td><label>Publish</label>:</td>
			<td><input type="radio" name="publish" value="false" <% if publish = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if publish = true then %>checked="checked"<% end if %> /> Yes</td>
			<td><label for="id_order_index">Order:</label></td>
			<td><input type="text" name="order_index" id="id_order_index" value="<% if order_index > 0 then %><%= order_index %><% else %><%= getLatestSCSequence() %><% end if %>" /></td>
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
			<div style="width: 100%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_country_name" name="country_name" value="<%= country_name %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor1" name="content" rows="15" cols="80" style="width: 100%; border: 0px !important;"><%= content %></textarea>
			</div>
			<br clear="both" />
		</div>
		<div id="tab-2">
			<div style="width: 100%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_country_name_bm" name="country_name_bm" value="<%= country_name_bm %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor2" name="content_bm" rows="15" cols="80" style="width: 100%; border: 0px !important;"><%= content_bm %></textarea>
			</div>
			<br clear="both" />
		</div>
		<div id="tab-3">
			<div style="width: 100%; float: left;" class="form_main_container">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><label for="id_title">Title</label>:</td>
						<td colspan="3"><input type="text" id="id_country_name_chi" name="country_name_chi" value="<%= country_name_chi %>" maxlength="255" size="80" /></td>
					</tr>
				</table>
				<br />
				<textarea id="editor3" name="content_chi" rows="15" cols="80" style="width: 100%; border: 0px !important;"><%= content_chi %></textarea>
			</div>
			<br clear="both" />
		</div>
	</div>
	<br />
    <div>
		<input type="submit" name="submit" value="<% if Request("action") = "edit" then %>Update<% else %>Add<% end if %>" />
        <input type="button" name="back" value="Cancel" onclick="window.location = 'service_centres.asp'" />
	</div>
</form>
<%
call CloseRecordSet(RecordSet)
call CloseDatabase()
%>