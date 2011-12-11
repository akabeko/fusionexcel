/*
 The tests
 */

// Check that we aren't under file://
function VerifyWebServer()
{
	var result = new Result() ;

	var protocol = window.location.protocol ;
	if (protocol !== "http:" && protocol !== "https:")
	{
		result.SetError("You must run this wizard from a web server (http://), not directly from your disc", null) ;
	}
	TestRunner.FinishedTest( result ) ;
}

// We must be running in IIS, and the asp pages must be enabled
function VerifyIISServer()
{
	(new FCKXml()).LoadUrl('assets/hello.asp', VerifyIISServer_Callback) ;
}

function VerifyIISServer_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
		// 403.1: execute access forbidden. Execution of asp pages is disabled
		if ( resource.status == 403 && resource.text.indexOf( 'HTTP 403.1 Forbidden: Execute Access Forbidden' ) !=-1 )
			result.SetError( 'The server doesn\'t allow to run asp pages (at least in this folder)' , null) ;
		else
			result.SetError( 'The asp test file failed. <br>' + resource.GetError() , null) ;
	}
	else
	{
		if ( resource.text !== 'hello' )
		{
			var server = '' ;
			// IE6 doesn't return the headers
			if (resource.headers)
			{
				// Buggy IE
				// IE7 doesn't return the Server header if the response was cached. Maybe also under other situations, so let's protect this.
				var matches = resource.headers.match( /Server\:\s(.*)/ ) ;
				if (matches)
					server = matches[1] ;
			}

			if (server!='' && server.indexOf('Microsoft-IIS')==-1 )
			{
				result.SetError( 'This wizard is meant to be used with the ASP connector on MS IIS server.<br>' +
					'You are using "' + server + '" instead.', null) ;
			}
			else
			{
				if (server=='')
					result.SetError('Probably you are trying to use this page in a non-MS server, but the browser didn\'t provide that info <br>' +
						resource.GetError() , null) ;
				else
					result.SetError('The asp test file wasn\'t parsed properly. <br>' + resource.GetError() , null) ;
			}
		}
	}
	TestRunner.FinishedTest( result ) ;
}

// Find out if the Disallowed Parent Path setting is enabled or not
function CheckDisallowedParentPath()
{
	(new FCKXml()).LoadUrl('assets/subfolder/includer.asp', CheckDisallowedParentPath_Callback) ;
}

function CheckDisallowedParentPath_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
		// Execution error
		if ( resource.status == 500 )
		{
			result.SetError( 'The configuration of the server doesn\'t allow to use relative paths in the INCLUDE' + GenerateIncludeSample() , 'http://docs.fckeditor.net/CKFinder/Developers_Guide/ASP/Troubleshooting/ParentPath' ) ;
			// The user has 2 options: fix the configuration or to change the location of this file
			// FIXME: Allow to run the wizard even if this test failed.
		}
		else
			result.SetError( 'The asp test file failed. <br>' + resource.GetError() , null) ;
	}
	else
	{
		if ( resource.text !== 'hello' )
			result.SetError('The asp test file wasn\'t parsed properly. <br>' + resource.GetError() , null) ;
	}
	TestRunner.FinishedTest( result ) ;
}

function GenerateIncludeSample()
{
	var matches = location.pathname.match(/^(.*\/)([^\/]*\/)/)
	var ckfinderRoot = matches[1];
	var wizardFolder = matches[2];

	var msg = '</p>';
	msg += '<p>These are the instructions to edit the files without changing the configuration of the server:<br>';
	msg += 'You must edit the "' + ckfinderRoot + 'core/connector/asp/connector.asp" and replace the ' +
			'<b class="pre">&lt;!-- #INCLUDE file="../../../config.asp" --&gt;</b> line with ' +
			'<b class="pre">&lt;!-- #INCLUDE virtual="' + ckfinderRoot + 'config.asp" --&gt;</b> </p>' +
			'<p>That\'s enough to make CKFinder work with the "Disallowed Parent Path" directive enabled. ' +
			'Remember that you\'ll need to edit it again whenever you upgrade CKFinder, or if you move it to another location in the server</p>' +
			'<p>To make this wizard work you must edit three files:<br>' +
			'Open "' + ckfinderRoot + wizardFolder + 'assets/ckfinder.asp" and "' + ckfinderRoot + wizardFolder + 'assets/connector.asp" ' +
			' and replace <b class="pre">FILE="../../core</b> with <b class="pre">VIRTUAL="'+ ckfinderRoot + 'core</b> in both of them (all occurences).<br>' +
			'Lastly, edit the "' + ckfinderRoot + wizardFolder + 'assets/subfolder/includer.asp" and replace ' +
			'<b class="pre">FILE="../hello.asp"</b> with <b class="pre">VIRTUAL="' + ckfinderRoot + wizardFolder + 'assets/hello.asp"</b></p>';

	return msg;
}


