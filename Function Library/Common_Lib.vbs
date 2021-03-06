
'***********************Closing all browsers"*****************************************

Function CloseAllBrowsers(OBrName)

Select Case ucase(OBrName)

Case "CHROME"
systemutil.CloseProcessByName "chrome.exe"

Case "IE"
systemutil.CloseProcessByName "iexplore.exe"

End Select

End Function

'*************************'Closing Excel***************************************************

Function CloseExcel()
On error resume next
systemutil.CloseProcessByName "excel.exe"
End Function

'*************************Application Login**************************************************

Function ApplicationLogin()
On error resume next
SystemUtil.Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe","https://massmutual.okta.com/app/UserHome?fromLogin=true"
End Function

'*****************'Navigating to Field Net and entering the policy number on different Environments**************************************

Function FieldNetNavigation(Rc,obj2)
if DataTable.Value("Execution Flag","Sheet1 (2)")="Y" then
		If Datatable.Value("Env","Sheet1 (2)")="PROD" Then
				Browser("name:=Mass.*").page("title:=Mass.*").Image("alt:=Graphic Link FieldNet").Click
				ELSE
		End If
			wait 4
			QCnt=1
			do
			If QCnt=10000 Then
				Exit do
			End If
			QCnt=QCnt+1
			Loop until Browser("name:=Field.*").page("title:=Field.*").Link("html id:=QTIllustrations_a").GetROProperty("visible")=true
			
			
			Browser("name:=Field.*").page("title:=Field.*").Link("html id:=QTIllustrations_a").Click
			Browser("name:=Field.*").page("title:=Field.*").Link("text:=Life Illustrations \(MMDesigns\)").Click
			wait 6
		if Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebButton("name:=Close").exist then
			Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebButton("name:=Close").Click
		End If
		Browser("name:=MassMutual Designs - Client Editor").Maximize 'Maximizing the browser
		InforceNavigation Rc,UserProf,obj2
End If
End Function




