<!--#include file="../libraries.asp" -->
<%
Response.Buffer = false
Dim RecordSet, sql, search_query

if Request("search_query") <> "" and Len(Request("search_query")) > 4 then
    search_query = Request("search_query")
end if

if search_query <> "" then
    sql = "SELECT article_id, title, category_code FROM article WHERE title LIKE '%" & Replace(Request("search_query"), " ", "%") & "%'"
    sql = sql & " ORDER BY title"
    Response.Write sql
    Response.End
else
    sql = "SELECT * FROM article WHERE article_id = null"
end if

call SetConnection(GetArticleDbPath())
call OpenDatabase()
call CreateRecordSet(RecordSet, sql)

Response.Write "<?xml version='1.0' encoding='utf-8'?>"
Response.Write "<articles>"
Do While not RecordSet.EOF
    Response.Write "<article>"
    Response.Write "<article_id>" & RecordSet("article_id") & "</article_id>"
    Response.Write "<title>"
    if RecordSet("title") <> "" then
        Response.Write RecordSet("title")
    end if
    Response.Write "</title>"
    Response.Write "<category_code>" & RecordSet("category_code") & "</category_code>"
    Response.Write "</article>"
Loop
Response.Write "</articles>"
%>