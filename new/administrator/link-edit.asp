<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "Fusion Exel Content Management System"

Dim link_id, RecordSet, sql
%>
<!--#include file="header.asp" -->
<%
Dim publish, order_index, article_name, article_id, article_category_code, image_url
Dim link_title, link_title_bm, link_title_chi
Dim link_short_description, link_short_description_bm, link_short_description_chi

link_id = 0

if Request("action") = "" or Request("action") = "add" then
    publish = Request("publish")
    order_index = Request("order_index")
    article_name = Request("article_name")
    article_id = Request("article_id")
    article_category_code = Request("article_category_code")
    image_url = Request("image_url")
    link_title = Request("link_title")
    link_short_description = Request("link_short_description")
    link_title_bm = Request("link_title_bm")
    link_short_description_bm = Request("link_short_description_bm")
    link_title_chi = Request("link_title_chi")
    link_short_description_chi = Request("link_short_description_chi")
elseif Request("action") = "edit" then
    if Request("id") = "" or not IsNumeric(Request("id")) then
        Response.Write "Invalid Link ID"
        Response.End
    end if
    link_id = CInt(Request("id"))
    sql = "SELECT article_name, article_id, article_category_code, publish, order_index, image_url, link_title, link_title_bm, link_title_chi, link_short_description, link_short_description_bm, link_short_description_chi FROM links WHERE link_id = " & link_id
    call SetConnection(GetLinksDbPath())
    call OpenDatabase()
    call CreateRecordSet(RecordSet, sql)
    
    if RecordSet.EOF then
        Response.Write "Error! Entry not found"
        Response.End
    end if

    publish = RecordSet("publish")
    order_index = RecordSet("order_index")
    article_name = RecordSet("article_name")
    article_id = RecordSet("article_id")
    article_category_code = RecordSet("article_category_code")
    image_url = RecordSet("image_url")
    link_title = RecordSet("link_title")
    link_short_description = RecordSet("link_short_description")
    link_title_bm = RecordSet("link_title_bm")
    link_short_description_bm = RecordSet("link_short_description_bm")
    link_title_chi = RecordSet("link_title_chi")
    link_short_description_chi = RecordSet("link_short_description_chi")
    
end if
%>

<script type="text/javascript">
    $(function() {
        $('#tabs').tabs();
        $('.input_form').submit(function() {
            var article_id = $('#id_article_id').val();
            var order_index = trimNumber($('#id_order_index').val());
            
            if(!((parseFloat(order_index) == parseInt(order_index)) && !isNaN(order_index))) {
				alert("Please enter integer value for Order Number");
				return false;
			}
			else if(!((parseFloat(article_id) == parseInt(article_id)) && !isNaN(article_id))) {
                alert("Please select an article")
                return false;
            }
        });
        $("#id_article_name").keyup(function() {
            
            $.ajax({
                dataType: 'xml', type: 'POST', url: 'ajax-article-search.asp',
                data: $('#id_article_name').val(),
                success: function(xmlResponse) {
                    alert();
                    var data = $("article", xmlResponse).map(function() {
                        return {
                            value: $("title", this).text(),
                            id: $("article_id", this).text()
                        };
                    }).get();
                    $("#id_article_name").autocomplete({
                        source: data,
                        minLength: 0,
                        select: function(event, ui) {
                        
                        }
                    });
                }
            });
        });
    });
    function trimNumber(s) {
		while (s.substr(0,1) == '0' && s.length > 1) { s = s.substr(1, 9999); }
		return s;
	}
</script>
<h1>VIP QP Weaver</h1>
<form method="POST" enctype="multipart/form-data" accept-charset="utf-8" class="input_form" action="link-edit.asp?id=<%= link_id %>&amp;action=<%= Request("action") %>">
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
            <td width="150px"><label>Publish</label>:</td>
            <td><input type="radio" name="publish" value="false" <% if publish = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if publish = true then %>checked="checked"<% end if %> /> Yes</td>
            <td><label for="id_order_index">Order:</label></td>
            <td><input type="text" name="order_index" id="id_order_index" value="<% if order_index > 0 then %><%= order_index %><% else %><%= getLatestLinksSequence() %><% end if %>" /></td>
        </tr>
        <tr>
            <td><label>Article</label>:</td>
            <td>
                <input type="text" name="article_name" id="id_article_name" value="<%= article_name %>" size="50" />
                <input type="hidden" name="article_id" id="id_article_id" value="<%= article_id %>" />
                <input type="hidden" name="article_category_code" id="id_article_category_code" value="<%= article_category_code %>" />
                <button>Search</button>
            </td>
            <td></td>
            <td></td>
        </tr>
    </table>
    <br /><br />
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
                        <td width="150px"><label for="id_title">Title</label>:</td>
                        <td><input type="text" id="id_link_title" name="link_title" value="<%= link_title %>" maxlength="255" size="80" />
                    </tr>
                    <tr>
                        <td><label for="id_link_short_description">Short Description</label>:</td>
                        <td><textarea name="link_short_description" rows="5" cols="80"><%= link_short_description %></textarea></td>
                    </tr>
                </table>
                <br />
            </div>
            <br clear="both" />
        </div>
        <div id="tab-2">
            <div style="width: 100%; float: left;" class="form_main_container">
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td width="150px"><label for="id_link_title_bm">Title</label>:</td>
                        <td><input type="text" id="id_link_title_bm" name="link_title" value="<%= link_title_bm %>" maxlength="255" size="80" />
                    </tr>
                    <tr>
                        <td><label for="id_link_short_description_bm">Short Description</label>:</td>
                        <td><textarea id="id_link_short_description_bm" name="link_short_description_bm" rows="5" cols="80"><%= link_short_description_bm %></textarea></td>
                    </tr>
                </table>
                <br />
            </div>
            <br clear="both" />
        </div>
        <div id="tab-3">
            <div style="width: 100%; float: left;" class="form_main_container">
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td width="150px"><label for="id_link_title_chi">Title</label>:</td>
                        <td><input type="text" id="id_link_title_chi" name="link_title_chi" value="<%= link_title_chi %>" maxlength="255" size="80" />
                    </tr>
                    <tr>
                        <td><label for="id_link_short_description_chi">Short Description</label>:</td>
                        <td><textarea id="id_link_short_description_chi" name="link_short_description_chi" rows="5" cols="80"><%= link_short_description_chi %></textarea></td>
                    </tr>
                </table>
                <br />
            </div>
            <br clear="both" />
        </div>
    </div>
    <br />
    <div id="image">
        <table border="0" cellpadding="2" cellspacing="0">
            <tr>
                <td><label for="id_image_url">Image</label>: <input type="file" name="image_url" id="id_image_url" /></td>
                <td width="50px"><% if image_url <> "" then %><a href="<%= image_url %>" target="_blank"><img src="<%= image_url %>" /></a><% end if %></td>
            </tr>
        </table>
        <br />		
	</div>
    <br />
    <div>
		<input type="submit" name="submit" value="<% if Request("action") = "edit" then %>Update<% else %>Add<% end if %>" />
        <input type="button" name="back" value="Cancel" onclick="window.location = 'links.asp'" />
	</div>
</form>

<div id="id_ui_dialog">

</div>