// Get Asp version
function CheckAspVersion()
{
	(new FCKXml()).LoadUrl('assets/check.asp?what=version', CheckAspVersion_Callback) ;
}

function CheckAspVersion_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
		result.SetError( 'The asp test file failed. <br>' + resource.GetError() , null) ;
	}
	else
	{
		var message = "The server is using the Asp version: " + resource.text ;
		result.SetWarning(message, null) ;
	}
	TestRunner.FinishedTest( result ) ;
}

// Some hosts like GoDaddy might block the CreateObject function
function VerifyCreateObject()
{
	(new FCKXml()).LoadUrl('assets/check.asp?what=createobject', VerifyCreateObject_Callback) ;
}

function VerifyCreateObject_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The test file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		if ( resource.text !== 'OK, CreateObject works' )
		{
			result.SetError('Checking for the ability to use CreateObject has failed:<br>' + resource.text , null) ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}


// This must be a subfolder of the main CKFinder
function VerifyCKFinder()
{
	(new FCKXml()).LoadUrl('assets/check.asp?what=ckfinder', VerifyCKFinder_Callback) ;
}

function VerifyCKFinder_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The test file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		if ( resource.text !== 'OK, CKFinder exists' )
		{
			var sHelp = '<br>You must place this "wizard" folder as a subfolder of the main "ckfinder" folder, at the same level that the "core" or "_samples" folders.' ;
			result.SetError('Checking for the existence of CKFinder has failed:<br>' + resource.text + sHelp , null) ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}

// check that the asp code is able to call an asp.net page in the same server
function VerifyLoopback()
{
	if (!executeAspNetTests())
		TestRunner.Skip();
	else
		(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=loopback', VerifyLoopback_Callback) ;
}

function VerifyLoopback_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The test file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		if ( resource.text !== 'OK' )
		{
			result.SetError('Calling asp.net from the server side has failed:<br>' + resource.text.replace('\r\n', '<br>') + '<br><br>' +
				ShowHostsHint(), null) ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}

// If the files haven't been modified they should provide some default responses:
function VerifyDefaultResponse(page, expected)
{
	(new FCKXml()).LoadUrl(page, function(resource) {VerifyDefaultResponse_Callback(resource, expected);}) ;
}

function VerifyDefaultResponse_Callback( resource, expected )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		if ( resource.text !== expected )
		{
			result.SetError('The file <a href="' + resource.url + '">' + resource.url + '<\/a>' +
				' has sent "' + HTMLEncode(resource.text) + '" as the response, but it should have sent "' + HTMLEncode(expected) + '" instead.' +
				' Please, verify any changes that you have done to that file and revert them back.'
				, null) ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}



// If the files haven't been modified they should provide some default responses:
function VerifyConfiguration(value, expected)
{
	(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=' + value, function(resource) {VerifyConfiguration_Callback(resource, expected);}) ;
}

function VerifyConfiguration_Callback( resource, expected )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		if ( resource.text !== expected )
		{
			switch (expected)
			{
				case '' :
					result.SetError(resource.text + '<br>' +
						' Please, verify any changes that you have done to the config.asp file and revert them back.'
						, null) ;

					break;
				case 'enabled':
					result.SetError('The connector is currently disabled. <br>' +
						'You might need to first login into your system in order to set the proper session variables that are being checked in the CheckAuthentication().'
						, null) ;

					break;

				default:
				result.SetError('The configuration file ' +
					' has sent "' + HTMLEncode(resource.text) + '" as the response, but it should have sent "' + HTMLEncode(expected) + '" instead.<br>' +
					' Please, verify any changes that you have done to the config.asp file and revert them back.'
					, null) ;

			}

		}
	}
	TestRunner.FinishedTest( result ) ;
}

// Check the baseDir
function VerifyBaseDir()
{
	(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=basedir', VerifyBaseDir_Callback ) ;
}

function VerifyBaseDir_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var value = resource.GetSingleNodeValue( 'baseDir/validate' ) ;
		if ( value != 'OK')
			result.SetError( "Failed to validate the baseDir setting.<br>" + value, null) ;
		else
			window.CKFinder_baseDir = resource.GetSingleNodeValue( 'baseDir/Path' ) ;
	}
	TestRunner.FinishedTest( result ) ;
}


