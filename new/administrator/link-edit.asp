<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "Fusion Exel Content Management System"

Dim link_id, RecardSet, sql
%>
<!--#include file="header.asp" -->
<%
Dim 
%>

<script type="text/javascript">
    $(function() {
        $('#tabs').tabs();
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
</script>
<h1>VIP QP Weaver</h1>
<form method="POST" class="input_form" action="link-edit.asp?id=<%= link_id %>&amp;action=<%= Request("action") %>">
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td><label>Publish</label>:</td>
            <td><input type="radio" name="publish" value="false" <% if publish = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if publish = true then %>checked="checked"<% end if %> /> Yes</td>
            <td><label for="id_order_index">Order:</label></td>
            <td><input type="text" name="order_index" id="id_order_index" value="<% if order_index > 0 then %><%= order_index %><% else %><%= getLatestLinksSequence() %><% end if %>" /></td>
        </tr>
        <tr>
            <td><label>Article</label>:</td>
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
                        <td colspan="3"><input type="text" id="id_link_title" name="link_title" value="<%= link_title %>" maxlength="255" size="80" />
                    </tr>
                </table>
                <br />
                <textarea id="editor1" name="link_short_description" rows="15" cols="80" style="width: 100%; border: 0px !important;"><%= link_short_description %></textarea>
            </div>
            <br clear="both" />
        </div>
        <div id="tab-2">
            <div style="width: 100%; float: left;" class="form_main_container">
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td><label for="id_title">Title</label>:</td>
                        <td colspan="3"><input type="text" id="id_link_title_bm" name="link_title_bm" value="<%= link_title_bm %>" maxlength="255" size="80" />
                    </tr>
                </table>
                <br />
                <textarea id="editor2" name="link_short_description_bm" rows="15" cols="80" style="width: 100%; border: 0px !important;"><%= link_short_description_bm %></textarea>
            </div>
            <br clear="both" />
        </div>
        <div id="tab-3">
            <div style="width: 100%; float: left;" class="form_main_container">
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td><label for="id_title_chi">Title</label>:</td>
                        <td colspan="3"><input type="text" id="id_link_title_chi" name="link_title_chi" value="<%= link_title_chi %>" maxlength="255" size="80" />
                    </tr>
                </table>
                <br />
                <textarea id="editor3" name="link_short_description_chi" rows="15" cols="80" style="width: 100%; border: 0px !important;"><%= link_short_description_chi %></textarea>
            </div>
            <br clear="both" />
        </div>
    </div>
    <br />
    <div>
		<input type="submit" name="submit" value="<% if Request("action") = "edit" then %>Update<% else %>Add<% end if %>" />
        <input type="button" name="back" value="Cancel" onclick="window.location = 'links.asp'" />
	</div>
    
</form>