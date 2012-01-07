<!--#include file="configuration.asp" -->
<!--#include file="sidebar.asp" -->
<!--#include file="header_image.asp" -->
<!--#include file="data/dbController.asp" -->
<%

' Get Base Path '
Function GetPath()
	GetPath = base_url
End Function

' Get folder path where the data store at '
Function GetDataPath()
	GetDataPath = GetPath() & data_path
End Function

Function GetFrontendCSSPath()
    GetFrontendCSSPath = GetPath() & frontend_css_folder_path
End Function

Function GetCKFinderPath()
    GetCKFinderPath = GetPath() &  ckfinder_folder_path
End Function

' Get category references xml file url '
Function GetCategoryRefPath()
	GetCategoryRefPath = GetDataPath() & category_ref_xml
End Function

' Get main database file url '
Function GetMainDbPath()
	GetMainDbPath = GetDataPath() & main_db
End Function

' Get references database path '
Function GetReferenceDbPath()
	GetReferenceDbPath = GetDataPath() & reference_db
End Function

' Get users database file url '
Function GetUserDbPath()
	GetUserDbPath = GetDataPath() & user_db
End Function

' Get articles database file path '
Function GetArticleDbPath()
	GetArticleDbPath = GetDataPath() & article_db
End Function

Function GetArticlePath(path)
	GetArticlePath = GetDataPath() & article_path & path
End Function

Function GetIndexedArticlesPath()
    GetIndexedArticlesPath = GetDataPath() & article_indexed_xml
End Function

Function GetSCDbPath()
    GetSCDbPath = GetDataPath() & service_centre_db
End Function

Function GetSCPath(path)
    GetSCPath = GetDataPath() & service_centres_path & path
End Function

Function GetIndexedSCsPath()
    GetIndexedSCsPath = GetDataPath() & service_centres_indexed_xml
End Function

Function GetLinksDbPath()
    GetLinksDbPath = GetDataPath() & links_db
End Function

Function GetLinkPath(path)
    GetLinkPath = GetDataPath() & links_path & path
End Function

Function GetIndexedLinksPath()
    GetIndexedLinksPath = GetDataPath() & links_indexed_xml
End Function

' Get indexed folder path, with parameters of the indexed file name '
' Filename pattern = category_id + xml extension '
Function GetIndexedPath(filename)
    GetIndexedPath = GetDataPath() & indexed_path & filename
End Function

'Get references data'

Dim categoryRef

Function loadCategoryRef()
	Dim objXML, root
	SetXMLPath(GetCategoryRefPath())
	set objXML = OpenXML()
	set root = objXML.selectNodes("/categories/category")
	set categoryRef = root
End Function

Function getCategoriesNameById(intID)
	Dim categoryName, item
	categoryName = ""
	if categoryRef.length > 0 then
		for each item in categoryRef
			if ((( CInt(intID) \ CInt(item.childNodes(0).text)) mod 2) > 0) then
				categoryName = categoryName & "<p>" & item.childNodes(1).text & "</p>"
			end if
		next
	end if
	getCategoriesNameById = categoryName
End Function

Function getCategoriesList()
	Dim categories
	if categoryRef.length > 0 then
		Redim categories(2, categoryRef.length)
		Dim index, item
		index = 0
		for each item in categoryRef
			categories(0, index) = item.childNodes(0).text
			categories(1, index) = item.childNodes(1).text
			index = index + 1
		next
	end if
	getCategoriesList = categories
End Function

Function getLatestArticleSequence()
    Dim sql, RecordSet
    sql = "SELECT MAX(sequence) + 1 AS next_sequence FROM article WHERE order_year = YEAR(now())"
    call SetConnection(GetArticleDbPath())
    call OpenDatabase()
    call CreateRecordSet(RecordSet, sql)
    if not RecordSet.EOF then
        getLatestArticleSequence = RecordSet.Fields("next_sequence")
    else
        getLatestArticleSequence = 1
    end if
End Function

Function getArticleContent(path)
	Dim objXML, root
	SetXMLPath(GetArticlePath(path))
	set objxml = OpenXML()
	set root = objXML.selectNodes("article")
	set getArticleContent = root
End Function

Function getArticle(path)
    SetXMLPath(GetArticlePath(path))
    set getArticle = OpenXML()
End Function

Function saveArticleContent(xmlContent, filename)
    call SaveXML(xmlContent, GetArticlePath(filename))
End Function

Function createArticle()
    set createArticle = CreateXML()
End Function

'Misc function'
Function PadDigits(n, totalDigits)
	PadDigits = Right(String(totalDigits, "0") & n , totalDigits)
End Function

'Indexed Function'

' Function to generate indexed files '
' @param'
' category_code: to generate related category in to the indexed file '