function VerifyCKFinderEnabled()
{
	(new FCKXml()).LoadUrl('../core/connector/asp/connector.asp?command=Init', VerifyCKFinderEnabled_Callback) ;
}

function VerifyCKFinderEnabled_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	}
	else
	{
//		debugger
		var oNode = resource.SelectSingleNode( 'Connector/Error' ) ;
		if (oNode.attributes.getNamedItem('number').value != '0')
		{
			if (oNode.attributes.getNamedItem('number').value == '500')
				result.SetError('The connector is disabled. ' +
					'You must edit the config.asp file to validate that the user has authenticated ' +
					' and return true in the CheckAuthentication function.'
					, null) ;
			else
				result.SetError('An error was returned in the call to initialize the connector.' + resource.GetError() , null) ;
		}
		else
		{
			CKFinderResourcesInfo = resource.GetObject('Connector/ResourceTypes') ;
			result.SetWarning('Permisions for the current CKFinder user:<br>' + ParsePermissions(CKFinderResourcesInfo));
		}
	}
	TestRunner.FinishedTest( result ) ;
}



// Check if asp.net is enabled (it isn't a must)
function CheckAspNetEnabled()
{
	if (!executeAspNetTests())
		TestRunner.Skip();
	else
		(new FCKXml()).LoadUrl('assets/hello.aspx', CheckAspNetEnabled_Callback) ;
}

function CheckAspNetEnabled_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
//		// 403.1: execute access forbidden. Execution of asp pages is disabled
//		if ( resource.status == 403 && resource.text.indexOf( 'HTTP 403.1 Forbidden: Execute Access Forbidden' ) !=-1 )
//			result.SetError( 'The server doesn\'t allow to run asp pages (at least in this folder)' , null) ;
//		else
			result.SetError( 'The asp.net test file failed. <br>' + resource.GetError() , null) ;
	}
	else
	{
		if ( resource.text !== 'hello' )
		{
			result.SetError('The asp.net test file wasn\'t parsed properly. <br>' + resource.GetError() , null) ;
			// Disable the rest of asp.net tests:
			SelectedImageComponent = "-none-";
		}
	}
	TestRunner.FinishedTest( result ) ;
}

// Get Asp.Net version
function CheckAspNetVersion()
{
	if (!executeAspNetTests())
		TestRunner.Skip();
	else
		(new FCKXml()).LoadUrl('assets/ckfinder.aspx?what=version', CheckAspNetVersion_Callback) ;
}

function CheckAspNetVersion_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
		result.SetError( 'The asp.net test file failed. <br>' + resource.GetError() , null) ;
	}
	else
	{
		var message = "The server is using the Asp.Net framework version: " + resource.text ;
		result.SetWarning(message, null) ;
	}
	TestRunner.FinishedTest( result ) ;
}

// Get Asp.Net windows' user
function CheckAspNetUser()
{
	if (!executeAspNetTests())
		TestRunner.Skip();
	else
		(new FCKXml()).LoadUrl('assets/ckfinder.aspx?what=windowsUser', CheckAspNetUser_Callback) ;
}

function CheckAspNetUser_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
		result.SetError( 'The asp.net test file failed. <br>' + resource.GetError() , null) ;
	}
	else
	{
		// FIXME: Store it in a variable to provide better messages for warnings and errors.
		var message = "The server <em>might</em> be using this account for the Asp.Net process: " + resource.text ;
		result.SetWarning(message, null) ;
	}
	TestRunner.FinishedTest( result ) ;
}

