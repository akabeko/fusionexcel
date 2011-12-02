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

'Misc function'
Function PadDigits(n, totalDigits)
	PadDigits = Right(String(totalDigits, "0") & n , totalDigits)
End Function


loadCategoryRef()
%>