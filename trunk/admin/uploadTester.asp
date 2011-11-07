<%@ Language=VBScript %>
<% 
option explicit 
Response.Expires = -1
Server.ScriptTimeout = 600
' All communication must be in UTF-8, including the response back from the request
Session.CodePage  = 65001
%>
<!-- #include file="freeaspupload.asp" -->
<%


  ' ****************************************************
  ' Change the value of the variable below to the pathname
  ' of a directory with write permissions, for example "C:\Inetpub\wwwroot"
  ' ****************************************************

  Dim uploadsDirVar
  uploadsDirVar = "C:\inetpub\scripts\fusionexcel\fusionexcel\trunk\images\" 
  

  ' Note: this file uploadTester.asp is just an example to demonstrate
  ' the capabilities of the freeASPUpload.asp class. There are no plans
  ' to add any new features to uploadTester.asp itself. Feel free to add
  ' your own code. If you are building a content management system, you
  ' may also want to consider this script: http://www.webfilebrowser.com/

function OutputForm()
%>
    <form name="frmSend" method="POST" enctype="multipart/form-data" accept-charset="utf-8" action="uploadTester.asp" onSubmit="return onSubmitForm();">
	<B>File names:</B><br>
    File 1: <input name="attach1" type="file" size=35><br>
    File 2: <input name="attach2" type="file" size=35><br>
    File 3: <input name="attach3" type="file" size=35><br>
    File 4: <input name="attach4" type="file" size=35><br>
    <br> 
	<!-- These input elements are obviously optional and just included here for demonstration purposes -->
	<B>Additional fields (demo):</B><br>
	Enter a number: <input type="text" name="enter_a_number"><br>
    Checkbox values: <input type="checkbox" value="1" name="checkbox_values"> 1 &nbsp;&nbsp;<input type="checkbox" value="2" name="checkbox_values"> 2<br>
    Drop-down list (with multiple selection): <br>	   
    <select name="list_values" class="TextBox" MULTIPLE>
        <option value='frist' > First</option>
        <option value='second' > Second</option>
        <option value='third' > Third</option>
    </select><br>
    <textarea rows="2" cols="20" name="t_area">Test text area</textarea><br>
	<!-- End of additional elements -->
    <input style="margin-top:4" type=submit value="Upload">
    </form>
<%
end function

function TestEnvironment()
    Dim fso, fileName, testFile, streamTest
    TestEnvironment = ""
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    if not fso.FolderExists(uploadsDirVar) then
        TestEnvironment = "<B>Folder " & uploadsDirVar & " does not exist.</B><br>The value of your uploadsDirVar is incorrect. Open uploadTester.asp in an editor and change the value of uploadsDirVar to the pathname of a directory with write permissions."
        exit function
    end if
    fileName = uploadsDirVar & "\test.txt"
    on error resume next
    Set testFile = fso.CreateTextFile(fileName, true)
    If Err.Number<>0 then
        TestEnvironment = "<B>Folder " & uploadsDirVar & " does not have write permissions.</B><br>The value of your uploadsDirVar is incorrect. Open uploadTester.asp in an editor and change the value of uploadsDirVar to the pathname of a directory with write permissions."
        exit function
    end if
    Err.Clear
    testFile.Close
    fso.DeleteFile(fileName)
    If Err.Number<>0 then
        TestEnvironment = "<B>Folder " & uploadsDirVar & " does not have delete permissions</B>, although it does have write permissions.<br>Change the permissions for IUSR_<I>computername</I> on this folder."
        exit function
    end if
    Err.Clear
    Set streamTest = Server.CreateObject("ADODB.Stream")
    If Err.Number<>0 then
        TestEnvironment = "<B>The ADODB object <I>Stream</I> is not available in your server.</B><br>Check the Requirements page for information about upgrading your ADODB libraries."
        exit function
    end if
    Set streamTest = Nothing
end function

function SaveFiles
    Dim Upload, fileName, fileSize, ks, i, fileKey

    Set Upload = New FreeASPUpload
    Upload.Save(uploadsDirVar)

	' If something fails inside the script, but the exception is handled
	If Err.Number<>0 then Exit function

    SaveFiles = ""
    ks = Upload.UploadedFiles.keys
    if (UBound(ks) <> -1) then
        SaveFiles = "<B>Files uploaded:</B> "
        for each fileKey in Upload.UploadedFiles.keys
            SaveFiles = SaveFiles & Upload.UploadedFiles(fileKey).FileName & " (" & Upload.UploadedFiles(fileKey).Length & "B) "
        next
    else
        SaveFiles = "No file selected for upload or the file name specified in the upload form does not correspond to a valid file in the system."
    end if
	SaveFiles = SaveFiles & "<br>Enter a number = " & Upload.Form("enter_a_number") & "<br>"
	SaveFiles = SaveFiles & "Checkbox values = " & Upload.Form("checkbox_values") & "<br>"
	SaveFiles = SaveFiles & "List values = " & Upload.Form("list_values") & "<br>"
	SaveFiles = SaveFiles & "Text area = " & Upload.Form("t_area") & "<br>"