// Check the baseDir
function CheckTempFolders()
{
	if (!executeAspNetTests())
		TestRunner.Skip();
	else
		(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=tempfolder', CheckTempFolders_Callback1 ) ;
}

function CheckTempFolders_Callback1( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{

		if (resource.GetSingleNodeValue( 'tempfolder/validate' ) != 'OK')
		{
			result.SetError( 'Checking for the temporary folder has failed. <br>' + resource.GetError() , null) ;
		}
		else
		{
			// Now let's compare it with the asp.net part
			(new FCKXml()).LoadUrl('assets/ckfinder.aspx?what=tempfolder', function(rNet) {CheckTempFolders_Callback2(rNet, resource);} ) ;
			return ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}

function CheckTempFolders_Callback2( rNet, rAsp )
{
	var result = new Result() ;
	if ( rNet.status != 200 )
		result.SetError( 'The file has failed. <br>' + rNet.GetError() , null) ;
	else
	{
		var TempPathAsp = rAsp.GetSingleNodeValue( 'tempfolder/TempPath' )  || '' ;
		var CKFinderTempPathAsp = rAsp.GetSingleNodeValue( 'tempfolder/CKFinderTempPath' )  || '' ;
		var finalPathAsp = (CKFinderTempPathAsp !='' ? CKFinderTempPathAsp : TempPathAsp);

		var TempPathNet = rNet.GetSingleNodeValue( 'tempfolder/TempPath' ) || '' ;
		var CKFinderTempPathNet = rNet.GetSingleNodeValue( 'tempfolder/CKFinderTempPath' )  || '' ;
		var finalPathNet = (CKFinderTempPathNet !='' ? CKFinderTempPathNet : TempPathNet);

		var value = rNet.GetSingleNodeValue( 'tempfolder/validate' ) ;
		if ( value != 'OK')
		{
			if (CKFinderTempPathNet==='')
			{
				result.SetError( 'The security settings of the asp.net enviroment doesn\'t allow to access the temp folder. <br>' +
					' You must edit the web.config file found in the CKFinder folder and put a path in the &lt;add key="CKFinderTempPath" value="" /> setting, that same path should be set in the CKFinderTempPath setting of config.asp.<br>' +
					'For example, you can set <b>&lt;add key="CKFinderTempPath" value="' + window.CKFinder_baseDir + '" /></b> ' +
					' in web.config and <b>CKFinderTempPath="' + window.CKFinder_baseDir + '"</b> in config.asp'
					, null) ;
			}
			else
				result.SetError( 'Checking for the temporary folder for asp.net has failed. <br>' + value , null) ;
		}
		else
		{

			if ( finalPathNet=='' )
				result.SetError( 'The security settings of the asp.net enviroment doesn\'t allow to access the temp folder. <br>' +
					' You must edit the web.config file found in the CKFinder folder and put a path in the &lt;add key="CKFinderTempPath" value="" /> setting, that same path should be set in the CKFinderTempPath setting of config.asp.<br>' +
					'For example, you can set <b>&lt;add key="CKFinderTempPath" value="' + window.CKFinder_baseDir + '" /></b> ' +
					' in web.config and <b>CKFinderTempPath="' + window.CKFinder_baseDir + '"</b> in config.asp'
					, null) ;
			else
			{
				if ( finalPathNet != finalPathAsp)
				{
					var message = 'The temp paths of the classic asp and asp.net enviroment are different. <br>' +
						' You must edit the web.config file found in the CKFinder folder and put a path in the &lt;add key="CKFinderTempPath" value="" /> setting, that same path should be set in the CKFinderTempPath setting of config.asp.<br>';
					if (CKFinderTempPathAsp!='' && CKFinderTempPathNet!='')
						message += 'Currently you have set as the temp path for asp "' + CKFinderTempPathAsp + ' and for .Net "' + CKFinderTempPathNet + '", but they must be exactly the same path';
					else
					{
						if (CKFinderTempPathAsp=='' && CKFinderTempPathNet=='')
							message += 'For example, you can set <b>&lt;add key="CKFinderTempPath" value="' + window.CKFinder_baseDir + '" /></b> ' +
								' in web.config and <b>CKFinderTempPath="' + window.CKFinder_baseDir + '"</b> in config.asp';
						else
						{
							if (CKFinderTempPathAsp!='')
								message += 'Currently you have set as the temp path for asp "' + CKFinderTempPathAsp + ' but you must match. Edit also the web.config and set <b>&lt;add key="CKFinderTempPath" value="' + CKFinderTempPathAsp + '" /></b>';
							else
								message += 'Currently you have set as the temp path for .Net as "' + CKFinderTempPathNet + ' but they must match. Edit also the config.asp and set <b>CKFinderTempPath="' + CKFinderTempPathNet + '"</b>';
						}
					}
					result.SetError( message, null) ;
				}
			}

		}
	}
	TestRunner.FinishedTest( result ) ;
}

// Verify that the server is able to find out the IP of its own host name.
function CheckGetIP()
{
	if (!executeAspNetTests())
		TestRunner.Skip();
	else
		(new FCKXml()).LoadUrl('assets/ckfinder.aspx?what=ip', CheckGetIP_Callback ) ;
}

function CheckGetIP_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
//		result.SetError('IP: <br>' + resource.GetError() , null) ;

		var aspNetIp = resource.GetSingleNodeValue( 'data/ip' ) ;
		hostIp = resource.GetSingleNodeValue( 'data/local_addr' ) ;
		serverName = resource.GetSingleNodeValue( 'data/server_name' ) ;

		if (aspNetIp == '0.0.0.0')
		{
			var message = 'Asp.Net isn\'t able to resolve the IP for the host "' + serverName + '".<br>' ;
			message += resource.GetSingleNodeValue( 'data/error' ) + '<br><br>';
			message += ShowHostsHint() ;
			result.SetError(  message , null) ;
		}

	}
	TestRunner.FinishedTest( result ) ;
}

var serverName, hostIp;
function ShowHostsHint()
{
		var message = '';
		message += 'This can happen if the server isn\'t allowed to make any outbound connection and can\'t resolve its own IP<br>' ;
		message += 'You can fix it by editing the host file of the server (or using the DNS management) and adding a loopback.<br>' ;
		message += 'Open "C:\\WINDOWS\\system32\\drivers\\etc\\hosts" with notepad and add the following line:<br>' ;
		message += '<b>' + hostIp + ' ' + serverName + '</b><br>' ;
		message += 'Then save the file and test again.' ;

		return message;
}

var CKFinderResourcesInfo ;

function getResourceInfo(resourceType)
{
	for (var i=0; i<CKFinderResourcesInfo.length; i++)
	{
		if (CKFinderResourcesInfo[i].name==resourceType)
		{
			return CKFinderResourcesInfo[i] ;
		}
	}

	var result = new Result() ;
	result.SetError( 'There is no info about the resource of type "' + resourceType + "'", null) ;
	TestRunner.FinishedTest( result ) ;

	return null;
}

// We can't get the file size from the normal init response
function GetResourcesInfo()
{
	// New versions will include this info.
	if (typeof CKFinderResourcesInfo[0].maxsize !== 'undefined')
		TestRunner.Skip();
	else
		(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=resources', GetResourcesInfo_Callback) ;
}

function GetResourcesInfo_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var sizeInfo = resource.GetObject('ResourceTypes') ;

// append size info
		for (var i=0; i<sizeInfo.length; i++)
		{
			var oResource = getResourceInfo(sizeInfo[i].name);
			oResource.maxsize = sizeInfo[i].maxsize;
		}
	}
	TestRunner.FinishedTest( result ) ;
}