Function ReindexData(category_code)
    Dim sql, RecordSet, fileStream, file
    set fileStream = Server.CreateObject("Scripting.FileSystemObject")
    set file = fileStream.CreateTextFile(Server.MapPath(GetIndexedPath(category_code & ".xml")), true)
    file.WriteLine "<?xml version='1.0' encoding='utf-8'?>"
    file.WriteLine "<articles>"
    sql = "SELECT article_id, title, title_bm, title_chi, index_image_url, publish, publish_start_date, sequence, order_year, sequence_indexed, category_code, content_filename FROM article"
    sql = sql & " WHERE (((category_code \ " & category_code & ") mod 2) = 1)"
    sql = sql & " AND (publish = true or not publish_start_date is null) ORDER BY sequence_indexed DESC"
    call SetConnection(GetArticleDbPath())
    call OpenDatabase()
    call CreateRecordSet(RecordSet, sql)
    Do While not RecordSet.EOF
        file.WriteLine "<article id='" & RecordSet.Fields("article_id") &"'>"
        file.WriteLine "<article_id>" & RecordSet.Fields("article_id") & "</article_id>"
        file.WriteLine "<title lang='en'>"
        if RecordSet.Fields("title") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(RecordSet.Fields("title"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</title>"
        file.WriteLine "<title lang='bm'>"
        if RecordSet.Fields("title_bm") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(RecordSet.Fields("title_bm"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</title>"
        file.WriteLine "<title lang='chi'>"
        if RecordSet.Fields("title_chi") <> "" then
            file.WriteLine "<![CDATA["
            file.WriteLine Server.HTMLEncode(RecordSet.Fields("title_chi"))
            file.WriteLine "]]>"
        end if
        file.WriteLine "</title>"
        file.WriteLine "<index_image_url>" & RecordSet.Fields("index_image_url") & "</index_image_url>"
        file.WriteLine "<publish>" & RecordSet.Fields("publish") & "</publish>"
        file.WriteLine "<publish_start_date>" & RecordSet.Fields("publish_start_date") & "</publish_start_date>"
        file.WriteLine "<sequence>" & RecordSet.Fields("sequence") & "</sequence>"
        file.WriteLine "<order_year>" & RecordSet.Fields("order_year") & "</order_year>"
        file.WriteLine "<sequence_indexed>" & RecordSet.Fields("sequence_indexed") & "</sequence_indexed>"
        file.WriteLine "<category_code>" & RecordSet.Fields("category_code") & "</category_code>"
        file.WriteLine "<content_filename>" & RecordSet.Fields("content_filename") & "</content_filename>"
        file.WriteLine "</article>"
		RecordSet.MoveNext 
    Loop
    file.WriteLine "</articles>"
End Function

Function ReindexArticles()
    Dim sql, RecordSet, fileStream, file
    ' Category - post counter '
    Dim id_1_post_counter, id_2_post_counter, id_4_post_counter, id_8_post_counter, id_16_post_counter
    id_1_post_counter = 0
    id_2_post_counter = 0
    id_4_post_counter = 0
    set fileStream = Server.CreateObject("Scripting.FileSystemObject")
    set file = fileStream.CreateTextFile(Server.MapPath(GetIndexedArticlesPath()), true)
    file.WriteLine "<?xml version='1.0' encoding='utf-8'?>"
    file.WriteLine "<articles>"
    sql = "SELECT article_id, title, title_bm, title_chi, index_image_url, publish, publish_start_date, sequence, order_year, sequence_indexed, category_code, content_filename FROM article WHERE publish = true or not publish_start_date is null ORDER BY sequence_indexed DESC"
    call SetConnection(GetArticleDbPath())
    call OpenDatabase()
    call CreateRecordSet(RecordSet, sql)
    Do While not RecordSet.EOF
        file.WriteLine "<article id='" & RecordSet.Fields("article_id") &"'>"
        file.WriteLine "<article_id>" & RecordSet.Fields("article_id") & "</article_id>"
        file.WriteLine "<title lang='en'>" & Server.HTMLEncode(RecordSet.Fields("title")) & "</title>"
        file.WriteLine "<title lang='bm'>" & Server.HTMLEncode(RecordSet.Fields("title_bm")) & "</title>"
        file.WriteLine "<title lang='chi'>" & Server.HTMLEncode(RecordSet.Fields("title_chi")) & "</title>"
        file.WriteLine "<index_image_url>" & RecordSet.Fields("index_image_url") & "</index_image_url>"
        file.WriteLine "<publish>" & RecordSet.Fields("publish") & "</publish>"
        file.WriteLine "<publish_start_date>" & RecordSet.Fields("publish_start_date") & "</publish_start_date>"
        file.WriteLine "<sequence>" & RecordSet.Fields("sequence") & "</sequence>"
        file.WriteLine "<order_year>" & RecordSet.Fields("order_year") & "</order_year>"
        file.WriteLine "<sequence_indexed>" & RecordSet.Fields("sequence_indexed") & "</sequence_indexed>"
        file.WriteLine "<category_code>" & RecordSet.Fields("category_code") & "</category_code>"
        file.WriteLine "<content_filename>" & RecordSet.Fields("content_filename") & "</content_filename>"
        file.WriteLine "</article>"
        if (((RecordSet.Fields("category_code") \ 1) mod 2) = 1) then
            id_1_post_counter = id_1_post_counter + 1
        end if
        if (((RecordSet.Fields("category_code") \ 2) mod 2) = 1) then
            id_2_post_counter = id_2_post_counter + 1
        end if
        if (((RecordSet.Fields("category_code") \ 4) mod 2) = 1) then
            id_4_post_counter = id_4_post_counter + 1
        end if
		RecordSet.MoveNext 
    Loop
    file.WriteLine "<counter>"
    file.WriteLine "<category_code_1>" & id_1_post_counter & "</category_code_1>"
    file.WriteLine "<category_code_2>" & id_2_post_counter & "</category_code_2>"
    file.WriteLine "<category_code_4>" & id_4_post_counter & "</category_code_4>"
    file.WriteLine "<category_code_8>" & id_8_post_counter & "</category_code_8>"
    file.WriteLine "<category_code_16>" & id_16_post_counter & "</category_code_16>"
    file.WriteLine "</counter>"
    file.WriteLine "</articles>"
End Function

Function GetIndexedArticles(category_code)
    Dim objXML
    SetXMLPath(GetIndexedPath(category_code & ".xml"))
    set objXML = OpenXML()
    set GetIndexedArticles = objXML
End Function

Function getSCContent(path)
	Dim objXML, root
	SetXMLPath(GetSCPath(path))
	set objxml = OpenXML()
	set root = objXML.selectNodes("service_centre")
	set getSCContent = root
End Function

Function getSC(path)
    SetXMLPath(GetSCPath(path))
    set getSC = OpenXML()
End Function

Function getLatestSCSequence()
    Dim sql, RecordSet
    sql = "SELECT MAX(order_index) + 1 AS next_sequence FROM service_centres"
    call SetConnection(GetSCDbPath())
    call OpenDatabase()
    call CreateRecordSet(RecordSet, sql)
    if not RecordSet.EOF then
        getLatestSCSequence = RecordSet.Fields("next_sequence")
    else
        getLatestSCSequence = 1
    end if
End Function

Function saveSCContent(xmlContent, filename)
    call SaveXML(xmlContent, GetSCPath(filename))
End Function

Function ReindexServiceCentres()
    Dim sql, RecordSet, fileStream, file
    set fileStream = Server.CreateObject("Scripting.FileSystemObject")
    set file = fileStream.CreateTextFile(Server.MapPath(GetIndexedPath("service_centres.xml")), true)
    file.WriteLine "<?xml version='1.0' encoding='utf-8'?>"
    file.WriteLine "<service_centres>"
    sql = "SELECT service_centre_id, country_name, country_name_bm, country_name_chi, content_filename, is_main FROM service_centres WHERE publish = true ORDER BY order_index"
    call SetConnection(GetSCDbPath())
    call OpenDatabase()
    call CreateRecordSet(RecordSet, sql)
    Do While not RecordSet.EOF
        file.WriteLine "<service_centre id='" & RecordSet.Fields("service_centre_id") &"'>"
        file.WriteLine "<service_centre_id>" & RecordSet.Fields("service_centre_id") & "</service_centre_id>"
        file.WriteLine "<country_name lang='en'>"
        if RecordSet.Fields("country_name") <> "" then
            file.WriteLine Server.HTMLEncode(RecordSet.Fields("country_name"))
        end if
        file.WriteLine "</country_name>"
        file.WriteLine "<country_name lang='bm'>"
        if RecordSet.Fields("country_name_bm") <> "" then
            file.WriteLine Server.HTMLEncode(RecordSet.Fields("country_name_bm"))
        end if
        file.WriteLine "</country_name>"
        file.WriteLine "<country_name lang='chi'>"
        if RecordSet.Fields("country_name_chi") <> "" then
            file.WriteLine Server.HTMLEncode(RecordSet.Fields("country_name_chi"))
        end if
        file.WriteLine "</country_name>"
        file.WriteLine "<is_main>" & RecordSet.Fields("is_main") & "</is_main>"
        file.WriteLine "<content_filename>" & RecordSet.Fields("content_filename") & "</content_filename>"
        file.WriteLine "</service_centre>"
		RecordSet.MoveNext 
    Loop
    file.WriteLine "</service_centres>"
End Function

Function ReindexLinks()
    'TODO: Reindex Links Data'
End Function

Function getLatestLinksSequence()

End Function

loadCategoryRef()
%>