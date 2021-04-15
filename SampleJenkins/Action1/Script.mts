SystemUtil.Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe","https://massmutual.okta.com/app/UserHome?fromLogin=true"
wait 10
Browser("name:=Mass.*").page("title:=Mass.*").Image("alt:=Graphic Link FieldNet").Click

Browser("name:=Field.*").page("title:=Field.*").Link("html id:=QTIllustrations_a").Click

Browser("name:=Field.*").page("title:=Field.*").Link("text:=Life Illustrations \(MMDesigns\)").Highlight

Browser("name:=Field.*").page("title:=Field.*").Link("text:=Life Illustrations \(MMDesigns\)").Click

'15608444, 8252705
Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=An error message.*").Highlight

'21177396
Browser("name:=MM Designs Inforce.*").page("title:=MM Designs Inforce.*").WebElement("innertext:=The requested policy is.*","html tag:=B").Highlight

'32004190
Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=Check Error Panel","html tag:=TD").Highlight

'11533716
Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("innertext:=An error message.*").Highlight

 @@ script infofile_;_ZIP::ssf1.xml_;_
'Code for capturing different type of policy number errors

a=Browser("name:=MassMutual Designs - Client Editor").page("title:=MassMutual Designs - Client Editor").WebElement("xpath:=//TBODY[@id='tbodyStatus']/TR").GetROProperty("innertext")
If instr(a,"Error")>0 or instr(a,"error")>0 Then
	Reporter.ReportEvent micPass, "Error has Occurred", "Error Displayed"
	else
	Reporter.ReportEvent micFail, "Policy number calculation is completed", "Policy number calculated"
	End If
	

StrboolMMpage=browser("name:=MM Designs.*").page("title:=MM Designs.*").webelement("html tag:=TD","innertext:=Error has occurred ").Exist
StrboolMassmutuPage=browser("name:=MassMutual Designs.*").page("title:=MassMutual Designs.*").webelement("html tag:=TD","innertext:=Error has occurred ").Exist

If StrboolMMpage=true or StrboolMassmutuPage=true Then
	
	Reporter.ReportEvent micPass, "Error has Occurred", "Error is displayed"
	else
	Reporter.ReportEvent micFail, "Request for Inforce policy data is complete", "policy is successful"
	
End If

'Capturing the screenshot for error policy numbers
Call ErrorCaptScreenshot()
Function ErrorCaptScreenshot()
	
Set Odesc = description.Create()
Odesc("Micclass").Value="Browser"
Set Collection = Desktop.ChildObjects(Odesc)
Print "total open browsers are "&Collection.Count()

For i=0 to (Collection.Count()-1)
	StrTitle= "title of browser no: "&(i+1) & "is"& Collection(i).GetROProperty("title")
	If Instr(StrTitle,"MassMutual Designs - Client Editor") then
		Collection(i).CaptureBitmap "C:\Users\mm11804\OneDrive - MassMutual\Sandeep Docs\temp\Error1.png",True
	ElseIf Instr(StrTitle,"MM Designs Inforce Policy Unavailable Page")  Then
	    Collection(i).CaptureBitmap "C:\Users\mm11804\OneDrive - MassMutual\Sandeep Docs\temp\ErrorMessage.png",True
	End If
	
Next

End  Function

'Call CaptureScreenShot()
'Function CaptureScreenShot()
'    ImageDir = "C:\Users\mm11804\OneDrive - MassMutual\Sandeep Docs\" 'Path
'    Set BR = browser("name:=MM Designs.*") or browser("name:=MassMutual Designs.*")'Browser Properties
'    If BR.Exist Then
'        strTime = Split(Replace(Time,":","-")," ")
'        ImageName = strTime(0) & " " & strTime(1)
'        Set fso = CreateObject("Scripting.FileSystemObject")
'        On Error Resume Next
'        BR.CaptureBitmap ImageDir & ImageName & ".png"
'        strCapImages = strCapImages & "," & ImageDir & ImageName & ".png"
'        Set fso = Nothing
'        If Err.Number > 0 Then
'            Reporter.ReportEvent micFail,"Some error occured while capturing Screen shot",""
'        End If
'        On Error Goto 0
'    End If
'End Function


