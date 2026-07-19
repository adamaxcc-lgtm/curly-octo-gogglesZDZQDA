Dim objShell, fso, http, strImage, strMusic, tempFolder, imgFile, mp3File
Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' ===== LINKS (DIRECT) =====
strImage = "https://i.imgur.com/ZDlf9zG.jpeg"                     ' ★ Image direct link
strMusic = "https://www.dropbox.com/scl/fi/qry9yu5utz4th0jvoyh5k/jusatti890-scream-horror-sfx-490910.mp3?rlkey=4xzy4i9kgmm3481a2278bzwq7&st=r21z7lxf&dl=1"          ' ★ MP3 direct link
' ===========================

' Create temp folder
tempFolder = objShell.ExpandEnvironmentStrings("%TEMP%") & "\prank_temp"
If Not fso.FolderExists(tempFolder) Then fso.CreateFolder(tempFolder)
imgFile = tempFolder & "\prank_img.jpg"
mp3File = tempFolder & "\prank_music.mp3"

' Download image
objShell.Run "powershell -windowstyle hidden -command ""Invoke-WebRequest -Uri '" & strImage & "' -OutFile '" & imgFile & "'""", 0, True
WScript.Sleep 2000

' Check image
If Not fso.FileExists(imgFile) Then
    MsgBox "Failed to download image. Check the URL.", vbCritical, "Error"
    WScript.Quit
End If

' Download music
objShell.Run "powershell -windowstyle hidden -command ""Invoke-WebRequest -Uri '" & strMusic & "' -OutFile '" & mp3File & "'""", 0, True
WScript.Sleep 3000

' Check music
If Not fso.FileExists(mp3File) Then
    MsgBox "Failed to download music. Check the URL.", vbCritical, "Error"
    WScript.Quit
End If

' Play music
Dim wmp
Set wmp = CreateObject("WMPlayer.OCX.7")
If IsObject(wmp) Then
    wmp.URL = mp3File
    wmp.settings.volume = 100
    wmp.controls.play
Else
    objShell.Run "powershell -c (New-Object Media.SoundPlayer '" & mp3File & "').PlayLooping()", 0, False
End If

WScript.Sleep 500

' Kill explorer
objShell.Run "taskkill /f /im explorer.exe", 0, False
WScript.Sleep 1500

' Open fullscreen image via IE
Dim ie
Set ie = CreateObject("InternetExplorer.Application")
On Error Resume Next
ie.Navigate "about:blank"
ie.FullScreen = True
ie.ToolBar = 0
ie.StatusBar = 0
ie.Menubar = 0
ie.Resizable = 0
ie.Visible = True
WScript.Sleep 1000

ie.Document.Write "<html><head></head><body style='margin:0;overflow:hidden;background:black'><img src='file:///" & imgFile & "' style='width:100vw;height:100vh;position:fixed;top:0;left:0;object-fit:cover'/></body></html>"
ie.Document.Close

' Popup spam
Do While Not objShell.AppActivate("Task Manager")
    popup = objShell.Popup("⚠️ SYSTEM COMPROMISED!" & vbCrLf & vbCrLf & "Press OK to continue...", 5, "SECURITY ALERT", 16 + 4096)
    If popup = 2 Then Exit Do
    WScript.Sleep 2000
Loop

' Restore desktop
objShell.Run "explorer.exe", 1, False

' Cleanup
On Error Resume Next
fso.DeleteFolder tempFolder, True