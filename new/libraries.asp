<!--#include file="configuration.asp" -->
<!--#include file="data/dbController.asp" -->
<%

Function GetPath()
	GetPath = base_url
End Function

Function GetDataPath()
	GetDataPath = GetPath() & data_path
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

%>