end function
%>

<HTML>
<HEAD>
<TITLE>Test Free ASP Upload 2.0</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style>
BODY {background-color: white;font-family:arial; font-size:12}
</style>
<script>
function onSubmitForm() {
    var formDOMObj = document.frmSend;
    if (formDOMObj.attach1.value == "" && formDOMObj.attach2.value == "" && formDOMObj.attach3.value == "" && formDOMObj.attach4.value == "" )
        alert("Please press the Browse button and pick a file.")
    else
        return true;
    return false;
}
</script>

</HEAD>

<BODY>

<br><br>
<div style="border-bottom: #A91905 2px solid;font-size:16">Upload files to your server</div>
<%
Dim diagnostics
if Request.ServerVariables("REQUEST_METHOD") <> "POST" then
    diagnostics = TestEnvironment()
    if diagnostics<>"" then
        response.write "<div style=""margin-left:20; margin-top:30; margin-right:30; margin-bottom:30;"">"
        response.write diagnostics
        response.write "<p>After you correct this problem, reload the page."
        response.write "</div>"
    else
        response.write "<div style=""margin-left:150"">"
        OutputForm()
        response.write "</div>"
    end if
else
    response.write "<div style=""margin-left:150"">"
    OutputForm()
    response.write SaveFiles()
    response.write "<br><br></div>"
end if

%>

<!-- Please support this free script by having a link to freeaspupload.net either in this page or somewhere else in your site. -->
<div style="border-bottom: #A91905 2px solid;font-size:10">Powered by <A HREF="http://www.freeaspupload.net/" style="color:black">Free ASP Upload</A></div>

<br><br>

<!--- START OF HTML TO REMOVE - contains the script ratings submission -->

<table cellspacing=10>
<tr><td>
<table width="140" border="1" cellpadding="0" cellspacing="0" bordercolor="#840300" bgcolor="#D70500">
  <form action="http://www.hotscripts.com/cgi-bin/rate.cgi" method="POST">
    <tr> 
      <td><table width="100%" border="0" cellspacing="0" cellpadding="2" style="font-size:8pt">
          <tr align="center" bgcolor="#AA0400"> 
            <td colspan="2"><b><font color="#FFFFFF">Rate Our Program<br>at Hotscripts.com
              <input type="hidden" name="ID" value="21966">
              <input type="hidden" name="external2" value="1">
              </font></b></td>
          </tr>
          <tr> 
            <td align="right"><input type="radio" value="5" name="rate"></td>
            <td><font color="#FFFFFF">Excellent!</font></td>
          </tr>
          <tr> 
            <td align="right"><input type="radio" value="4" name="rate"></td>
            <td><font color="#FFFFFF">Very Good</font></td>
          </tr>
          <tr> 
            <td align="right"><input type="radio" value="3" name="rate"></td>
            <td><font color="#FFFFFF">Good</font></td>
          </tr>
          <tr> 
            <td align="right"><input type="radio" value="2" name="rate"></td>
            <td><font color="#FFFFFF">Fair</font></td>
          </tr>
          <tr> 
            <td align="right"><input type="radio" value="1" name="rate"></td>
            <td><font color="#FFFFFF">Poor</font></td>
          </tr>
          <tr align="center"> 
            <td colspan="2"><input name="submit2" type="submit" value="Cast My Vote!"></td>
          </tr>
        </table></td>
    </tr>
  </form>
</table>

<td valign=top>

<table border=0 cellpadding=1 cellspacing=0 bgcolor=000000>
<tr><td align=center>
	<table border=0 cellpadding=3 cellspacing=0 bgcolor=eeeedd>
	<tr><td align=center nowrap>
		<font style="font-size:10pt;font-family:Arial;"><b>Rated:</b> <a href="http://www.Aspin.com/func/review?id=5380510"><img src=http://ratings.Aspin.com/getstars?id=5380510 border=0></a>
		<font style="font-size:8pt;"><br>by <a href="http://www.Aspin.com">Aspin.com</a> users<br></font></font>
	</td></tr><tr nowrap><form action="http://www.Aspin.com/func/review/write?id=5380510" method=post><td align=center>
		<font style="font-size:10pt;font-family:Arial;">What do you think?</font><br>
		<select name="VoteStars"><option>5 Stars<option>4 Stars<option>3 Stars<option>2 Stars<option>1 Star</select><input type=submit value="Vote">
	</td></form></tr></table>
</td></tr></table>

<td valign=top style="font-size:10pt" width=300>

Please support this free script by rating it with the boxes on the left.<p>
To remove these boxes from this page please follow the instructions in the source HTML. The code to remove is clearly indicated and very easy to find.<p>
Thank you.
</table>
<!-- end of html to remove ------------------------->

</BODY>
</HTML>
