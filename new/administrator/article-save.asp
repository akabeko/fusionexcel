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
uploadsDirVar = Server.MapPath("/images/article/index/")

if Session("login") = "" then
    Response.Redirect "login.asp"
end if

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
    
    'Alternate Title - 2/1/2012'
    RecordSet.Fields("alt_title") = Upload.Form("alt_title")
    RecordSet.Fields("alt_title_bm") = Upload.Form("alt_title_bm")
    RecordSet.Fields("alt_title_chi") = Upload.Form("alt_title_chi")
	
    RecordSet.Fields("title") = Upload.Form("title")
    RecordSet.Fields("title_bm") = Upload.Form("title_bm")
    RecordSet.Fields("title_chi") = Upload.Form("title_chi")
	RecordSet.Fields("modified_by") = Session("login")
    RecordSet.Fields("modified") = Now()
    
    RecordSet.Fields("sequence") = Upload.Form("sequence")
	RecordSet.Fields("order_year") = Upload.Form("order_year")    
    RecordSet.Fields("sequence_indexed") = Upload.Form("order_year") & "" & PadDigits(Upload.Form("sequence"), 4)
    
    Dim category_codes, category_code, code, content
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
        
        'Alternate Title - 2/1/2012'
        Dim alt_title_node, article_node
        if xmlContent.selectNodes("article/en/alt_title").length > 0 then
            xmlContent.selectSingleNode("article/en/alt_title").text = Upload.Form("alt_title")
        else
            set alt_title_node = xmlContent.createElement("alt_title")
            alt_title_node.text = Upload.Form("alt_title")
            set article_node = xmlContent.selectSingleNode("article/en")
            article_node.appendChild(alt_title_node)
        end if
        
        if xmlContent.selectNodes("article/bm/alt_title").length > 0 then
            xmlContent.selectSingleNode("article/bm/alt_title").text = Upload.Form("alt_title_bm")
        else
            set alt_title_node = xmlContent.createElement("alt_title")
            alt_title_node.text = Upload.Form("alt_title_bm")
            set article_node = xmlContent.selectSingleNode("article/bm")
            article_node.appendChild(alt_title_node)
        end if
        
        if xmlContent.selectNodes("article/chi/alt_title").length > 0 then
            xmlContent.selectSingleNode("article/chi/alt_title").text = Upload.Form("alt_title_chi")
        else
            set alt_title_node = xmlContent.createElement("alt_title")
            alt_title_node.text = Upload.Form("alt_title_chi")
            set article_node = xmlContent.selectSingleNode("article/chi")
            article_node.appendChild(alt_title_node)
        end if
        call saveArticleContent(xmlContent, RecordSet.Fields("content_filename"))
    else
        Dim fileStream, file, content_filename
        content_filename = article_id & ".xml"
        set fileStream = Server.CreateObject("Scripting.FileSystemObject")
        set file = fileStream.CreateTextFile(Server.MapPath(GetArticlePath(content_filename)), true)
        file.WriteLine "<?xml version='1.0' encoding='utf-8'?>"
        file.WriteLine "<article>"
        file.WriteLine "<en>"
        file.WriteLine "<title>"
        if Upload.Form("title") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("title"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</title>"
        file.WriteLine "<alt_title>"
        if Upload.Form("alt_title") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("alt_title"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</alt_title>"
        file.WriteLine "<content>"
        if Upload.Form("content") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("content"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</content>"
        file.WriteLine "<meta>"
        file.WriteLine "<description>"
        if Upload.Form("meta_description") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_description"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</description>"
        file.WriteLine "<keyword>"
        if Upload.Form("meta_keywords") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_keywords"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</keyword>"
        file.WriteLine "<author>"
        if Upload.Form("meta_author") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_author"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</author>"
        file.WriteLine "<robots>"
        if Upload.Form("meta_robots") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_robots"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</robots>"
        file.WriteLine "</meta>"
        file.WriteLine "</en>"
        file.WriteLine "<bm>"
        file.WriteLine "<title>"
        if Upload.Form("title_bm") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("title_bm"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</title>"
        file.WriteLine "<alt_title>"
        if Upload.Form("alt_title_bm") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("alt_title_bm"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</alt_title>"
        file.WriteLine "<content>"
        if Upload.Form("content_bm") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("content_bm"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</content>"
        file.WriteLine "<meta>"
        file.WriteLine "<description>"
        if Upload.Form("meta_description_bm") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_description_bm"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</description>"
        file.WriteLine "<keyword>"
        if Upload.Form("meta_keywords_bm") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_keywords_bm"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</keyword>"
        file.WriteLine "<author>"
        if Upload.Form("meta_author_bm") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_author_bm"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</author>"
        file.WriteLine "<robots>"
        if Upload.Form("meta_robots_bm") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_robots_bm"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</robots>"
        file.WriteLine "</meta>"
        file.WriteLine "</bm>"
        file.WriteLine "<chi>"
        file.WriteLine "<title>"
        if Upload.Form("title_chi") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("title_chi"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</title>"
        file.WriteLine "<alt_title>"
        if Upload.Form("alt_title_chi") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("alt_title_chi"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</alt_title>"
        file.WriteLine "<content>"
        if Upload.Form("content_chi") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("content_chi"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</content>"
        file.WriteLine "<meta>"
        file.WriteLine "<description>"
        if Upload.Form("meta_description_chi") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_description_chi"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</description>"
        file.WriteLine "<keyword>"
        if Upload.Form("meta_keywords_chi") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_keywords_chi"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</keyword>"
        file.WriteLine "<author>"
        if Upload.Form("meta_author_chi") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_author_chi"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</author>"
        file.WriteLine "<robots>"
        if Upload.Form("meta_robots_chi") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(Upload.Form("meta_robots_chi"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</robots>"
        file.WriteLine "</meta>"
        file.WriteLine "</chi>"
        file.WriteLine "</article>"
        RecordSet.Fields("content_filename") = content_filename
        RecordSet.Update
    end if
    
    RecordSet.close
    
    call CloseRecordSet(RecordSet)
    
    Dim OrderRecordSet
    sql = "SELECT COUNT(1) AS 'counter' FROM article WHERE order_year = " & upload.Form("order_year") & " AND sequence = " & upload.Form("sequence") & " AND NOT (article_id = " & article_id & ")"
    call CreateRecordSet(OrderRecordSet, sql)
    if OrderRecordSet.Fields("'counter'") > 0 then
        If Upload.Form("submit") = "Add" then
            sql = "UPDATE article SET sequence = sequence + 1, sequence_indexed = Val(format(order_year) + '' + format(sequence + 1, '0000')) WHERE order_year = " & upload.form("order_year") & " AND NOT (article_id = " & article_id & ")"
        else
			if not sameSequence or not sameOrderYear then
				sql = "UPDATE article SET sequence = sequence + 1, sequence_indexed = Val(format(order_year) + '' + format(sequence + 1, '0000')) WHERE order_year = " & Upload.Form("order_year") & " AND sequence >= " & Upload.Form("sequence") & " AND NOT (article_id = " & article_id & ")"
				call ExecuteQuery(sql)
			end if
		end if		
	end if
    Call CloseRecordSet(OrderRecordSet)
    
    Dim categories, index
    categories = getCategoriesList()
    For index = 0 to UBound(categories, 2)
        if categories(1, index) <> "" then
            call ReindexData(categories(0, index))
        end if
    Next
    
    Response.Redirect("article-edit.asp?action=edit&success=1&id=" & article_id)
End Function
%>