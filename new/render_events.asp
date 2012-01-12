<%
' Dependancies: The parent file must included libraries before run this files '
Dim OFFSET, lang, category_code
Dim objXml, lang_index
' 1 - EN; 2 - BM; 3 - CHI '
lang = base_lang
' 1 - News & Event, 2 - Charities, 3 - Sponsorship '
category_code = 1
lang_index = lang

Dim year

year = 0

if Request("year") <> "" and IsNumeric(Request("year")) then
    year = CInt(Request("year"))
end if

%>
<tr>
<td width="180" valign="top">
<!-- Siderbar Start -->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-bottom: 25px;">
<tr>
<td colspan="2">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td width="15px" background="img/header.gif"></td>
<td width="163" height="25px" background="img/header.gif" class="smallhead"><% if lang = 3 then %>活动事項<% elseif lang = 2 then %>Peristiwa Akan Datang<% else %>Upcoming Events<% end if %></td>
</tr>
<tr valign="top">

<%
Dim fileStream, file, fc
set fileStream = CreateObject("Scripting.FileSystemObject")
set file = fileStream.GetFolder(Server.MapPath(GetIndexedPath("events")))
set fc = file.files

For Each f1 in fc
    if year = 0 then
        year = CInt(Replace(f1.name, ".xml", ""))
    end if
    %>
    <tr><td height="3" colspan="2"></td></tr>
    <tr>
        <td colspan="2" bgcolor="#5A71AB">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="25" height="23" align="center" background="img/buttonbg_lightblue.gif">
                            <img src="img/buttonbg_lightblue_icon.gif" width="15" height="15">
                        </td>
                        <td width="163" background="img/buttonbg_lightblue.gif">
                            <a style="max-height: 30px; max-width: 150px;" class="iflink" href="events.asp?year=<%= Replace(f1.name, ".xml", "") %>" target="_top"><%= Replace(f1.name, ".xml", "") %></a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </td>
    </tr>
    <%
Next

%>

</tr>
</tbody>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
<!-- Siderbar end -->
</td>
<td width="10" valign="top">&nbsp;</td>
<td width="740" valign="top">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<img src="img/banner_upcoming.jpg" width="740" height="170" />
</td>
</tr>
<tr>
<td height="8"></td>
</tr>
<tr>
<td valign="top" bgcolor="#999999">
<table width="100%" border="0" cellspacing="1" cellpadding="10">
<tbody>
<tr>
<td valign="top" bgcolor="#EEF0FC">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td class="conthead">
<div style="margin-bottom: 5px;">Summary of Upcoming Events <%= year %>.</div>
</td>
</tr>
<tr>
<td>
<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#B9C8E6">
<tbody>
<tr align="center" bgcolor="#1449CB" class="font_white14 header_title">
<td width="15%" heogjt="40">
<div align="center">
<span class="header_title style4"><b>Date</b><br /></span>
<span class="style4"><b>(DD/MM)</b></span>
</div>
</td>
<td height="40" class="header_title">
<div align="center">
<span class="style4">Country</span>
</div>
</td>
<td width="10%" height="40" class="header_title">
<div align="center">
<span class="style4">City</span>
</div>
</td>
<td width="25%" height="40" class="header_title">
<div align="center">
<span class="style4">Name of Events</span>
</div>
</td>
<td width="20%" height="40" class="header_title">
<div align="center">
<span class="style4">Venue</span>
</div>
</td>
<td width="10%" height="40" class="header_title">
<div align="center">
<span class="style4">Time</span>
</div>
</td>
<td width="10%" height="40" class="header_title">
<div align="center">
<span class="style4">Details</span>
</div>
</td>
</tr>
<%
Dim events, item
set objXml = GetIndexedEvents(year)
set events = objXml.selectNodes("events/event")
Dim event_date, country, city, name, venue, details, event_id, publish, ampm
for each item in events
    event_id = item.childNodes(0).text
    event_date = item.childNodes(1).text
    publish = item.childNodes(2).text
    
    country = item.childNodes(lang_index + 2).text
    city = item.childNodes(lang_index + 3).text
    name = item.childNodes(lang_index + 4).text
    details = item.childNodes(lang_index + 5).text
    venue = item.childNodes(lang_index + 6).text
    
    if LCase(publish) = "true" then
    %>
    <tr class="content_table">
        <td height="45" align="center" class="smallcont"><%= Day(CDate(event_date)) %>-<%= MonthAbbr(Month(Cdate(event_date))) %></td>
        <td align="center" class="smallcont"><%= country %></td>
        <td align="center" class="smallcont"><%= city %></td>
        <td align="center" class="smallcont"><%= name %></td>
        <td align="center" class="smallcont"><%= venue %></td>
        <td align="center" class="smallcont"><% if Hour(CDate(event_date)) > 12 then %><%= Hour(Cdate(event_date)) - 12 %><% ampm = "PM" %><% else %><%= Hour(Cdate(event_date)) %><% ampm = "AM" %><% end if %>:<%= PadDigits(Minute(Cdate(event_date)), 2) %><%= " " %><%= ampm %></td>
        <td align="center" class="smallcont"><%= details %></td>
    </tr>
    <%
    end if
Next
%>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</table>
</td>
</tr>