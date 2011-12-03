<%
option explicit
Response.Expires = -1
Response.CharSet = "utf-8"
Server.ScriptTimeout = 600
Session.CodePage = 65001

Dim uploadsDirVar
uploadsDirVar = Server.MapPath("/images/")

if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
    Response.Redirect "article-edit.asp?id=" & Request("id") & "&action=" & Request("action") & "&error=not_supported"
end if

Function SaveFiles
    Dim upload, fileName, fileSize, ks, i, fileKey, sameSequence, sameOrderYear
    set upload = new FreeAspUpload

    upload.save(uploadsDirVar)

    SaveFiles = ""
    ks = upload.uploadedFiles.keys
    if (UBount(ks) <> -1) then
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
%>