Function InforceNavigation(Rc,UserProf,obj2)
wait 1

  If DataTable.Value("Execution Flag","Sheet1 (2)")="Y" Then
  				Environment.Value("startSec")=Second(Time())
				Environment.Value("startMin")=minute(Time())
			If Datatable.Value("Env","Sheet1 (2)")="DEV" Then
				browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webelement("xpath:=//DIV[@id='spnMenuInforce']/DIV[1]").Click
				browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webelement("xpath:=//DIV[@id='InforceUrl']/DIV[1]").Click
			ElseIf Datatable.Value("Env","Sheet1 (2)")="QA" Then               
				browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webelement("xpath:=//DIV[@id='spnMenuInforce']/DIV[1]").Click
				browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webelement("xpath:=//DIV[@id='InforceUrl']/DIV[1]").Click
			Else	
						Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").Sync
						If Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=OK","class:=btnMid").exist(1)=true  Then
						Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=OK","class:=btnMid").click
						else
						End If
					wait 2
							
						If Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=OK","class:=btnMid").exist(1)=true  Then
						Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=OK","class:=btnMid").click
						else
						End If
											
						If Browser("name:=MM Designs.*").page("title:=MM Designs.*").Image("file name:=search_for_new_contract_policy.gif").exist(1)=true Then
								Browser("name:=MM Designs.*").page("title:=MM Designs.*").Image("file name:=search_for_new_contract_policy.gif").Click
								Else
							Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=Inforce","html id:=btnInforce").Click
						End If	
				wait 2
				
			End If
			
			
			
			if Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=Continue","index:=1").exist(1)=true then
			Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=Continue","index:=1").Click
			else
			End If
			
			WAIT 2
			
			Browser("name:=MM Designs Inforce Entry Page").Maximize
			
			Browser("name:=MM Designs Inforce Entry Page").page("title:=MM Designs Inforce Entry Page").WebEdit("name:=policyNumber").Set Datatable.Value("Policy Number","Sheet1 (2)")
			
			'Code for clicking on Search button and verifying the error message"
			
			Browser("name:=MM Designs Inforce Entry Page").page("title:=MM Designs Inforce Entry Page").Image("file name:=search_grey\.gif").Click
			Browser("name:=MM Designs Inforce Single Result Page").page("title:=MM Designs Inforce Single Result Page").Image("file name:=continue_grey\.gif").Click
			Wait 5
			'''''''''''''''''''''''''''''''''''''
			do
			if DataTable.Value("Execution Flag","Sheet1 (2)")="Y" then
					StrboolMMpage=browser("name:=MM Designs.*").page("title:=MM Designs.*").webelement("html tag:=TD","innertext:=Error has occurred ").Exist
					StrboolMassmutuPage=browser("name:=MassMutual Designs.*").page("title:=MassMutual Designs.*").webelement("html tag:=TD","innertext:=Error has occurred ").Exist
					If StrboolMMpage=true or StrboolMassmutuPage=true Then
					''''''''''''''''''''''''''''''''''Capturing error screenshots''''''''''
									if StrboolMMpage=true then 
										browser("name:=MM Designs.*").page("title:=MM Designs.*").webtable("column names:=Inforce Illustrations Application.*").CaptureBitmap Environment.Value("UserProf")+"\SI_Automation\ErrorScreenshots\"+DataTable.Value("Policy Number","Sheet1 (2)")+".png",true
									ElseIf StrboolMassmutuPag=true Then 
										browser("name:=MassMutual Designs.*").page("title:=MassMutual Designs.*").webtable("column names:=Inforce Illustrations Application.*").CaptureBitmap Environment.Value("UserProf")+"\SI_Automation\ErrorScreenshots\"+DataTable.Value("Policy Number","Sheet1 (2)")+".png",true
									End If
						'''''''''''''''''''''''''''''Capturing error screenshot'''''''''''
						obj2.Cells(Environment.Value("RCell"),1).Value= DataTable.Value("Policy Number","Sheet1 (2)")
						obj2.Cells(Environment.Value("RCell"),2).Value= "Failed"
							obj2.Cells(Environment.Value("RCell"),2).interior.colorindex=3
							Environment.Value("RCell")=Environment.Value("RCell")+1	
					
						DataTable.Value("Execution Flag","Sheet1 (2)")="N"
						AcRcnt=AcRcnt+1
						 DataTable.GetSheet("Sheet1 (2)").SetNextRow
						If DataTable.Value("Execution Flag","Sheet1 (2)")="Y" Then
								Reporter.ReportEvent micFail,"Error has Occurred", Datatable.Value("Policy Number","Sheet1 (2)")&" policy number error has displayed"
								
								Browser("name:=MM Designs.*").page("title:=MM Designs.*").Image("file name:=search_for_new_contract_policy.gif").Highlight
								Browser("name:=MM Designs.*").page("title:=MM Designs.*").Image("file name:=search_for_new_contract_policy.gif").Click
								Browser("name:=MM Designs.*").page("title:=MM Designs.*").WebEdit("name:=policyNumber").Set Datatable.Value("Policy Number","Sheet1 (2)")
								Browser("name:=MM Designs.*").page("title:=MM Designs.*").Image("file name:=search_grey\.gif").Click
								Browser("name:=MM Designs.*").page("title:=MM Designs.*").Image("file name:=continue_grey\.gif").Click
									wait 1
								if Browser("name:=MM Designs.*").page("title:=MM Designs.*").webelement("xpath:=.//*[text()='Success']").Exist then
									Exit do
								End If
								
								wait 10
						End If	
							else
								Reporter.ReportEvent micWarning, "Request for Inforce policy data is complete", "policy is successful"
								Exit do
							End If
						else		
							Exit do	
					End If	
				Loop until StrboolMMpage=false and StrboolMassmutuPage=false
	End If
 End Function
 
'**************************Verifying Links under illustration which is there in left side panel******************************

Function VerifyingLinksIllustration()
	
If Browser("name:=Field.*").page("title:=Field.*").Link("text:=Illustrations").Exist(5) then
Browser("name:=Field.*").page("title:=Field.*").Link("text:=Annuity Sales Illustration").Highlight
Browser("name:=Field.*").page("title:=Field.*").Link("text:=Life In-Force Illustrations").Highlight
Browser("name:=Field.*").page("title:=Field.*").Link("text:=LTC Illustrations").Highlight
Browser("name:=Field.*").page("title:=Field.*").Link("text:=State Availability","target:=new").Highlight
End If

End Function

'*********************'Creating Agent and if agent exist then we will select agent and perform calculations***********************************************