function SendFileTest()
{
	var oResource = getResourceInfo("Files") ;

	if ( !oResource)
		return;

	var filesize = oResource.maxsize / 1024 ;
	if (filesize == 0)
		filesize = 3 * 1024 ; // 3Mb if nothing has been specified as maximum
	var data = createFile( filesize ) ;

	TestRunner.AppendToProgress('<p>This test will try to upload a ' + filesize/1024 + ' Mb. file to the server (using a simple test).<br>' +
		'If it fails due to a timeout you can skip it</p><div id="sendFileTestLog"></div>');

	var url = 'assets/ckfinder.asp?what=fileupload' ;
	var oXML = new FCKXml();
	var body = oXML.preparePostFile("test.txt", data);
	oXML.PostData(url, body, VerifySendFileTest, document.getElementById('sendFileTestLog') ) ;
}
function VerifySendFileTest( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var response = resource.text ;
		var message;
		if (response !== 'OK')
		{
			message = "Failed to send a test file to the server.<br>" + response;
			result.SetError( message, "http://docs.fckeditor.net/CKFinder/Developers_Guide/ASP/Troubleshooting/UploadSize");
		}
	}
	TestRunner.FinishedTest( result ) ;
}


// Check POSTing a "file"
function SendFile()
{
	var oResource = getResourceInfo("Files") ;

	if ( !oResource)
		return;

	var filesize = oResource.maxsize / 1024 ;
	if (filesize == 0)
		filesize = 3 * 1024 ; // 3Mb if nothing has been specified as maximum
	var data = createFile( filesize ) ;

	TestRunner.AppendToProgress('<p>This test will try to upload a ' + filesize/1024 + ' Mb. file to the server (using the ckfinder routines).<br>' +
		'If it fails due to a timeout you can skip it</p><div id="sendFileLog"></div>');

	var url = '../core/connector/asp/connector.asp?command=FileUpload&type=Files&currentFolder=%2F' ;
	var oXML = new FCKXml();
	var body = oXML.preparePostFile("test.txt", data);
	oXML.PostData(url, body, VerifySendFile, document.getElementById('sendFileTestLog') ) ;
}

