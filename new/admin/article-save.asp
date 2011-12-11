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
        RecordSet.Fields("created_by") = Session("login")
        RecordSet.Fields("created") = Now()
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
	
    RecordSet.Fields("title") = Upload.Form("title")
    RecordSet.Fields("title_bm") = Upload.Form("title_bm")
    RecordSet.Fields("title_chi") = Upload.Form("title_chi")
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
    
    RecordSet.Update
    
    article_id = RecordSet("article_id")
    
    if RecordSet.Fields("content_filename") <> "" then
        Dim xmlContent
        set xmlContent = getArticle(RecordSet.Fields("content_filename"))
        xmlContent.selectSingleNode("article/en/title").text = Upload.Form("title")
        xmlContent.selectSingleNode("article/en/content").text = Upload.Form("content")
        xmlContent.selectSingleNode("article/en/meta/description").text = Upload.Form("meta_description")
        xmlContent.selectSingleNode("article/en/meta/keyword").text = Upload.Form("meta_keywords")
        xmlContent.selectSingleNode("article/en/meta/author").text = Upload.Form("meta_author")
        xmlContent.selectSingleNode("article/en/meta/robots").text = Upload.Form("meta_robots")
        
        xmlContent.selectSingleNode("article/bm/title").text = Upload.Form("title_bm")
        xmlContent.selectSingleNode("article/bm/content").text = Upload.Form("content_bm")
        xmlContent.selectSingleNode("article/bm/meta/description").text = Upload.Form("meta_description_bm")
        xmlContent.selectSingleNode("article/bm/meta/keyword").text = Upload.Form("meta_keywords_bm")
        xmlContent.selectSingleNode("article/bm/meta/author").text = Upload.Form("meta_author_bm")
        xmlContent.selectSingleNode("article/bm/meta/robots").text = Upload.Form("meta_robots_bm")
        
        xmlContent.selectSingleNode("article/chi/title").text = Upload.Form("title_chi")
        xmlContent.selectSingleNode("article/chi/content").text = Upload.Form("content_chi")
        xmlContent.selectSingleNode("article/chi/meta/description").text = Upload.Form("meta_description_chi")
        xmlContent.selectSingleNode("article/chi/meta/keyword").text = Upload.Form("meta_keywords_chi")
        xmlContent.selectSingleNode("article/chi/meta/author").text = Upload.Form("meta_author_chi")
        xmlContent.selectSingleNode("article/chi/meta/robots").text = Upload.Form("meta_robots_chi")
        call saveArticleContent(xmlContent, RecordSet.Fields("content_filename"))
    else
        Dim fileStream, file, content_filename
        content = article_id & ".xml"
        set fileStream = Server.CreateObject("Scripting.FileSystemObject")
        set file = fileStream.CreateTextFile(Server.MapPath(GetArticlePath(content_filename)), true)
        file.WriteLine "<?xml version='1.0' encoding='utf-8'?>"
        file.WriteLine "<article>"
        file.WriteLine "<en>"
        file.WriteLine "<title>" & Upload.Form("title") & "</title>"
        file.WriteLine "<content>" & Upload.Form("content") & "</content>"
        file.WriteLine "<meta>"
        file.WriteLine "<description>" & Upload.Form("meta_description") & "</description>"
        file.WriteLine "<keyword>" & Upload.Form("meta_keywords") & "</keyword>"
        file.WriteLine "<author>" & Upload.Form("meta_author") & "</author>"
        file.WriteLine "<robots>" & Upload.Form("meta_robots") & "</robots>"
        file.WriteLine "</meta>"
        file.WriteLine "</en>"
        file.WriteLine "<bm>"
        file.WriteLine "<title>" & Upload.Form("title_bm") & "</title>"
        file.WriteLine "<content>" & Upload.Form("content_bm") & "</content>"
        file.WriteLine "<meta>"
        file.WriteLine "<description>" & Upload.Form("meta_description_bm") & "</description>"
        file.WriteLine "<keyword>" & Upload.Form("meta_keywords_bm") & "</keyword>"
        file.WriteLine "<author>" & Upload.Form("meta_author_bm") & "</author>"
        file.WriteLine "<robots>" & Upload.Form("meta_robots_bm") & "</robots>"
        file.WriteLine "</meta>"
        file.WriteLine "</bm>"
        file.WriteLine "<chi>"
        file.WriteLine "<title>" & Upload.Form("title_chi") & "</title>"
        file.WriteLine "<content>" & Upload.Form("content_chi") & "</content>"
        file.WriteLine "<meta>"
        file.WriteLine "<description>" & Upload.Form("meta_description_chi") & "</description>"
        file.WriteLine "<keyword>" & Upload.Form("meta_keywords_chi") & "</keyword>"
        file.WriteLine "<author>" & Upload.Form("meta_author_chi") & "</author>"
        file.WriteLine "<robots>" & Upload.Form("meta_robots_chi") & "</robots>"
        file.WriteLine "</meta>"
        file.WriteLine "</chi>"
        file.WriteLine "</article>"
        RecordSet.Fields("content_filename") = content_filename
        RecordSet.Update
    end if
    
    RecordSet.close
    
    call CloseRecordSet(RecordSet)
    
    Dim categories, index
    categories = getCategoriesList()
    For index = 0 to UBound(categories, 2)
        if categories(1, index) <> "" then
            call ReindexData(categories(0, index))
        end if
    Next
    
    Response.Redirect("article-edit.asp?action=edit&id=" & article_id)
End Function
%>