Function SI_Agent_Creation(Rc,obj2)
      If DataTable.Value("Execution Flag","Sheet1 (2)")="Y" Then
			Set AgentObj=Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor")
			AgentObj.Sync
			
			ACnt=0
			Do 
			If ACnt=100 Then
				Exit do
			End If 
			

			ACnt=ACnt+1
			Loop until Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webelement("xpath:=.//*[text()='Agent Info']").Exist(5)=true

			Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webelement("xpath:=.//*[text()='Agent Info']").click
			if Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webelement("xpath:=.//*[@id='tblAgentList']/tr").Exist(3) then
				Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webelement("xpath:=.//*[@id='tblAgentList']/tr").click
					
				else
			
					AgentObj.WebElement("innertext:=Select").Click
					AgentObj.WebElement("innertext:=Update","index:=1").Highlight
					AgentObj.WebElement("innertext:=Update","index:=1").Click
					AgentObj.WebEdit("name:=Agent.FirstName.*").Set DataTable.Value("Agent_FirstName","Agent_Info")
					AgentObj.WebEdit("name:=Agent.LastName.*").Set DataTable.Value("Agent_LastName","Agent_Info")
					AgentObj.WebEdit("name:=Agent.Addr1.*.*").set DataTable.Value("Agent_Address","Agent_Info")
					AgentObj.WebEdit("name:=Agent.City.*").Set DataTable.Value("Agent_City","Agent_Info")
					Browser("MassMutual Designs - Client").Page("MassMutual Designs - Client").WebList("select").Select DataTable.Value("Agent_State","Agent_Info")
					AgentObj.WebEdit("name:=Agent.Zip.*").set DataTable.Value("Agent_ZipCode","Agent_Info")
					AgentObj.Image("file name:=checkboxredborder\.png").Click7
					AgentObj.WebElement("title:=Save current agent.*").Click
					AgentObj.WebElement("innertext:=Ok","class:=btnMid").Click
					
					set obj= Browser("name:=MassMutual Designs - Client Editor").Page("title:=MassMutual Designs - Client Editor")._
					WebTable("html id:=tblAgentSelection").ChildItem("3","1","WebElement","10")
					Setting.WebPackage("ReplayType") = 2
					  obj.Click
					Setting.WebPackage("ReplayType") = 1
			End If
			
			
			If Browser("name:=MassMutual Designs - Client Editor").Page("title:=MassMutual Designs - Client Editor")._
			 	webelement("html tag:=SPAN","innertext:=Default Agent").Exist Then
				else
				Browser("name:=MassMutual Designs - Client Editor").Page("title:=MassMutual Designs - Client Editor")._
			 	webelement("html tag:=A","innertext:=Set as Default").Click
				AgentObj.WebElement("innertext:=Ok","class:=btnMid").Click
			End If
			 	
			
				Browser("name:=MassMutual Designs - Client.*").page("title:=MassMutual Designs - Client.*").WebCheckBox("type:=checkbox","index:=1").Set "ON"
				Browser("name:=MassMutual Designs - Client.*").page("title:=MassMutual Designs - Client.*").WebElement("html tag:=B","innerhtml:=Calc").Highlight
				Browser("name:=MassMutual Designs - Client.*").page("title:=MassMutual Designs - Client.*").WebElement("html tag:=B","innerhtml:=Calc").Click
				wait 4
				Call DelCookies()
				If Browser("title:=wfw.*").Exist Then
					Browser("title:=wfw.*").Close
				End If
				CalcPDFImgDynWait()
				ErrorPanelCheck Rc,obj2
	End If	
	End Function
Function ErrorPanelCheck(Rc,obj2)
	'error displaying
