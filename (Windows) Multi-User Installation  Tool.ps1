<#  
.DESCRIPTION
    <(Windows) Ableton Live Multi-User Installation Script for Single Computer>.

.NOTES  
    Author     : Sean Galloway
    Version    : 1.1.1

Version 1.1 updated to remove Options.txt entries that move Live database and temp folders to shared locations. Updated for Live 12.
Version 1.1.1 updated for Live 12.0.10 Unlock.json format
#> 

# Get user input of Live edition and version

Write-Host -ForegroundColor Green "Please enter the edition and version number of Ableton Live, e.g. Suite 12.0.10. 
If you aren't sure of the Live version number, please navigate to http://ableton.com/account and look for the Live version number under 'Licenses'"

$EDITION = Read-Host "Edition"
$VERSION = Read-Host "Version"

# Check that user input is correct for installed Live version

If ( -not (test-path "$env:USERPROFILE\AppData\Roaming\Ableton\Live $version")) {

Write-Host -ForegroundColor Yellow "The version number you have entered is not a valid Live version.

Please enter the version number of Ableton Live, e.g. '12.0.10'.
 
If you aren't sure of the Live version number, please navigate to 

http://ableton.com/account 

and look for the Live version number under 'Licenses'"


$version = Read-Host "Version"}


If ( -not (test-path "$env:USERPROFILE\AppData\Roaming\Ableton\Live $version")) {
$wshell = New-Object -ComObject Wscript.Shell

	$wshell.Popup( "The version number you have entered is not a valid Live version.
Please contact Ableton Technical Support at tech@support.ableton.com. 
This program will now close.", 0, "Ableton Live Multi-User Installation", 0)
exit
}



else {
	$wshell = New-Object -ComObject Wscript.Shell

	$wshell.Popup( "Thank you for entering Live $edition $version.

Press OK to continue", 0, "Ableton Live Multi-User Installation", 0)
}


# Test for shared preferences unlock folder, if present, removes it and creates a new one. Then copy Unlock.json to shared location.


If (test-path ("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Unlock")) {Remove-Item -Path ("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Unlock") -force -recurse }

New-Item -Path ("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Unlock") -ItemType Directory 

Copy-Item -path ("$env:USERPROFILE\AppData\Roaming\Ableton\Live $version\Unlock\Unlock.json") -Destination ("C:\ProgramData\Ableton\CommonConfiguration\Live $version\Unlock\") 


# Delete default unlock folder for all users

$users = Get-ChildItem C:\USERS
foreach ($user in $users){
$folder = "$($user.fullname)\Appdata\Roaming\Ableton\Live $version\Unlock"
If (test-path $folder){
Remove-item $folder -force -recurse}
}




If (-not (test-path "C:\ProgramData\Ableton\CommonConfiguration\Live $version\Unlock\Unlock.json")) {
	$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup( "The Unlock file could not be copied to

$env:ProgramData\Ableton\CommonConfiguration\Live $version\Unlock.

Please contact Ableton Technical Support at 
tech@support.ableton.com", 0, "Ableton Live Multi-User Installation", 0)
exit
}

else {
	$wshell = New-Object -ComObject Wscript.Shell

	$wshell.Popup( "The shared Unlock folder has been successfully created at: 

$env:ProgramData\Ableton\CommonConfiguration\Live $version\Unlock 

The Unlock.json file has been successfully copied to this folder.

Press OK to continue", 0, "Ableton Live Multi-User Installation", 0)
}


# Test for shared preferences folder. If there, removes and creates a new one. 
# Then creates Options.txt file and adds relevant entries (auto-updates off, don't ask for Admin rights on launch)



If (test-path ("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\")) {Remove-Item -Path ("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\") -force -recurse }

New-Item -Path ("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\") -itemtype Directory 

New-Item -Path ("$env:Programdata\Ableton\CommonConfiguration\Live $version\Preferences\") -name "Options.txt" -itemtype "file"

Add-Content ("$env:Programdata\Ableton\CommonConfiguration\Live $version\Preferences\Options.txt") -value "-_DisableAutoUpdates"
Add-Content ("$env:Programdata\Ableton\CommonConfiguration\Live $version\Preferences\Options.txt") -value "-DontAskForAdminRights" 


If (-not (test-path "$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences")) {
	$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup( "The shared Preferences folder could not be created at 

$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences.

Please contact Ableton Technical Support at 
tech@support.ableton.com", 0, "Ableton Live Multi-User Installation", 0)
exit
}


else {
	$wshell = New-Object -ComObject Wscript.Shell

	$wshell.Popup( "The shared Preferences folder has been created at 

$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\ 

The necessary Options.txt entries have been successfully added. 

Press OK to continue", 0, "Ableton Live Multi-User Installation", 0)
}


# Create shared Packs folder


If (-not (test-path "$env:Users\Public\Documents\Ableton Live Packs")) {
    New-Item -Path ("$env:Users\Public\Documents\Ableton Live Packs") -itemtype Directory
}

If (-not (test-path "$env:Users\Public\Documents\Ableton Live Packs")) {
	$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup( "The shared Live Packs folder could not be created at 

$env:Users\Public\Documents\Ableton Live Packs

Please contact Ableton Technical Support at 
tech@support.ableton.com", 0, "Ableton Live Multi-User Installation", 0)
exit
}

else {
	$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup( "A shared Live Packs folder has been successfully created at 

C:\Users\Public\Documents\Ableton Live Packs 

This has been set as the Installation Folder for Packs.

Press OK to continue'", 0, "Ableton Live Multi-User Installation", 0)
}


# Copy Library.cfg to shared preferences folder, edit Library.cfg to allow unique User Library for all users and to set shared Packs folder for all users.

Copy-Item -path ("$env:USERPROFILE\AppData\Roaming\Ableton\Live $version\Preferences\Library.cfg") -Destination ("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\")
Remove-Item -path ("$env:USERPROFILE\AppData\Roaming\Ableton\Live $version\Preferences\Library.cfg") -force -recurse


$old_library = Get-Content -path "$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\Library.cfg"


$old_library = $old_library -replace "<ProjectPath Value=`"C:\\Users\\.*\\Documents\\Ableton\\`" />","<ProjectPath Value=`"C:\Users\%%USERNAME%%\Documents\Ableton\`" />"
$old_library = $old_library -replace "<PreferredFactoryPacksInstallationPath Value=`"`" />","<PreferredFactoryPacksInstallationPath Value=`"C:\Public\Documents\Ableton Live Packs`" />"

$old_library | Out-File -Encoding "UTF8" "$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\Library.cfg" 

$bytes = [system.io.file]::ReadAllBytes("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\Library.cfg")

[System.IO.File]::WriteAllBytes("$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\Library.cfg",$bytes[3..($bytes.length)])




If (-not (test-path "$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences\Library.cfg")) {
	$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup( "The Library.cfg file could not be copied to the shared Preferences folder at 

$env:ProgramData\Ableton\CommonConfiguration\Live $version\Preferences

Please contact Ableton Technical Support at 
tech@support.ableton.com", 0, "Ableton Live Multi-User Installation", 0)
exit
}


else {
$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup( "The Library.cfg file has been successfully edited and moved to the shared Preferences folder. 


Press OK to continue.", 0, "Ableton Live Multi-User Installation", 0)
}


# Remove default preferences folder for all users

$users = Get-ChildItem C:\USERS
foreach ($user in $users){
$folder = "$($user.fullname)\Appdata\Roaming\Ableton\Live $version\Preferences"
If (test-path $folder){
Remove-item $folder -force -recurse}
}


# Copy Live application to Start Menu for all users

If (test-path "$env:ProgramData\Ableton\Live 12 $EDITION\Program\Ableton Live 12 $EDITION.exe") {


$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Ableton Live 12 $EDITION.lnk")
$Shortcut.TargetPath = "$env:ProgramData\Ableton\Live 12 $EDITION\Program\Ableton Live 12 $EDITION.exe"
$Shortcut.Save()
}


If (-not (test-path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Ableton Live 12 $EDITION.lnk")) {
	$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup( "The Live application could not be added to the Start Menu for all users.

Please contact Ableton Technical Support at 
tech@support.ableton.com", 0, "Ableton Live Multi-User Installation", 0)
exit
}

else {
$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup( "Live has been successfully authorized and the application added to the Start Menu for all users. 

The multi-user installation is now complete.

Press OK to finish.", 0, "Ableton Live Multi-User Installation", 0)
}


