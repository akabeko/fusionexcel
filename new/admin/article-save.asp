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

Dim sql, article_id, RecordSet, uploadsDirVar
uploadsDirVar = Server.MapPath("/images/")

if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
    Response.Redirect "article-edit.asp?id=" & Request("id") & "&action=" & Request("action") & "&error=not_supported"
end if

article_id = 0

if Request("id") <> "" and IsNumeric(Request("id")) and CInt(Request("id")) > 0 then
    article_id = CInt(Request("id"))
end if

Call SetConnection(GetArticleDbPath())
Call OpenDatabase()

SaveFiles(article_id)

Function SaveFiles(article_id)
    Dim upload, fileName, fileSize, ks, i, fileKey, sameSequence, sameOrderYear
    set upload = new FreeAspUpload
    
    sameSequence = False
    sameOrderYear = False

    upload.save(uploadsDirVar)

    SaveFiles = ""
    ks = upload.uploadedFiles.keys
    if (UBound(ks) <> -1) then
        for each fileKey in upload.uploadedFiles.keys
            SaveFiles = upload.uploadedFiles.Keys
        next
    else
        SaveFiles = ""
    end if
    
    if upload.Form("submit") = "Add" then
        sql = "SELECT * FROM article"
        call CreateRecordSet(RecordSet, sql)
        RecordSet.AddNew
	else
		sql = "SELECT * FROM article WHERE article_id = " & article_id
		Call CreateRecordSet(RecordSet, sql)
	end if
	
    
    ' Saving image is submitted '
	if SaveFiles <> "" then
		RecordSet.Fields("index_image_url") = "/images/article/index/" & SaveFiles
	end if

    if RecordSet.Fields("sequence") = CInt(upload.Form("sequence")) then
        sameSequence = True
    end if
    
    if RecordSet.Fields("order_year") = CInt(upload.form("order_year")) then
        sameOrderYear = True
    end if
    
    RecordSet.Fields("publish") = upload.Form("publish")
    if not Upload.Form("publish_start_date") = "" then
        RecordSet.Fields("publish_start_date") = upload.Form("publish_start_date")
    end if
	
	RecordSet.Fields("created_by") = Session("login")
	RecordSet.Fields("modified_by") = Session("login")
    RecordSet.Fields("modified") = Now()
    
    Dim OrderRecordSet
    sql = "SELECT COUNT(1) AS 'counter' FROM article WHERE order_year = " & upload.Form("order_year") & " AND sequence = " & upload.Form("sequence")
    call CreateRecordSet(OrderRecordSet, sql)
    if OrderRecordSet.Fields("'counter'") > 0 then
        If Upload.Form("submit") = "Add" then
            sql = "UPDATE article SET sequence = sequence + 1, sequence_indexed = Val(format(order_year) + '' + format(sequence + 1, '0000')) WHERE order_year = " & upload.form("order_year")
        else
			if not sameSequence or not sameOrderYear then
				sql = "UPDATE article SET sequence = sequence + 1, sequence_indexed = Val(format(order_year) + '' + format(sequence + 1, '0000')) WHERE order_year = " & Upload.Form("order_year") & " AND sequence >= " & Upload.Form("sequence")
				call ExecuteQuery(sql)
			end if
		end if		
	end if
    
    RecordSet.Fields("sequence") = Upload.Form("sequence")
	RecordSet.Fields("order_year") = Upload.Form("order_year")    
    RecordSet.Fields("sequence_indexed") = Upload.Form("order_year") & "" & PadDigits(Upload.Form("sequence"), 4)
    
    Dim category_codes, category_code, code
	category_codes = Split(Upload.Form("category_code"), ",")
	
	for each code in category_codes
		category_code = category_code + CInt(code)
	next
    
    RecordSet.Fields("category_code") = category_code
    
    if RecordSet.Fields("content_filename") <> "" then
        Dim xmlContent, node
        set xmlContent = getArticleContent(RecordSet.Fields("content_filename"))
        xmlContent.item(0).selectSingleNode("en/title").text = Upload.Form("title")
        xmlContent.Save()
    else
    
    end if
    
    RecordSet.Update
    article_id = RecordSet("article_id")
    RecordSet.close
    
    call CloseRecordSet(RecordSet)
    
    Response.Redirect("article-edit.asp?action=edit&id=" & article_id)
End Function
%>