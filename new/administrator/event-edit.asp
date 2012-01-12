<!--#include file="../libraries.asp" -->
<%
Dim page_title
page_title = "[Event] Fusion Excel Content Management System"

Dim event_id, RecordSet, sql
%>
<!--#include file="header.asp" -->
<%
Dim event_date, publish
Dim event_country, event_city, event_name, event_details, event_venue
Dim event_country_bm, event_city_bm, event_name_bm, event_details_bm, event_venue_bm
Dim event_country_chi, event_city_chi, event_name_chi, event_details_chi, event_venue_chi

event_id = 0

if Request("action") = "" or Request("action") = "add" then
    event_date = Request("event_date")
    publish = Request("publish")
    
    event_country = Request("event_country")
    event_city = Request("event_city")
    event_name = Request("event_name")
    event_details = Request("event_details")
    event_venue = Request("event_venue")
    
    event_country_bm = Request("event_country_bm")
    event_city_bm = Request("event_city_bm")
    event_name_bm = Request("event_name_bm")
    event_details_bm = Request("event_details_bm")
    event_venue_bm = Request("event_venue_bm")
    
    event_country_chi = Request("event_country_chi")
    event_city_chi = Request("event_city_chi")
    event_name_chi = Request("event_name_chi")
    event_details_chi = Request("event_details_chi")
    event_venue_chi = Request("event_venue_chi")
    
elseif Request("action") = "edit" then
    if Request("id") = "" or not IsNumeric(Request("id")) then
        Response.Write "Invalid Event ID"
        Response.End
    end if
    event_id = CInt(Request("id"))
    sql = "SELECT event_date, publish, event_country, event_city, event_name, event_details, event_venue, event_country_bm, event_city_bm, event_name_bm, event_details_bm, event_venue_bm, event_country_chi, event_city_chi, event_name_chi, event_details_chi, event_venue_chi FROM events WHERE event_id = " & event_id
    call SetConnection(GetEventsDbPath())
    call OpenDatabase()
    call CreateRecordSet(RecordSet, sql)
    
    if RecordSet.EOF then
        Response.Write "Error! Entry not found"
        Response.End
    end if

    event_date = RecordSet("event_date")
    publish = RecordSet("publish")
    
    event_country = RecordSet("event_country")
    event_city = RecordSet("event_city")
    event_name = RecordSet("event_name")
    event_details = RecordSet("event_details")
    event_venue = RecordSet("event_venue")
    
    event_country_bm = RecordSet("event_country_bm")
    event_city_bm = RecordSet("event_city_bm")
    event_name_bm = RecordSet("event_name_bm")
    event_details_bm = RecordSet("event_details_bm")
    event_venue_bm = RecordSet("event_venue_bm")
    
    event_country_chi = RecordSet("event_country_chi")
    event_city_chi = RecordSet("event_city_chi")
    event_name_chi = RecordSet("event_name_chi")
    event_details_chi = RecordSet("event_details_chi")
    event_venue_chi = RecordSet("event_venue_chi")
end if

%>

<script type="text/javascript">
	$(function() {
		$('#tabs').tabs();
		$('#id_event_name, #id_event_country, #id_event_city, #id_event_venue, #id_event_details').blur(function() {
			var id_chi = "#" + $(this).attr('id') + "_chi";
			var id_bm = "#" + $(this).attr('id') + "_bm";
			if($(id_chi).val() == "") {
				$(id_chi).val($(this).val());
			}
			if($(id_bm).val() == "") {
				$(id_bm).val($(this).val());
			}
		});
        $('.date').datetimepicker({ampm:true });
		$('.input_form').submit(function() {
			var event_date = trimNumber($('#id_event_date').val());
			var event_name = $('#id_event_name').val();
            var event_city = $('#id_event_city').val();
            var event_country = $('#id_event_country').val();
            var event_venue = $('#id_event_venue').val();
            var event_details = $('#id_event_details').val();
            
            if (event_date == "") {
                alert('Please select the event date!');
                return false;
            } else if (event_name == "") {
                alert('Please enter the event name');
                return false;
            } else if (event_country == "") {
                alert('Please enter the country');
                return false;
            } else if (event_city == "") {
                alert('Please enter the city');
                return false;
            } else if (event_venue == "") {
                alert('Please enter the event venue');
                return false;
            } else if (event_details == "") {
                alert('Please enter the event details');
                return false;
            }
            
            return true;
		});
	});
	function trimNumber(s) {
		while (s.substr(0,1) == '0' && s.length > 1) { s = s.substr(1, 9999); }
		return s;
	}
