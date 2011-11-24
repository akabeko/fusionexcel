<%@ Language=VBScript %>
<%
option explicit
Response.Expires = -1
Server.ScriptTimeout = 600
Session.CodePage = 65001
Dim page_title, sql, RecordSet, uploadsDirVar
page_title = "Fusion Excel Content Management System"
uploadsDirVar = "C:\inetpub\scripts\fusionexcel\fusionexcel\trunk\images\" 
%>
<!--#include file="../data/dbCon.asp" -->
<!--#include file="freeaspupload.asp" -->
<!--#include file="header.asp" -->

<%
Call OpenDatabase()
if Request("action") <> "" then
	Dim publish, sequence, order_year
	if Request("id") <> "" then
		sql = "SELECT * FROM tbl_article_link WHERE article_link_id = " & Request("id")
		Call CreateRecordSet(RecordSet, sql)
	else
	
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
			$('#id_publish_start_date, #id_publish_end_date').datepicker();
			$('.input_form').submit(function() {
				var year = $('#id_order_year').val();
				var sequence = trimNumber($('#id_sequence').val());
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
			});
		});
		function trimNumber(s) {
			while (s.substr(0,1) == '0' && s.length > 1) { s = s.substr(1, 9999); }
			return s;
		}
	</script>
	<table cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td><label>Publish:</label></td>
			<td><input type="radio" name="publish" value="false" <% if publish = true then %>checked="checked"<% end if %>/> No <input type="radio" name="publish" value="true" <% if publish = false then %>checked="checked"<% end if %>/></td>
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
				<select name="link_type_code">
				<%
					Dim RefRecordSet
					sql = "SELECT link_type_code, link_type_name FROM ref_link_type"
					Call CreateRecordSet(RefRecordSet, sql)
					Do While not RefRecordSet.EOF
				%>
				<option value="<%= RefRecordSet("link_type_code") %>"><%= RefRecordSet("link_type_name") %></option>
				<%
						RefRecordSet.MoveNext
					Loop
				%>
				</select>
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
		<div id="tab-1"></div>
		<div id="tab-2"></div>
		<div id="tab-3"></div>
		
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
<%
elseif Request("action") = "" then
	sql = "SELECT * FROM tbl_article_link tal"
	sql = sql & " INNER JOIN ref_link_type rlt ON tal.link_type_code = rlt.link_type_code"
	Call CreateRecordSet(RecordSet, sql)
%>
<div id="button_navigator">
	<a href="article_link.asp?action=add">New Article</a>
</div>
<table width="100%" cellpadding="0" cellspacing="0" class="article_list">
	<thead>
		<tr>
			<td>ID</td>
			<td>Title</td>
			<td>Article Link</td>
			<td>Last Modified</td>
			<td>Last Modified By</td>
		</tr>
	</thead>
	<tbody>
	<%
		Do While Not RecordSet.EOF
	%>
	<tr>
		<td><%= RecordSet("article_link_id") %></td>
		<td><a href="article_link.asp?action=edit&amp;id=<%= RecordSet("id") %>"><%= RecordSet("article_link_title") %></a></td>
		<td><a href="article.asp?action=edit&amp;id=<%= RecordSet("article_id") %>" target="_blank">View Article</a></td>
		<td><%= RecordSet("last_modified") %></td>
		<td><%= RecordSet("last_modified_by") %></td>
	</tr>
	<% 
			RecordSet.MoveNext
		Loop
	%>
	</tbody>
</table>
<%
end if
%>