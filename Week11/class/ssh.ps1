# Login to a remote SSH Server
# New-SSHSession -ComputerName '192.168.6.71' -Port '2222' -Credential (Get-Credential blaise.notter)

# Run commands to remote server
<#
while ($True) {
    # Add a prompt to run Commands
    $the_cmd = read-host "Please enter a command"

    # Run command on remote SSH Server
    (Invoke-SSHCommand -index 0 $the_cmd).Output
}
#>

# Upload a file to remote host
Set-SCPItem -ComputerName '192.168.6.71' -Port '2222' -Credential (Get-Credential blaise.notter) `
-Destination '/home/blaise.notter' -Path 'eggs.txt'