function VerifySendFile( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		// Example response: <script type="text/javascript">window.parent.OnUploadCompleted(201,'test(7).txt') ;</script>
		var response = resource.text ;
// 1.3
// 		var matches = response.match( /<script type=\"text\/javascript\">window\.parent\.OnUploadCompleted\((\d+)(.*)\) ;<\/script>/) ;
// 1.4
		var matches = response.match( /<script type=\"text\/javascript\">window\.parent\.OnUploadCompleted\('(.*)', '(.*)'\) ;<\/script>/) ;
		if (matches)
		{
			var number = matches[1];
			if (number=='')
					result.SetError( "Failed to send a test file to the server.<br> Error code " + matches[2], null) ;
			/*
			switch (number)
			{
				// OK
				case '0':
				break;

//				// CKFINDER_CONNECTOR_ERROR_UPLOADED_FILE_RENAMED
//				case '201':
//				break;

				// CKFINDER_CONNECTOR_ERROR_UPLOADED_TOO_BIG
				case '203':
					result.SetError( "The test file is bigger than the maximum allowed in the CKFinder configuration.", null) ;
				break;

				default:
					result.SetError( "Failed to send a test file to the server.<br> Error code " + number, null) ;
				break;
			}
			*/
		}
		else
		{
			result.SetError( "Failed to send a test file to the server.<br>" + resource.GetError(), null) ;
			// Skip the test to delete the file as it will fail
			TestRunner.currentTest++ ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}

function DeleteTestFile(resourceType, fileName)
{
	var url = '../core/connector/asp/connector.asp?command=DeleteFile&type=' + resourceType + '&currentFolder=%2F&FileName=' + fileName ;
	var oXML = new FCKXml();
	var body = "CKFinderCommand=true";
	oXML.PostData(url, body, VerifyDeleteTestFile, null ) ;
}

function VerifyDeleteTestFile( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var oNode = resource.SelectSingleNode( 'Connector/Error' ) ;
		if (oNode.attributes.getNamedItem('number').value != '0')
		{
			result.SetError('An error was returned in the call to delete the test file.' + resource.GetError() , null) ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}


function CreateTestFile()
{
	var oResource = getResourceInfo("Files") ;
	if ( !oResource)
		return;

	var url = 'assets/ckfinder.asp?what=CreateTestFile' ;
	(new FCKXml()).LoadUrl(url, Callback_CreateTestFile ) ;
}

function Callback_CreateTestFile( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var response = resource.text ;

		if (response !== 'OK')
		{
			result.SetError( "Failed to create the test file in the server.<br>" + response, "") ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}


// Verify security of script execution in "userfiles" folder
function VerifyTestFile()
{
	var oResource = getResourceInfo("Files") ;
	if ( !oResource)
		return;

	(new FCKXml()).LoadUrl(oResource.url + 'hello.txt', VerifyTestFile_Callback ) ;
}

function VerifyTestFile_Callback( resource )
{
	var result = new Result(),
		ok = true;

	if ( resource.status != 200 )
	{
		// We want to get the permission denied error.
		// 403.1: execute access forbidden. Execution of asp pages is disabled
		if ( resource.status == 403 )
			result.SetError( 'The server doesn\'t allow access files in the "Files" folder.<br>' +
				'You must grant READ permissions for the folder where the files are being stored<br>' +
			resource.GetError() , null) ;
		else
			ok = false;
	}
	else
	{
		if ( resource.text !== 'hello' )
			ok = false;
	}

	if (!ok)
		result.SetError( 'The test file has failed. This might mean that the <b>baseUrl</b> or <b>baseDir</b> settings are wrong. <br>' + resource.GetError() , null) ;

	TestRunner.FinishedTest( result ) ;
}

// Check that the baseDir can be written by asp.net
function VerifyAspNetBaseDir()
{
	if (!executeAspNetTests())
		TestRunner.Skip();
	else
		(new FCKXml()).LoadUrl('assets/ckfinder.aspx?what=baseDir&Folder=' + encodeURI(window.CKFinder_baseDir) , VerifyAspNetBaseDir_Callback ) ;
}

function VerifyAspNetBaseDir_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var value = resource.GetSingleNodeValue( 'baseDir/validate' ) ;
		if ( value != 'OK')
			result.SetError( "The baseDir isn't writteable by the ASPNET process. Please adjust the permissions for that folder.<br>" + value, null) ;
	}
	TestRunner.FinishedTest( result ) ;
}


function CreateTestImage()
{
	var oResource = getResourceInfo("Images") ;

	if ( !oResource)
		return;

	var url = 'assets/ckfinder.asp?what=CreateTestImage' ;
	(new FCKXml()).LoadUrl(url, VerifyCreateTestImage ) ;
}

function VerifyCreateTestImage( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var response = resource.text ;

		if (response !== 'OK')
		{
			result.SetError( "Failed to create the test image in the server.<br>" + HTMLEncode(response), "") ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}

function CreateTestThumbnail(resourceType, fileName)
{
	if (SelectedImageComponent=="None")
	{
		TestRunner.Skip();
		return;
	}
	var url = 'assets/connector.asp?command=Thumbnail&type=' + resourceType + '&currentFolder=%2F&FileName=' + fileName ;
	(new FCKXml()).LoadUrl(url, VerifyCreateTestThumbnail ) ;
}

function VerifyCreateTestThumbnail( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var response = resource.text ;
		if (response.substr(6, 4)=="JFIF")
		{
			var img = document.createElement("IMG");
			//
//			img.src = "data:image/jpeg;base64," + encode64(response);
//				img.src = "data:image/jpg," + encodeURI(response);
//			document.body.appendChild(img) ;
			img.onload = function() {TestRunner.FinishedTest( result );};
			img.src = resource.url;
			document.getElementById("loggerOutput").appendChild(img) ;
			return;
		}
		else
			result.SetError( "The server didn't send back an image.<br>" + HTMLEncode(response), "") ;
	}
	TestRunner.FinishedTest( result ) ;
}




// Check the baseDir
function GetTestImage()
{
	(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=GetTestImage', GetTestImage_Callback ) ;
}

function GetTestImage_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		if (resource.text!='')
		{
			// test the new image
			CreateTestThumbnail('Images', resource.text);
			return;
		}
//		alert(resource.text)
	}
	TestRunner.FinishedTest( result ) ;
}



// Basic check for security
function CheckSecurity()
{
	(new FCKXml()).LoadUrl('assets/ckfinder.aspx?what=security', CheckSecurity_Callback ) ;
}

function CheckSecurity_Callback( resource )
{
	var result = new Result() ;
	// If it requires authentication, then it's safe.
	if ( resource.status == 401 )
	{
		TestRunner.FinishedTest( result ) ;
		return;
	}
//	if ( resource.status != 200 )
//		result.SetError( 'The file has failed. <br>' +
//			'This might be OK, as this is just an additional check<br>' +
//			'You can use the link to follow with the last tests<br>' + resource.GetError() , null) ;
//	else
	if ( resource.status == 200 )
	{
		var oNode = resource.SelectSingleNode( 'Connector/Error' ) ;
		if (oNode.attributes.getNamedItem('number').value == '0')
		{
				result.SetWarning('<b class="error">Warning.</b> The connector is enabled for everybody.<br>' +
					'You must edit the config.asp file to validate that the user has authenticated ' +
					' and only then return true in the CheckAuthentication function.<br>' +
					' Current permissions for an anonymous user:<br>' +
					ParsePermissions(resource.GetObject('Connector/ResourceTypes'))
					, null) ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}

// Show the session vars to find more easily problems with authentication
function GetSessionVars()
{
	(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=SessionVars', GetSessionVars_Callback ) ;
}

function GetSessionVars_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		result.SetWarning(resource.text, null) ;
	}
	TestRunner.FinishedTest( result ) ;
}


var SelectedImageComponent;
// Check the component selected in the config.asp file
function GetImageComponent()
{
	(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=Component', GetImageComponent_Callback ) ;
}

function GetImageComponent_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		SelectedImageComponent = resource.text;
	}
	TestRunner.FinishedTest( result ) ;
}


// Now let's see the component that it's being used
function GetUsedImageComponent()
{
	(new FCKXml()).LoadUrl('assets/connector.asp?command=UsedComponent', GetUsedImageComponent_Callback ) ;
}

function GetUsedImageComponent_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	else
	{
		var value = resource.text;
		var message = 'Currently selected image component: <b>' + SelectedImageComponent + '</b>.';
		if (value!=SelectedImageComponent)
			message += 'Component used by the scripts: <b>' + value + '</b>' ;

		if (SelectedImageComponent=='Auto')
			message+='<br>In order to improve performance you should change this line in the config.asp when everything else is OK:<br>' +
			'&nbsp;&nbsp;&nbsp;&nbsp;<em>Images.Add "component", "Auto"</em><br>' +
			'to:<br>' +
			'&nbsp;&nbsp;&nbsp;&nbsp;<em>Images.Add "component", "' + value + '"</em><br>';

		if (!executeAspNetTests())
			message += '<br>The Asp.Net tests won\'t be executed';

		result.SetWarning(message, null) ;
	}
	TestRunner.FinishedTest( result ) ;
}

