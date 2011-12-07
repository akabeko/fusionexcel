<!--#include file="configuration.asp" -->
<!--#include file="data/dbController.asp" -->
<%

Function GetPath()
	GetPath = base_url
End Function

Function GetDataPath()
	GetDataPath = GetPath() & data_path
End Function

Function GetCategoryRefPath()
	GetCategoryRefPath = GetDataPath() & category_ref_xml
End Function

Function GetMainDbPath()
	GetMainDbPath = GetDataPath() & main_db
End Function

Function GetReferenceDbPath()
	GetReferenceDbPath = GetDataPath() & reference_db
End Function

Function GetUserDbPath()
	GetUserDbPath = GetDataPath() & user_db
End Function

Function GetArticleDbPath()
	GetArticleDbPath = GetDataPath() & article_db
End Function

Function GetArticlePath(path)
	GetArticlePath = GetDataPath() & article_path & path
End Function

Function GetIndexedArticlesPath()
    GetIndexedArticlesPath = GetDataPath() & article_indexed_xml
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
        getLatestArticleSequence = 0
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

Function ReindexArticles()
    Dim sql, RecordSet, fileStream, file
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
        file.WriteLine "<title lang='en'>" & RecordSet.Fields("title") & "</title>"
        file.WriteLine "<title lang='bm'>" & RecordSet.Fields("title_bm") & "</title>"
        file.WriteLine "<title lang='chi'>" & RecordSet.Fields("title_chi") & "</title>"
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

Function GetIndexedArticles()
    Dim objXML
    SetXMLPath(GetIndexedArticlesPath())
    set objXML = OpenXML()
    set GetIndexedArticles = objXML
End Function


loadCategoryRef()
%>