</script>
<h1>Event</h1>
<form method="POST" class="input_form" action="event-save.asp?id=<%= event_id %>&amp;action=<%= Request("action") %>">
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
			<td width="150px"><label>Publish</label>:</td>
			<td><input type="radio" name="publish" value="false" <% if publish = false then %>checked="checked"<% end if %> /> No <input type="radio" name="publish" value="true" <% if publish = true then %>checked="checked"<% end if %> /> Yes</td>
            <td width="150px"><label for="id_event_date">Event Date:</label></td>
            <% Dim ampm %>
            <td><input type="text" id="id_event_date" name="event_date" class="date" value="<% if event_date <> "" then %><% if CDate(event_date) then %><%= Month(CDate(event_date)) %>/<%= Day(CDate(event_date)) %>/<%= Year(CDate(event_date)) %><%= " " %><% if Hour(CDate(event_date)) > 12 then %><%= Hour(Cdate(event_date)) - 12 %><% ampm = "PM" %><% else %><%= Hour(Cdate(event_date)) %><% ampm = "AM" %><% end if %>:<%= PadDigits(Minute(Cdate(event_date)), 2) %><%= " " %><%= ampm %><% end if %><% end if %>" readonly="readonly" /><a href="javascript:void(0)" onclick="$('#id_event_date').val('');" style="font-size:9px;"><u>Clear</u></a>
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
						<td><label for="id_event_name">Event Name</label>:</td>
						<td colspan="3"><input type="text" id="id_event_name" name="event_name" value="<%= event_name %>" maxlength="255" size="80" /></td>
					</tr>
                    <tr>
						<td><label for="id_event_country">Country</label>:</td>
						<td><input type="text" id="id_event_country" name="event_country" value="<%= event_country %>" maxlength="20" size="20" /></td>
                        <td><label for="id_event_city">City</label>:</td>
						<td><input type="text" id="id_event_city" name="event_city" value="<%= event_city %>" maxlength="30" size="30" /></td>
					</tr>
                    <tr>
                        <td><label for="id_event_venue">Venue</label>:</td>
                        <td colspan="3"><input type="text" id="id_event_venue" name="event_venue" value="<%= event_venue %>" maxlength="50" size="50" /></td>
                    </tr>
                    <tr>
                        <td><label for="id_event_details">Details</label>:</td>
                        <td colspan="3"><textarea id="id_event_details" name="event_details" rows="5" cols="80"><%= event_details %></textarea></td>
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
						<td><label for="id_event_name_bm">Event Name</label>:</td>
						<td colspan="3"><input type="text" id="id_event_name_bm" name="event_name_bm" value="<%= event_name_bm %>" maxlength="255" size="80" /></td>
					</tr>
                    <tr>
						<td><label for="id_event_country_bm">Country</label>:</td>
						<td><input type="text" id="id_event_country_bm" name="event_country_bm" value="<%= event_country_bm %>" maxlength="20" size="20" /></td>
                        <td><label for="id_event_city_bm">City</label>:</td>
						<td><input type="text" id="id_event_city_bm" name="event_city_bm" value="<%= event_city_bm %>" maxlength="30" size="30" /></td>
					</tr>
                    <tr>
                        <td><label for="id_event_venue_bm">Venue</label>:</td>
                        <td colspan="3"><input type="text" id="id_event_venue_bm" name="event_venue_bm" value="<%= event_venue_bm %>" maxlength="50" size="50" /></td>
                    </tr>
                    <tr>
                        <td><label for="id_event_details_bm">Details</label>:</td>
                        <td colspan="3"><textarea id="id_event_details_bm" name="event_details_bm" rows="5" cols="80"><%= event_details_bm %></textarea></td>
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
						<td><label for="id_event_name_chi">Event Name</label>:</td>
						<td colspan="3"><input type="text" id="id_event_name_chi" name="event_name_chi" value="<%= event_name_chi %>" maxlength="255" size="80" /></td>
					</tr>
                    <tr>
						<td><label for="id_event_country">Country</label>:</td>
						<td><input type="text" id="id_event_country_chi" name="event_country_chi" value="<%= event_country_chi %>" maxlength="20" size="20" /></td>
                        <td><label for="id_event_city_chi">City</label>:</td>
						<td><input type="text" id="id_event_city_chi" name="event_city_chi" value="<%= event_city_chi %>" maxlength="30" size="30" /></td>
					</tr>
                    <tr>
                        <td><label for="id_event_venue_chi">Venue</label>:</td>
                        <td colspan="3"><input type="text" id="id_event_venue_chi" name="event_venue_chi" value="<%= event_venue_chi %>" maxlength="50" size="50" /></td>
                    </tr>
                    <tr>
                        <td><label for="id_event_details_chi">Details</label>:</td>
                        <td colspan="3"><textarea id="id_event_details_chi" name="event_details_chi" rows="5" cols="80"><%= event_details_chi %></textarea></td>
                    </tr>
				</table>
				<br />
			</div>
			<br clear="both" />
		</div>
	</div>
	<br />
    <div>
		<input type="submit" name="submit" value="<% if Request("action") = "edit" then %>Update<% else %>Add<% end if %>" />
        <input type="button" name="back" value="Cancel" onclick="window.location = 'events.asp'" />
	</div>
</form>
<%
if not RecordSet.EOF then
    call CloseRecordSet(RecordSet)
    call CloseDatabase()
end if
%>