function executeAspNetTests()
{
	return (SelectedImageComponent=="Auto" || SelectedImageComponent=="Asp.Net");
}


// Verify security of script execution in "userfiles" folder
function TestExecutionSetup()
{
	(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=Execution', TestExecutionSetup_Callback ) ;
}

function TestExecutionSetup_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	}
	TestRunner.FinishedTest( result ) ;
}

// Verify security of script execution in "userfiles" folder
function TestExecution(file, description)
{
	var oResource = getResourceInfo("Files") ;
	if ( !oResource)
		return;

	(new FCKXml()).LoadUrl(oResource.url + file, function (resource) {TestExecution_Callback(resource, description);} ) ;
}

function TestExecution_Callback( resource, description )
{
	var result = new Result() ;

	if ( resource.status != 200 )
	{
//		// We want to get the permission denied error.
//		// 403.1: execute access forbidden. Execution of asp pages is disabled
//		if ( resource.status == 403 ) //&& resource.text.indexOf( 'HTTP 403.1 Forbidden: Execute Access Forbidden' ) !=-1 )
//			result.SetWarning( 'The server is correctly rejecting access to asp files in the "userfiles" folder.' , null) ;
//		else
//			result.SetWarning( 'The asp test file failed. <br>' + resource.GetError() , null) ;
	}
	else
	{
		if ( resource.text == 'hello' )
		{
			result.SetWarning('<b class="error">Warning</b> The permissions of the "files" folder allows to execute ' + description +
				'. This can be dangerous if somehow an attacker manages to upload such a file there.' , null) ;
		}
	}
	TestRunner.FinishedTest( result ) ;
}

