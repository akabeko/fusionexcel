<%
Response.CharSet = "utf-8"
Server.ScriptTimeout = 600
%>
<!--#include file="../libraries.asp" -->
<%

Dim sql, service_centre_id, RecordSet

if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
    Response.Redirect "service_centre-edit.asp?id=" & Request("id") & "&action=" & Request("action") & "&error=not_supported"
end if

service_centre_id = 0

if Request("id") <> "" and IsNumeric(Request("id")) and CInt(Request("id")) > 0 then
    service_centre_id = CInt(Request("id"))
end if

Call SetConnection(GetSCDbPath())
Call OpenDatabase()

Dim sameSequence

if Request("submit") = "Add" then
    sql = "SELECT * FROM service_centres"
    call CreateRecordSet(RecordSet, sql)
    RecordSet.AddNew
    RecordSet.Fields("created_by") = Session("login")
    RecordSet.Fields("created") = Now()
else
    sql = "SELECT * FROM service_centres WHERE service_centre_id = " & service_centre_id
    call CreateRecordSet(RecordSet, sql)
end if
if RecordSet.Fields("order_index") = CInt(Request("order_index")) then
    sameSequence = True
end if

Dim OrderRecordSet
sql = "SELECT COUNT(1) AS 'counter' FROM service_centres WHERE order_index = " & Request("order_index")
call CreateRecordSet(OrderRecordSet, sql)
if OrderRecordSet.Fields("'counter'") > 0 then
    if not sameSequence then
        sql = "UPDATE service_centres SET order_index = order_index + 1 WHERE order_index >= " & Request("order_index")
        call ExecuteQuery(sql)
    end if
end if

RecordSet.Fields("order_index") = Request("order_index")
RecordSet.Fields("publish") = Request("publish")
RecordSet.Fields("country_name") = Request("country_name")
RecordSet.Fields("country_name_bm") = Request("country_name_bm")
RecordSet.Fields("country_name_chi") = Request("country_name_chi")
RecordSet.Fields("modified_by") = Session("login")
RecordSet.Fields("modified") = Now()

RecordSet.Update

service_centre_id = RecordSet("service_centre_id")

if RecordSet.Fields("content_filename") <> "" then
    Dim xmlContent
    set xmlContent = getSC(RecordSet.Fields("content_filename"))
    xmlContent.selectSingleNode("service_centre/en/content").text = Request("content")
    xmlContent.selectSingleNode("service_centre/bm/content").text = Request("content_bm")
    xmlContent.selectSingleNode("service_centre/chi/content").text = Request("content_chi")
    call saveSCContent(xmlContent, RecordSet.Fields("content_filename"))
else
    Dim objXml, objPi, root, en, bm, chi
    Dim en_content, bm_content, chi_content
    set objXml = createArticle()
    ' Create Root '
    set root = objXml.createElement("service_centre")
    objXml.appendChild root
    ' Create language element '
    set en = objXml.createElement("en")
    set bm = objXml.createElement("bm")
    set chi = objXml.createElement("chi")
    root.appendChild en
    root.appendChild bm
    root.appendChild chi
    ' Create eng element '
    set en_content = objXml.createElement("content")
    en.appendChild en_content
    en_content.text = Request("content")
    ' Create bm element '
    set bm_content = objXml.createElement("content")
    bm.appendChild bm_content
    bm_content.text = Request("contentbm")
    ' Create chi element '
    set chi_content = objXml.createElement("content")
    chi.appendChild chi_content
    chi_content.text = Request("content_chi")
    
    set objPi = objXml.createProcessingInstruction("xml", "version='1.0'")
    objXml.insertBefore objPi, objXml.childNodes(0)
    
    call saveSCContent(objXml, service_centre_id & ".xml")
    RecordSet.Fields("content_filename") = service_centre_id & ".xml"
    RecordSet.Update
end if

RecordSet.Close

call CloseRecordSet(RecordSet)
call ReindexServiceCentres()

Response.Redirect("service_centre-edit.asp?action=edit&id=" & service_centre_id)
%>