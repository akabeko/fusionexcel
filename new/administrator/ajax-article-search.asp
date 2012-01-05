<!--#include file="../libraries.asp" -->
<!--#include file="JSON_2.0.4.asp" -->
<%
Response.Buffer = false
Dim RecordSet, sql, search_query

if Request("search_query") <> "" and Len(Request("search_query")) > 4 then
    search_query = Request("search_query")
end if

if search_query <> "" then
    sql = "SELECT article_id, title, category_code FROM article WHERE title LIKE '%" & Replace(Request("search_query"), " ", "%") & "%'"
    sql = sql & " ORDER BY title"
else
    sql = "SELECT * FROM article WHERE article_id = null"
end if

call SetConnection(GetArticleDbPath())
call OpenDatabase()
call CreateRecordSet(RecordSet, sql)

Dim record_count
record_count = CInt(RecordSet.RecordCount)

if record_count < 0 then
    record_count = 0
end if

Dim arrData(1, 3)
Dim index
index = 0

Do While Not RecordSet.EOF
    arrData(index, 0) = RecordSet("article_id")
    arrData(index, 1) = RecordSet("title")
    arrData(index, 2) = RecordSet("category_code")
Loop
%>