function TestExecutionClear()
{
	(new FCKXml()).LoadUrl('assets/ckfinder.asp?what=ClearExecution', TestExecutionClear_Callback ) ;
}

function TestExecutionClear_Callback( resource )
{
	var result = new Result() ;
	if ( resource.status != 200 )
	{
		result.SetError( 'The file has failed. <br>' + resource.GetError() , null) ;
	}
	TestRunner.FinishedTest( result ) ;
}
/*
 End of Tests
 */

// Check that we are under an appropiate server
TestRunner.Add(VerifyWebServer);
TestRunner.Add(VerifyIISServer);
TestRunner.Add(CheckDisallowedParentPath);
TestRunner.Add(CheckAspVersion);
TestRunner.Add(VerifyCreateObject);

// Now start the CKFinder related tests, first, check that everything is there
TestRunner.Add(VerifyCKFinder);


// first one just to check for parsing errors
TestRunner.Add(function() {VerifyConfiguration('', '');}) ;

TestRunner.Add(GetSessionVars);

TestRunner.Add(function() {VerifyConfiguration('enabled', 'enabled');}) ;
TestRunner.Add(function() {VerifyConfiguration('debug', 'normal');}) ;

TestRunner.Add(VerifyBaseDir);

TestRunner.Add(function() {VerifyDefaultResponse('../ckfinder.asp', '');});
TestRunner.Add(function() {VerifyDefaultResponse('../config.asp', '');});

TestRunner.Add(function() {VerifyDefaultResponse('../core/connector/asp/connector.asp', '<?xml version="1.0"?>\r\n<Connector><Error number="10"/><\/Connector>\r\n');});

TestRunner.Add(GetImageComponent);

TestRunner.Add(CheckAspNetEnabled);
TestRunner.Add(CheckAspNetVersion);
TestRunner.Add(CheckAspNetUser);

TestRunner.Add(CheckTempFolders);
TestRunner.Add(CheckGetIP);
TestRunner.Add(VerifyLoopback);

TestRunner.Add(VerifyCKFinderEnabled);

TestRunner.Add(GetResourcesInfo);

TestRunner.Add(CreateTestFile);
TestRunner.Add(VerifyTestFile);
TestRunner.Add(function() {DeleteTestFile('Files', 'hello.txt');} );

TestRunner.Add(SendFileTest);

TestRunner.Add(SendFile);
TestRunner.Add(function() {DeleteTestFile('Files', 'test.txt');} );

// Tests for asp.net thumbnails
TestRunner.Add(GetUsedImageComponent);

TestRunner.Add(VerifyAspNetBaseDir);

TestRunner.Add(CreateTestImage);
TestRunner.Add(function() {CreateTestThumbnail('Images', 'test.jpg');} );

// Verify that the thumbnail can be read once it has been created
// FIXME
TestRunner.Add(function() {DeleteTestFile('Images', 'test.jpg');} );

// Try to create thumbnails for existing images
TestRunner.Add(GetTestImage);


TestRunner.Add(CheckSecurity);

TestRunner.Add(TestExecutionSetup);
TestRunner.Add(function() {TestExecution('hello.asp', 'Asp scripts');});
TestRunner.Add(function() {TestExecution('hello.aspx', 'Asp.Net scripts');});
TestRunner.Add(function() {TestExecution('hello.php', 'PHP scripts');});
TestRunner.Add(TestExecutionClear);
