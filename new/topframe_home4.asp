<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%

GMTDateTime = Now()
GMT = year(GMTDateTime) & ", "&month(GMTDateTime) &", "&day(GMTDateTime)&", "&hour(GMTDateTime)&", "&Minute(GMTDateTime)&", " & second(GMTDateTime)
'response.write GMT
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" >
<title>Untitled Document</title>
<link href="fe.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
a:link {
	text-decoration: none;
}
a:visited {
	text-decoration: none;
}
a:hover {
	text-decoration: none;
}
a:active {
	text-decoration: none;
}
a:link img { 
border: none;
text-decoration: none;
}
a:hover img { 
border: none;
text-decoration: none;
}
a:active img {
border: none;
text-decoration: none;
}
a:visited img {
	text-decoration: none;
	border:none;
}
-->
</style>
</head>

<body>
<table width="930" border="0" cellpadding="0" cellspacing="0">
  <!--DWLayoutTable-->
  <tr>
    <td width="930" height="130" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0">
          <!--DWLayoutTable-->
          <tr>
            <td width="930" valign="top"><table width="100%" height="70" border="0" cellpadding="0" cellspacing="0" background="img/top.jpg">
              <!--DWLayoutTable-->
              <tr>
                <td height="37" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td height="22" colspan="2"></td>
                    </tr>
                  <tr>
                    <td width="290" align="center"><a href="index.html" target="_top"><img src="img/clickableheader.png" alt="FusionExcel" width="210" height="40" /></a></td>
                    <td width="426" align="center" class="smallhead11">World's Largest Seller of Scalar Energy Products!</td>
                   
                  </tr>
                </table></td>
                <td width="202" rowspan="2" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <!--DWLayoutTable-->
                    <tr>
                       <td height="25" align="right" id="white" class="header_title"><a href="chi/index.html" target="_top" class="whitelink">&#20013;&#25991;</a> <span class="smallcont_myo">|</span> <a href="bm/index.html" target="_top" class="whitelink">B. Malaysia</a> </td>
                      <td width="13"></td>
                    </tr>
                    <tr>
                      <td align="right">
                       <table width="150" border="0" cellspacing="0" cellpadding="0">
<form action="http://www.fusionexcel.com/xs_search.en.asp" id="csesearchbox" name="csesearchbox" method="GET" target="_parent">
  <tr>
    <td align="right"><img src="imgnews/search-left.gif" width="13" height="22" /></td>
    <td class="search-bg1">
	<input type="text" name="x" class="search-input1" value="Search Website" onfocus="csesearchbox.x.value='';" />
    </td>
    <td><img src="imgnews/search-right-1.gif" width="5" height="22" /></td>
    <td><img src="imgnews/go.gif" width="17" height="22" border="0" onclick="csesearchbox.submit();" /></td>
    <td><img src="imgnews/search-right.gif" width="12" height="22" /></td>
  </tr>
</form>
</table></td>
                      <td></td>
                    </tr>
                    <!--DWLayoutTable-->
                    <tr>
                      <td height="26" align="right" valign="middle" class="smallwhitehead"><script type="text/javascript">

/***********************************************
* Local Time script- ?Dynamic Drive (http://www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for this script and 100s more.
***********************************************/

