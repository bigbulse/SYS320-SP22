# Send an email using Powershell
$toSend = @('blaise.notter@mymail.champlain.edu')

# Message Body
$msg = "Hello"

while($true) {

    foreach($email in $toSend){
        
        # Send the email
        write-host "Send-MailMessage -From 'blaise.notter@mymail.champlain.edu' -To $email -Subject 'Tisk Tisk' `
        -Body $msg -SmtpServer X.X.X.X"
        
        # Pause for one second
        start-sleep 1
    }
}