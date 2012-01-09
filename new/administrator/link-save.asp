<%
option explicit
Response.Expires = -1
Response.CharSet = "utf-8"
Server.ScriptTimeout = 600
Session.CodePage = 65001
%>
<!--#include file="../libraries.asp" -->
<!--#include file="freeaspupload.asp" -->
<%

Dim sql, link_id, RecordSet, uploadsDirVar
uploadsDirVar = Server.MapPath("/images/link/")

if Session("login") = "" then
    Response.Redirect "login.asp"
end if

if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
    Response.Redirect "link-edit.asp?id=" & Request("id") & "&action=" & Request("action") & "&error=not_supported"
end if

link_id = 0

if Request("id") <> "" and IsNumeric(Request("id")) and CInt(Request("id")) > 0 then
    link_id = CInt(Request("id"))
end if

Call SetConnection(GetLinksDbPath())
Call OpenDatabase()

SaveFiles(link_id)

Function SaveFiles(link_id)
    Dim upload, fileName, fileSize, ks, i, fileKey, sameSequence
    set upload = new FreeAspUpload
    
    sameSequence = False
    
    upload.save(uploadsDirVar)
    
    SaveFiles = ""
    ks = upload.uploadedFiles.keys
    
    if (UBound(ks) <> -1) then
        for each fileKey in upload.uploadedFiles.keys
            SaveFiles = upload.uploadedFiles.keys
        next
    else
        SaveFiles = ""
    end if
    
    if upload.Form("submit") = "Add" then
        sql = "SELECT * FROM links"
        call CreateRecordSet(RecordSet, sql)
        RecordSet.AddNew
        RecordSet.Fields("created_by") = Session("login")
        RecordSet.Fields("created") = Now()
    else
        sql = "SELECT * FROM links WHERE link_id = " & link_id
        Call CreateRecordSet(RecordSet, sql)
    end if
    
    if SaveFiles <> "" then
        RecordSet.Fields("image_url") = "/images/link/" & SaveFiles
    end if
    
    if RecordSet.Fields("order_index") = CInt(upload.Form("order_index")) then
        sameSequence = True
    end if
    
    
    
    
    
    RecordSet.fields("publish") = upload.Form("publish")
    
    RecordSet.fields("article_name") = upload.Form("article_name")
    
    if upload.Form("article_id") = "" then
        RecordSet.fields("article_id") = 0
    else 
        RecordSet.fields("article_id") = upload.Form("article_id")
    end if
    
    if upload.Form("article_category_code") = "" then
        RecordSet.fields("article_category_code") = 0
    else
        RecordSet.fields("article_category_code") = upload.Form("article_category_code")
    end if
    
    RecordSet.fields("link_title") = upload.Form("link_title")
    RecordSet.fields("link_short_description") = upload.Form("link_short_description")
    RecordSet.fields("link_title_bm") = upload.Form("link_title_bm")
    RecordSet.fields("link_short_description_bm") = upload.Form("link_short_description_bm")
    RecordSet.fields("link_title_chi") = upload.Form("link_title_chi")
    RecordSet.fields("link_short_description_chi") = upload.Form("link_short_description_chi")
    
    RecordSet.Fields("external_url") = upload.Form("external_url")
    RecordSet.Fields("link_type") = upload.Form("link_type")
    
    RecordSet.Fields("modified_by") = Session("login")
    RecordSet.Fields("modified") = Now()
    
    if upload.Form("video_category_code") = "" then
        RecordSet.Fields("video_category_code") = 0
    else
        RecordSet.Fields("video_category_code") = upload.Form("video_category_code")
    end if
    
    RecordSet.fields("order_index") = upload.Form("order_index")
    
    RecordSet.UPDATE
    
    
    
    link_id = RecordSet("link_id")
    
    Dim OrderRecordSet
    sql = "SELECT COUNT(1) AS 'counter' FROM links WHERE order_index = " & upload.Form("order_index") & " AND NOT (link_id = " & link_id & ")"
    call CreateRecordSet(OrderRecordSet, sql)
    if OrderRecordSet.Fields("'counter'") > 0 then
        sql = "UPDATE links SET order_index = order_index + 1 WHERE order_index >= " & Upload.Form("order_index") & " AND NOT (link_id = " & link_id & ")"
        call ExecuteQuery(sql)	
	end if
    
    RecordSet.Close
    
    call CloseRecordSet(RecordSet)
    
    call ReindexLinksData(upload.Form("link_type"), upload.Form("video_category_code"))
    
    Response.Redirect("link-edit.asp?action=edit&id=" & link_id)
End Function

%>