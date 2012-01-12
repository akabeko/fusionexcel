<%
Response.CharSet = "utf-8"
Server.ScriptTimeout = 600
%>
<!--#include file="../libraries.asp" -->
<%

Dim sql, event_id, RecordSet

if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
    Response.Redirect "event-edit.asp?id=" & Request("id") & "&action=" & Request("action") & "&error=not_supported"
end if

event_id = 0

if Request("id") <> "" and IsNumeric(Request("id")) and CInt(Request("id")) > 0 then
    event_id = CInt(Request("id"))
end if

Call SetConnection(GetEventsDbPath())
Call OpenDatabase()

Dim sameSequence

if Request("submit") = "Add" then
    sql = "SELECT * FROM events"
    call CreateRecordSet(RecordSet, sql)
    RecordSet.AddNew
    RecordSet.Fields("created_by") = Session("login")
    RecordSet.Fields("created") = Now()
else
    sql = "SELECT * FROM events WHERE event_id = " & event_id
    call CreateRecordSet(RecordSet, sql)
end if

RecordSet.Fields("publish") = Request("publish")
RecordSet.Fields("event_date") = Request("event_date")

RecordSet.Fields("event_country") = Request("event_country")
RecordSet.Fields("event_city") = Request("event_city")
RecordSet.Fields("event_name") = Request("event_name")
RecordSet.Fields("event_details") = Request("event_details")
RecordSet.Fields("event_venue") = Request("event_venue")

RecordSet.Fields("event_country_bm") = Request("event_country_bm")
RecordSet.Fields("event_city_bm") = Request("event_city_bm")
RecordSet.Fields("event_name_bm") = Request("event_name_bm")
RecordSet.Fields("event_details_bm") = Request("event_details_bm")
RecordSet.Fields("event_venue_bm") = Request("event_venue_bm")


RecordSet.Fields("event_country_chi") = Request("event_country_chi")
RecordSet.Fields("event_city_chi") = Request("event_city_chi")
RecordSet.Fields("event_name_chi") = Request("event_name_chi")
RecordSet.Fields("event_details_chi") = Request("event_details_chi")
RecordSet.Fields("event_venue_chi") = Request("event_venue_chi")


RecordSet.Fields("last_modified_by") = Session("login")
RecordSet.Fields("last_modified") = Now()

RecordSet.Update

event_id = RecordSet("event_id")

RecordSet.Close

call CloseRecordSet(RecordSet)
call ReindexEvents(Year(CDate(Request("event_date"))))

Response.Redirect("event-edit.asp?action=edit&id=" & event_id)
%>