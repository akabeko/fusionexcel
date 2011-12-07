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
	
    RecordSet.Fields("title") = Upload.Form("title")
    RecordSet.Fields("title_bm") = Upload.Form("title_bm")
    RecordSet.Fields("title_chi") = Upload.Form("title_chi")
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
    
    RecordSet.Update
    
    article_id = RecordSet("article_id")
    
    if RecordSet.Fields("content_filename") <> "" then
        Dim xmlContent, node
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
        Dim objXML, objPi, root, en, bm, chi, meta_en, meta_bm, meta_chi
        Dim en_title, en_content, en_meta_desc, en_meta_keyword, en_meta_robots, en_meta_author
        Dim bm_title, bm_content, bm_meta_desc, bm_meta_keyword, bm_meta_robots, bm_meta_author
        Dim chi_title, chi_content, chi_meta_desc, chi_meta_keyword, chi_meta_robots, chi_meta_author
        set objXML = createArticle()
        ' Create Root'
        set root = objXML.createElement("article")
        objXML.appendChild root
        ' Create language element '
        set en = objXML.createElement("en")
        set bm = objXML.createElement("bm")
        set chi = objXML.createElement("chi")
        root.appendChild en
        root.appendChild bm
        root.appendChild chi
        ' Create eng element '
        set en_title = objXML.createElement("title")
        set en_content = objXML.createElement("content")
        set meta_en = objXML.createElement("meta")
        en.appendChild en_title
        en.appendChild en_content
        en.appendChild meta_en
        en_title.text = Upload.Form("title")
        en_content.text = Upload.Form("content")
        ' Create meta element'
        set en_meta_desc = objXML.createElement("description")
        set en_meta_keyword = objXML.createElement("keyword")
        set en_meta_robots = objXML.createElement("author")
        set en_meta_author = objXML.createElement("robots")
        en_meta_desc.text = Upload.Form("meta_description")
        en_meta_keyword.text = Upload.Form("meta_keywords")
        en_meta_robots.text = Upload.Form("meta_robots")
        en_meta_author.text = Upload.Form("meta_author")
        meta_en.appendChild en_meta_desc
        meta_en.appendChild en_meta_keyword
        meta_en.appendChild en_meta_robots
        meta_en.appendChild en_meta_author
        
        ' Create bm element '
        set bm_title = objXML.createElement("title")
        set bm_content = objXML.createElement("content")
        set meta_bm = objXML.createElement("meta")
        bm.appendChild bm_title
        bm.appendChild bm_content
        bm.appendChild meta_bm
        bm_title.text = Upload.Form("title_bm")
        bm_content.text = Upload.Form("content_bm")
        ' Create meta element'
        set bm_meta_desc = objXML.createElement("description")
        set bm_meta_keyword = objXML.createElement("keyword")
        set bm_meta_robots = objXML.createElement("author")
        set bm_meta_author = objXML.createElement("robots")
        bm_meta_desc.text = Upload.Form("meta_description_bm")
        bm_meta_keyword.text = Upload.Form("meta_keywords_bm")
        bm_meta_robots.text = Upload.Form("meta_robots_bm")
        bm_meta_author.text = Upload.Form("meta_author_bm")
        meta_bm.appendChild bm_meta_desc
        meta_bm.appendChild bm_meta_keyword
        meta_bm.appendChild bm_meta_robots
        meta_bm.appendChild bm_meta_author
        
        ' Create chi element '
        set chi_title = objXML.createElement("title")
        set chi_content = objXML.createElement("content")
        set meta_chi = objXML.createElement("meta")
        chi.appendChild chi_title
        chi.appendChild chi_content
        chi.appendChild meta_chi
        chi_title.text = Upload.Form("title_chi")
        chi_content.text = Upload.Form("content_chi")
        ' Create meta element'
        set chi_meta_desc = objXML.createElement("description")
        set chi_meta_keyword = objXML.createElement("keyword")
        set chi_meta_robots = objXML.createElement("author")
        set chi_meta_author = objXML.createElement("robots")
        chi_meta_desc.text = Upload.Form("meta_description_chi")
        chi_meta_keyword.text = Upload.Form("meta_keywords_chi")
        chi_meta_robots.text = Upload.Form("meta_robots_chi")
        chi_meta_author.text = Upload.Form("meta_author_chi")
        meta_chi.appendChild chi_meta_desc
        meta_chi.appendChild chi_meta_keyword
        meta_chi.appendChild chi_meta_robots
        meta_chi.appendChild chi_meta_author
        
        set objPi = objXML.createProcessingInstruction("xml", "version='1.0'")
        
        objXML.insertBefore objPi, objXML.childNodes(0)
        
        call saveArticleContent(objXML, article_id & ".xml")
        RecordSet.Fields("content_filename") = article_id & ".xml"
        RecordSet.Update
    end if
    
    RecordSet.close
    
    call CloseRecordSet(RecordSet)
    
    Response.Redirect("article-edit.asp?action=edit&id=" & article_id)
End Function
%>