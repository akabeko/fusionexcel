<%@ Page Language="c#" Trace="false" AutoEventWireup="false" EnableSessionState="false" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Imaging" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.IO" %>
<%--
 * CKFinder
 * ========
 * http://www.ckfinder.com
 * Copyright (C) 2007-2008 Frederico Caldeira Knabben (FredCK.com)
 *
 * The software, this file and its contents are subject to the CKFinder
 * License. Please read the license.txt file before using, installing, copying,
 * modifying or distribute this file or part of its contents. The contents of
 * this file is part of the Source Code of CKFinder.
--%>
<script runat="server">

	private string GetSystemTempFolder()
	{
		try
		{
			return System.IO.Path.GetTempPath() ;
		}
		catch ( System.Security.SecurityException ex )
		{
			return( "" ) ;
		}
	}

	private string GetTempFolder()
	{
		// if a temp path has been set use it, else try to get the system temp path
		string tempFolder = ConfigurationSettings.AppSettings[ "CKFinderTempPath" ] ;
		if ( tempFolder == null || tempFolder.Length == 0)
		{
			tempFolder = GetSystemTempFolder() ;
		}
		return tempFolder ;
	}

	// Checks if the call to this page has been made from this same server.
	// In a shared hosting the call to GetTempPath might fail with a SecurityException
	private bool CheckIsLocalRequest()
	{
		// Check if the temporary file exists.
		string tempFile = Request[ "tmp" ];

		string tempFolder = GetTempFolder() ;
		if (tempFolder=="")
		{
			Response.Write( "The security settings doesn't allow the automatic authentication between Asp and Asp.Net, please use the CKFinderTempPath setting" );
			Response.End();
		}

		if ( tempFile != null && tempFile.Length > 0 )
			tempFile = System.IO.Path.Combine( tempFolder, tempFile + ".ckfindertemp") ;


		if ( tempFile == null || tempFile.Length == 0 || !System.IO.File.Exists( tempFile ) )
		{
			Response.StatusCode = 403;
			Response.Write( "<h1>403 - Forbidden</h1>" );
//			Response.Write( "<p>IsLocal: " + Request.IsLocal + "</p>" );
//			Response.Write( "<p>UserHostName: " + Request.UserHostName + "</p>" );
//			Response.Write( "<p>Remote: " + Request.ServerVariables[ "REMOTE_ADDR" ] + "</p>" );
//			Response.Write( "<p>Local: " + Request.ServerVariables[ "LOCAL_ADDR" ] + "</p>" );
			Response.End();
			return false;
		}

		return true;
	}

	private string ValidateWritableFolder(string folderPath, string okMessage)
	{
		// not really ok, but the client script should detect that the path is empty
		if (folderPath=="") return okMessage;

		// Verify that the folder does exists and that it's writeable.
		if (!System.IO.Directory.Exists(folderPath))
			return "The folder '" + folderPath + "' doesn't exist. Please create it and make it writeable" ;
		else
		{

			try
			{
				// Now check that we can create a file in it.
				string testFile = System.IO.Path.Combine(folderPath, "testFile.txt") ;
				CreateTextFile(testFile, "just some text") ;
				System.IO.File.Delete(testFile) ;
			}
			catch ( System.Exception ex )
			{
				string message = "Error writing a file in '" + folderPath + "'\r\n" ;
				message += "Excepcion: " + ex.ToString() + "\r\n" ;
				message += "You must grant write permissions to the ASPNET user for this folder." ;
				return message ;
			}


		}

		return okMessage ;
	}

	private void CreateTextFile(string FILENAME, string text)
	{
		System.IO.StreamWriter writer = System.IO.File.CreateText(FILENAME) ;
		writer.Write(text) ;
		writer.Close() ;
	}

	private string ResolveIP(string host)
	{
		try
		{
//			System.Net.IPHostEntry hostInfo = System.Net.Dns.GetHostEntry( host ) ;
			System.Net.IPHostEntry hostInfo = System.Net.Dns.GetHostByName( host ) ;
			return "<ip>" + hostInfo.AddressList[0].ToString() + "</ip>" ;
		}
		catch (System.Net.Sockets.SocketException ex)
		{
			return "<ip>0.0.0.0</ip><error>" + ex.Message + "</error>" ;
		}
	}


	protected override void OnLoad( EventArgs e )
	{
		string xml = "" ;

		switch ( Request[ "what" ] )
		{
			case "tempfolder":
				string CKFinderTempPath = ConfigurationSettings.AppSettings[ "CKFinderTempPath" ] ;
				string tempFolder =  GetSystemTempFolder() ;
				xml = "<TempPath>" + tempFolder + "</TempPath>" ;
				xml += "<CKFinderTempPath>" + CKFinderTempPath + "</CKFinderTempPath>" ;

				if (CKFinderTempPath!="") tempFolder = CKFinderTempPath ;

				xml += "<validate>" + ValidateWritableFolder(tempFolder, "OK") + "</validate>" ;
				Response.ContentType	= "text/xml" ;
				Response.Write("<?xml version=\"1.0\"?><tempfolder>" + xml + "</tempfolder>") ;

				return ;

			// Validates that the base folder is writeable by the asp.net process
			case "baseDir":
				string folder = Request[ "Folder" ] ;
				xml = "<folder>" + folder + "</folder>" ;

				xml += "<validate>" + ValidateWritableFolder(folder, "OK") + "</validate>" ;
				Response.ContentType	= "text/xml" ;
				Response.Write("<?xml version=\"1.0\"?><baseDir>" + xml + "</baseDir>") ;

				return ;

			// Check AspNet Framework Version
			case "version":
				Response.Write( System.Environment.Version ) ;
				return ;

			case "windowsUser":
				//Response.Write( Request.ServerVariables["AUTH_USER"]  ) ;
				// Response.Write( "User: " + System.Threading.Thread.CurrentPrincipal.Identity.Name ) ;
				Response.Write( System.Security.Principal.WindowsIdentity.GetCurrent().Name ) ;
				return ;

			case "ip":
				string host = Request.ServerVariables["SERVER_NAME"] ;

				Response.ContentType	= "text/xml" ;
				Response.Write("<?xml version=\"1.0\"?><data>" +
						"<server_name>" + host + "</server_name>" +
						ResolveIP( host ) +
						"<local_addr>" + Request.ServerVariables["LOCAL_ADDR"] + "</local_addr>" +
					"</data>") ;
				return ;

			case "security":
				string path = getBasePath() + "core/connector/asp/connector.asp?command=Init" ;

				Response.ContentType	= "text/xml" ;
				Response.Write( LoadUrl(path) );
				return ;
		}

//		if (!CheckIsLocalRequest())
//			return;
	}



	private string getBasePath()
	{
		string sValue = Request.Url.ToString() ;

		for(int i=1; i<=3; i++)
		{
			int j = sValue.LastIndexOf("/") ;
			sValue = sValue.Substring(0, j) ;
		}
		return sValue + "/" ;
	}


	private string LoadUrl(string path)
	{
		// Initialize the WebRequest. '(HttpWebRequest)
		Uri newUri = new Uri(path) ;
		WebRequest myRequest = WebRequest.Create( newUri ) ;

		// Send the request and get a response  ' (HttpWebResponse)
		WebResponse myResponse ;
		try
		{
			myResponse = myRequest.GetResponse() ;
		}
		catch (System.Net.WebException e)
		{
//			Response.ContentType	= "text/plain" ;
//			Response.Status = "401 Unauthorized" ;
//			return e.ToString() ;
			return "<?xml version=\"1.0\"?><Connector><Error number=\"1111\" message=\"" + e.ToString() + "\"/></Connector>" ;
		}
		Stream receiveStream = myResponse.GetResponseStream() ;
		StreamReader readStream = new StreamReader(receiveStream, System.Text.Encoding.GetEncoding("utf-8")) ;

		string sResponse = readStream.ReadToEnd() ;

		// Do a bit of cleanup
		myResponse.Close() ;
		readStream.Close() ;

		return sResponse ;
	}

</script>