do	
a=Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("xpath:=//TBODY[@id='tbodyStatus']/TR").GetROProperty("innertext")
If instr(a,"Error")>0 or instr(a,"error")>0 Then
	''''''''''''''''''''''''''''''''''Capturing error screenshots''''''''''
	Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").webtable("column names:=Illustration Status").CaptureBitmap Environment.Value("UserProf")+"\SI_Automation\ErrorScreenshots\"+DataTable.Value("Policy Number","Sheet1 (2)")+".png",true
	'''''''''''''''''''''''''''''''''''''Capturing error screenshots''''''''''
	Reporter.ReportEvent micwarning, "Error has Occurred", Datatable.Value("Policy Number","Sheet1 (2)")&" policy number error has displayed"
	obj2.Cells(Environment.Value("RCell"),1).Value= DataTable.Value("Policy Number","Sheet1 (2)")
	obj2.Cells(Environment.Value("RCell"),2).Value= "Failed"
	obj2.Cells(Environment.Value("RCell"),2).interior.colorindex=3
		Environment.Value("RCell")=Environment.Value("RCell")+1	
	AcRcnt=AcRcnt+1
	DataTable.Value("Execution Flag","Sheet1 (2)")="N"
	 DataTable.GetSheet("Sheet1 (2)").SetNextRow
	 if DataTable.Value("Execution Flag","Sheet1 (2)")="Y" Then 	 	
	
			InforceNavigation Rc,UserProf,obj2
			SI_Agent_Creation Rc,obj2
			ELSE
			Exit DO
	 End If
	else
	Reporter.ReportEvent micPass, "Policy number calculation is completed", "Policy number calculated"
	wait 4
	Exit do
	End If
Loop until Browser("name:=MassMutual Designs - Client.*").page("title:=MassMutual Designs - Client.*").Image("file name:=pdf.png").Exist(2)
End Function	
	
'******************************'Saving and Downloading PDF in Local Drive************************************************************************

Function SavingDownloadPDFLAN(SI_resultsFolder)
If DataTable.Value("Execution Flag","Sheet1 (2)")="Y" Then
		count =1
		
		'On error resume next
		set PDFObj=Browser("name:=MassMutual Designs - Client.*").page("title:=MassMutual Designs - Client.*")
		PDFObj.Image("file name:=pdf.png").Click
		wait 10
		window("title:=wfw.*").highlight
		wait 2
		Set mh=CreateObject("mercury.devicereplay")
'		mh.MouseUp 8,159, RIGHT_MOUSE_BUTTON
		wait 2
		
		Set oh=CreateObject("wscript.shell")
		oh.SendKeys "^s"
		
		wait 2
		Window("Google Chrome").Dialog("Save As").WinEdit("File name:").Type("")
		wait 3
		'MsgBox DataTable.value("Policy Number","Sheet1 (2)")
		Window("Google Chrome").Dialog("Save As").WinEdit("File name:").type(SI_resultsFolder&DataTable.value("Policy Number","Sheet1 (2)"))
		wait 3
		Window("Google Chrome").Dialog("Save As").WinButton("Save").Click
		wait 3
		Browser("title:=wfw.*").highlight
		Browser("title:=wfw.*").Close
End If
End Function

'*****************************************'Pdf saving local to shared path***************************************************

Function PDFSavingLocalToShared(UserProf)
 If DataTable.Value("Execution Flag","Sheet1 (2)")="Y" Then
			Set fso1 =CreateObject("Scripting.filesystemobject")
			Set folder=fso1.GetFolder(UserProf)
			If fso1.FolderExists(UserProf+"\SI_Results\") Then
					strDate=replace(date(),"/","-")
					strSDpath="\\mmdata1a2r2\newsi\SI Automated Testing\Test\MMD_HTML\MMD_ProdTest_Jun21_Release\"+strDate+"\"
					wait 5
					if fso1.FolderExists(strSDpath) Then'''Create folder on sysdate in shared path
					 fso1.CopyFile UserProf+"\SI_Results\"+DataTable.value("Policy Number","Sheet1 (2)")+".pdf","\\mmdata1a2r2\newsi\SI Automated Testing\Test\MMD_HTML\MMD_ProdTest_Jun21_Release\"+strDate+"\"
					Else
					  fso1.CreateFolder(strSDpath)
					  fso1.CopyFile UserProf+"\SI_Results\"+DataTable.value("Policy Number","Sheet1 (2)")+".pdf","\\mmdata1a2r2\newsi\SI Automated Testing\Test\MMD_HTML\MMD_ProdTest_Jun21_Release\"+strDate+"\"
					End If
			End If
End If	
 End Function


''*********************************************Deleting Cookies for Browser***************************************************
    Public Function DelCookies()
	
	Set WshShell = CreateObject("WScript.Shell")
	WshShell.run "RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8"
	'To clear browsing cookies
	WshShell.run "RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2"
	'To Clear Browsing History
	WshShell.run "RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1"
	
	End Function

