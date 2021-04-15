SystemUtil.CloseProcessByName("excel.exe")
Set oshell=CreateObject("wscript.shell")
UserProf= oshell.ExpandEnvironmentStrings("%userprofile%")
Environment.Value("UserProf")=UserProf

StrOutputExcelPath=Environment.Value("UserProf")+"\SI_Automation\Data Files\SI_Outputsheet.xlsx"
Call CloseExcel()
Set obj=CreateObject("excel.application")
obj.visible=False
set obj1=obj.workbooks.open(StrOutputExcelPath)
Set obj2=obj1.worksheets("Sheet1")


'	dELETE ALL THE RECORDS IN OUTPUT FILE BEFORE RUN BEGIN
	row=obj2.usedrange.rows.count
	col=obj2.usedrange.columns.count
	
		For r = 2 To row Step 1
			For c = 1 To col Step 1
				obj2.cells(r,c).value=""
				obj2.Cells(r,c).interior.colorindex=2
			Next
		Next

obj1.save
Set fso=CreateObject("scripting.filesystemobject")
if fso.FolderExists(Environment.Value("UserProf")+"\SI_Results\") then
	fso.DeleteFolder(Environment.Value("UserProf")+"\SI_Results")
	fso.CreateFolder(Environment.Value("UserProf")+"\SI_Results\")
	else
	fso.CreateFolder(Environment.Value("UserProf")+"\SI_Results\")	
End If
SI_resultsFolder=Environment.Value("UserProf")+"\SI_Results\"

struname=Environment.Value("Uname")
strpwd=Environment.Value("Password")


Environment.Value("RCell")=2

Driver()'***

Function Driver()
	'Closing all browsers"
		Call CloseAllBrowsers("CHROME")
		'Excel
		Rcnt =DataTable.GetSheet("Sheet1 (2)").GetRowCount
  	If Rcnt>0 Then
         	
DevEnv=0
ProdEnv=0
AcRcnt=1
	For Rc = 1 To Rcnt Step 1
		DataTable.GetSheet("Sheet1 (2)").SetCurrentRow(AcRcnt)
	      
      If DataTable.Value("Execution Flag","Sheet1 (2)")<>"Y" Then
      	 else
      	Environment.Value("PolicyNo")= DataTable.Value("Policy Number","Sheet1 (2)")
      	
      	Call AppEnvironment(DevEnv,ProdEnv)'***************STEP 1 : lOGIN FUCNTIONALITY WITH DIFFERENT ENVIRONMEMNTS      	
		
		
		If ProdEnv>0 Then
			'Navigation to Inforce page
			Call InforceNavigation(Rc,UserProf,obj2)
			else
			' Navigation on Field Net
			Call FieldNetNavigation(Rc,obj2)
		End If
		
		
		'Creating Agent
		Call SI_Agent_Creation(Rc,obj2)
		
		'Saving and Downloading PDF in LAN
		Call SavingDownloadPDFLAN(SI_resultsFolder)
		
		'Pdf saving local to shared
		Call PDFSavingLocalToShared(UserProf)
		
				 If DataTable.Value("Execution Flag","Sheet1 (2)")="Y" Then
					obj2.Cells(Environment.Value("RCell"),1).Value=DataTable.Value("Policy Number","Sheet1 (2)")
					obj2.Cells(Environment.Value("RCell"),2).Value= "Completed"   
					obj2.Cells(Environment.Value("RCell"),2).interior.colorindex=4
					obj2.Cells(Environment.Value("RCell"),3).Value= timestamp() 
					Environment.Value("RCell")=Environment.Value("RCell")+1
					
				End If	
	 End if 
      
      If DataTable.value ("Env","Sheet1 (2)")="DEV" and DataTable.value ("Execution Flag","Sheet1 (2)")="Y" Then
      		DevEnv=DevEnv+1
      	ElseIf DataTable.value ("Env","Sheet1 (2)")="PROD" and DataTable.value ("Execution Flag","Sheet1 (2)")="Y" Then
			ProdEnv=ProdEnv+1	
      	End If
      DataTable.Value("Execution Flag","Sheet1 (2)")="N"
      	AcRcnt=AcRcnt+1
      next

  End If	
  End Function 
obj1.save                               
obj.Quit                                          
Set obj1=Nothing 

'call TrigResultsOutlook(UserProf)

'***************************'Deleting Cookies for browser******************************************
Call DelCookies()

'Email
TrigResultsOutlook(UserProf)
'***********************************************************************
'CloseBrowser

Call CloseAllBrowsers("CHROME")













Function timestamp()
			Environment.Value("EndSec")=Second(Time())
			Environment.Value("EndMin")=minute(Time())
			
			
			If Environment.Value("EndSec")=0 Then
				Environment.Value("EndSec")=60
			ElseIf Environment.Value("EndMin")=0 Then
				Environment.Value("EndMin")=60
			ElseIf Environment.Value("startSec")=0 Then
				Environment.Value("startSec")=60
			ElseIf Environment.Value("startMin")=0 Then	
				Environment.Value("startMin")=60			
			End If
			
			
					
		If Environment.Value("EndSec")>Environment.Value("startSec") and Environment.Value("EndMin")>Environment.Value("startMin")  Then
						timestamp=Environment.Value("EndMin")-Environment.Value("startMin") &" Minute "&Environment.Value("EndSec")-Environment.Value("startSec")&" Seconds "
						
		ElseIf Environment.Value("startSec")>Environment.Value("EndSec") and Environment.Value("startMin")>Environment.Value("EndMin")  Then
						timestamp=Environment.Value("startMin")-Environment.Value("EndMin") &" Minute "&Environment.Value("startSec")-Environment.Value("EndSec")&" Seconds "
						
		ElseIf Environment.Value("startSec")>Environment.Value("EndSec") and Environment.Value("EndMin")>Environment.Value("startMin")  Then 	
						timestamp=Environment.Value("EndMin")-Environment.Value("startMin") &" Minute "&Environment.Value("startSec")-Environment.Value("EndSec")&" Seconds "
						
		ElseIf Environment.Value("EndSec")>Environment.Value("startSec") and Environment.Value("startMin")>Environment.Value("EndMin")  Then 	
						timestamp=Environment.Value("startMin")-Environment.Value("EndMin") &" Minute "&Environment.Value("EndSec")-Environment.Value("startSec")&" Seconds "
			else			
		End If
		Environment.Value("EndMin")=""
		Environment.Value("startMin")=""
		Environment.Value("EndSec")=""
		Environment.Value("startSec")=""
End Function