var weekdaystxt=["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
var month = new Array ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec")

function showLocalTime(container, servermode, offsetMinutes, displayversion){
if (!document.getElementById || !document.getElementById(container)) return
this.container=document.getElementById(container)
this.displayversion=displayversion
var servertimestring=(servermode=="server-php")? '<? print date("F d, Y H:i:s", time())?>' : (servermode=="server-ssi")? '<!--#config timefmt="%B %d, %Y %H:%M:%S"--><!--#echo var="DATE_LOCAL" -->' : '<%= Now() %>'
this.localtime=this.serverdate=new Date(servertimestring)
this.localtime.setTime(this.serverdate.getTime()+offsetMinutes*60*1000) //add user offset to server time
this.updateTime()
this.updateContainer()
}

showLocalTime.prototype.updateTime=function(){
var thisobj=this
this.localtime.setSeconds(this.localtime.getSeconds()+1)
setTimeout(function(){thisobj.updateTime()}, 1000) //update time every second
}

showLocalTime.prototype.updateContainer=function(){
var thisobj=this
if (this.displayversion=="long")
this.container.innerHTML=this.localtime.toLocaleString()
else{
var date=this.localtime.getDate()
var monthserver=this.localtime.getMonth()
var year = this.localtime.getFullYear();

var hour=this.localtime.getHours()
var minutes=this.localtime.getMinutes()
var seconds=this.localtime.getSeconds()
var ampm=(hour>=12)? "PM" : "AM"
var dayofweek=weekdaystxt[this.localtime.getDay()]
this.container.innerHTML= month[monthserver]+ " " + date + " " + year + " " + formatField(hour, 1)+":"+formatField(minutes)+":"+formatField(seconds)+" "+ampm
}
setTimeout(function(){thisobj.updateContainer()}, 1000) //update container every second
}

function formatField(num, isHour){
if (typeof isHour!="undefined"){ //if this is the hour field
var hour=(num>12)? num-12 : num
return (hour==0)? 12 : hour
}
return (num<=9)? "0"+num : num//if this is minute or sec field
}

            </script>
                          <span id="timecontainer"></span>
                          <script type="text/javascript">
new showLocalTime("timecontainer", "server-asp", 0, "short")
              </script>
                      </td>
                      <td></td>
                    </tr>
                </table></td>
              </tr>
             
            </table></td>
          </tr>
          <tr>
            <td valign="top"  bgcolor="#FFCC00"><table width="850" border="0" align="center" cellpadding="1" cellspacing="1">
              <tr>
                <td width="890">
				<DIV ID="TICKER" STYLE="overflow:hidden; width:910px">
				15 Million Quantum Science Products Sold in 160 Countries! &nbsp;&nbsp;&nbsp; 50 Country Licensees! &nbsp;&nbsp;&nbsp; 2 Million High Income Members! &nbsp;&nbsp;&nbsp;
				15 Million Quantum Science Products Sold in 160 Countries! &nbsp;&nbsp;&nbsp; 50 Country Licensees! &nbsp;&nbsp;&nbsp; 2 Million High Income Members! &nbsp;&nbsp;&nbsp;
				15 Million Quantum Science Products Sold in 160 Countries! &nbsp;&nbsp;&nbsp; 50 Country Licensees! &nbsp;&nbsp;&nbsp; 2 Million High Income Members! &nbsp;&nbsp;&nbsp;
				15 Million Quantum Science Products Sold in 160 Countries! &nbsp;&nbsp;&nbsp; 50 Country Licensees! &nbsp;&nbsp;&nbsp; 2 Million High Income Members! &nbsp;&nbsp;&nbsp;
				15 Million Quantum Science Products Sold in 160 Countries! &nbsp;&nbsp;&nbsp; 50 Country Licensees! &nbsp;&nbsp;&nbsp; 2 Million High Income Members! &nbsp;&nbsp;&nbsp;
				15 Million Quantum Science Products Sold in 160 Countries! &nbsp;&nbsp;&nbsp; 50 Country Licensees! &nbsp;&nbsp;&nbsp; 2 Million High Income Members! &nbsp;&nbsp;&nbsp;
				</DIV>
                <script type="text/javascript" src="webticker_lib.js"></script> 
                </td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td height="32" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" background="img/button.gif" class="button">
              <!--DWLayoutTable-->
              <tr>
                <td width="10" height="32">&nbsp;</td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="48"><a href="index.html" target="_top" class="menu">Home</a></td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="60"><a href="news.asp?category_code=256" target="_top"  class="menu">Products</a></td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="88"><a href="news.asp?category_code=32" target="_top"  class="menu">Testimonials</a></td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="85" valign="middle"><a href="income_plan.html" target="_top" class="menu">Income Plan</a></td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="38"><a href="faq.html" target="_top" class="menu">FAQ</a></td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="70"><a href="news.asp?category_code=16" target="_top" class="menu">Corporate</a></td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="105"><a href="news.asp?category_code=8" target="_top" class="menu">Spokespersons</a></td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="105"><a href="service_centres.asp" target="_top" class="menu">Service Centres</a></td>
                <td width="12" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="50" class="menu"><a href="video_testimonials.html" target="_top" class="menu">Videos</a></td>
                <td width="13" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="60"><a href="training.html" target="_top" class="menu">Training</a></td>
                <td width="13" valign="top"><img src="img/arrow.gif" width="9" height="32" /></td>
                <td width="75" class="menu"><a href="signup.html" target="_top" class="redlink"> Sign Ups</a></td>
              </tr>
            </table></td>
          </tr>
    </table></td>
  </tr>
</table>
</body>
</html>