'****************************************Trigerring the sharing the results from Outlook***************************************
Function TrigResultsOutlook(UserProf)
'CreateFolderZip()
Set oexcel=CreateObject("excel.application")
strEmailAttachments=Environment.Value("UserProf")+"\SI_Automation\Data Files\SI_Outputsheet.xlsx"
strErrZipfile=Environment.Value("UserProf")+"\SI_Automation\ErrorScreenshots.zip"
set wb=oexcel.workbooks.open(strEmailAttachments)
Set ws=wb.worksheets("Sheet1")
DataTable.AddSheet("Temp")
DataTable.ImportSheet strEmailAttachments,"Sheet1","Temp"
Row=DataTable.GetSheet("Temp").GetRowCount()
For rr = 1 To Row Step 1
    If rr=1  Then
    	flag=true
        str = "<html><head><style>table, th, td {  border: 1px solid black;text-align:auto}table {width:30%;border-collapse: Collapse;}</style></head><body><table><tr><th>"&ws.cells(1,1)&"</th><th>"&ws.cells(1,2)&"</th></tr></table></body></html>"
        ElseIf  (ws.cells(rr,1)<>"" and ws.cells(rr,2)<>"") and ws.cells(rr,2)="Failed" Then
        flag=true
        str = "<html><head><style>table, tr, td {  border: 1px solid black;text-align:auto}table {width:30%;border-collapse: Collapse;}</style></head><body><table><tr><td>"&ws.cells(rr,1)&"</td><td>"&ws.cells(rr,2)&"</td></tr></table></body></html>"
        else
        flag=false
    End If
    If flag=true Then
    	str1=str1&str
    End If
    
Next
CSSstr=str1
strmesssge="Hi Team,"&"<br><br>"&"Please find the attached test summary results."&"<br><br>"&" "&CSSstr&" "&"<br><br>"&_
"Thanks,"&"<br>"&"Automation Team."
Set objOutlook = CreateObject("Outlook.Application")
Set objEmail = objOutlook.CreateItem(0)

With objEmail
 .To = "spulusu20@massmutual.com;crachele@massmutual.com;AAhmed21@massmutual.com;kwinters@massmutual.com;ANakka46@massmutual.com"
' .Cc = "crachele@massmutual.com;AAhmed21@massmutual.com;kwinters@massmutual.com" 
 '.Bcc = strEmailBcc
 .Subject = "SI - Test Summary Results - "&Environment.Value("LocalHostName")
 .HTMLBody = strmesssge

 If (strEmailAttachments <> "") Then
  .Attachments.Add strEmailAttachments
'  .Attachments.Add strErrZipfile
 end If
 
 .Send
End With

'Clear the memory
Set objOutlook = Nothing
Set objEmail = Nothing


Set wb=nothing
oexcel.quit
Set oexcel=nothing
DeleteZip()
End Function

Function CalcPDFImgDynWait()
count =1
Do 
If count =40 Then
	Exit do
end If 
count =count+1
Loop until Browser("name:=MassMutual Designs - Client.*").page("title:=MassMutual Designs - Client.*").Image("file name:=pdf.png").Exist(2)
End Function

Function CreateFolderZip()
       
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    strFilePath = Environment.Value("UserProf")+"\SI_Automation\ErrorScreenshots"
    ResultsPath = Environment.Value("UserProf")+"\SI_Automation"
    ZipPath = strFilePath+".zip"
   
    'create zip folder
    Set file = objFSO.CreateTextFile(ZipPath, True)
    file.Write "PK" & Chr(5) & Chr(6) & String(18, vbNullChar)
    file.Close
    ' Create a Shell object and define paths
    Set objApp = CreateObject( "Shell.Application" )
    Set zip = objApp.NameSpace(ZipPath)
    Set folder = objApp.NameSpace(ResultsPath)
   
'    ' Copy the files to the compressed folder
'    zip.CopyHere(Environment.Value("UserProf")+"\SI_Automation")
   
    Set file = nothing
'    Set objFSO = nothing
    Set objApp = nothing
   
  End Function
  
  
  Function DeleteZip()
  
  	Set de=CreateObject("scripting.filesystemobject")
  	if de.FileExists(Environment.Value("UserProf")+"\SI_Automation\ErrorScreenshots.zip") then
  		de.deletefile(Environment.Value("UserProf")+"\SI_Automation\ErrorScreenshots.zip") 
  	End If
  
  End  Function
