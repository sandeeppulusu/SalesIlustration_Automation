'Login function handling different environments

Function AppEnvironment(DevEnv,ProdEnv)
		Dim Environment, ObjBrowser	
		Environment=DataTable.value ("Env","Sheet1 (2)")
		
				If Environment="PROD" Then
					If ProdEnv>0 Then
						else
						SystemUtil.CloseProcessByName("Chrome.exe")
						wait 1
'					
						SystemUtil.Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe","https://massmutual.okta.com/app/UserHome?fromLogin=true"
						wait 8
						If Browser("name:=MassMutual Financial Group - Sign In").Page("title:=MassMutual Financial Group - Sign In").WebElement("innertext:=Login","html tag:=H2").Exist Then
         
					Browser("name:=MassMutual Financial Group - Sign In").Page("title:=MassMutual Financial Group - Sign In").WebEdit("name:=username").Set DataTable.Value("Username","App_Login")
					Browser("name:=MassMutual Financial Group - Sign In").Page("title:=MassMutual Financial Group - Sign In").WebButton("name:=Next").Click
					wait 4
					Browser("name:=MassMutual Financial Group - Sign In").Page("title:=MassMutual Financial Group - Sign In").WebEdit("name:=password").Set DataTable.Value("Password","App_Login")
					Browser("name:=MassMutual Financial Group - Sign In").Page("title:=MassMutual Financial Group - Sign In").WebButton("name:=Verify").Click
					wait 5
					End If
					End if
				elseif Environment="DEV" Then
					If DevEnv>0 Then
						else
						SystemUtil.CloseProcessByName("Chrome.exe")
						SystemUtil.Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe","https://massmutual.oktapreview.com/app/UserHome"
						wait 3
						Set ObjBrowser= Browser("name:=MassMutual Preview Dev/QA - Sign In").Page("title:=MassMutual Preview Dev/QA - Sign In")
						ObjBrowser.Sync
						ObjBrowser.webedit("html id:=okta-signin-username").Highlight
						ObjBrowser.webedit("html id:=okta-signin-username").set Datatable.Value("Agent_Username","App_Login")
						wait 3
						ObjBrowser.WebButton("name:=Next").Click
						ObjBrowser.WebEdit("name:=password").Set Datatable.Value("Agent_Password","App_Login")
						ObjBrowser.WebButton("name:=Verify","type:=submit").Click
						wait 4
						Browser("name:=MassMutual Preview Dev/QA - My Applications").page("title:=MassMutual Preview Dev/QA - My Applications").Image("file name:=fs04gzv9wtFxnELob0h7").Highlight
						Browser("name:=MassMutual Preview Dev/QA - My Applications").page("title:=MassMutual Preview Dev/QA - My Applications").Image("file name:=fs04gzv9wtFxnELob0h7").Click 					
					End If
			End If
	
		End  Function


