# This script saves bad ips to a temporary file
# Then the user is prompt to input "Windows" or "IPTables"
# A file is generated based on the conditon
# "Windows" creates a local ps1 file with firewall rules to block bad ips
# "IPTables" uploads a bash script to remote linux host that blocks bad ips 

# Array of websites containg threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules', 'https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rule list
foreach ($u in $drop_urls) {
    # Extract the filename
    $temp = $u.Split("/")
    
    # The last element in the array plucked off is the filename
    $file_name = $temp[-1]

    if (Test-Path $file_name) {
        continue 
    } else {
        # Download the rules list
        Invoke-WebRequest -Uri $u -OutFile $file_name
    } # close if statement
} # close for loop

# Array containing the filename
$input_paths = @('.\compromised-ips.txt', '.\emerging-botcc.rules')

# Extract the IP Addresses.
# 108.190.109.107
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP Addresses to the temporary IP list
Select-String -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"

# Get the input by the user, stored as $var.
$var = Read-host -Prompt "Please enter Windows or IPTables"

# Open Switch
switch ( $var )
{
    IPTables
    {
        # Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax 
        # After the IP address, add the remaining IPTables syntax and save the results to a file
        (Get-Content -Path ".\ips-bad.tmp") | % `
        { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
        Out-File -FilePath "iptables.bash"
        Set-SCPItem -ComputerName '192.168.6.71' -Port '2222' -Credential (Get-Credential blaise.notter) `
        -Destination '/home/blaise.notter' -Path "iptables.bash"

        # if statement to check if file exists, print green
        # Emily and I figured out that "ExitStatus 0" meant sucess
        # Therefore it can be used to check if file exists
        if ((Invoke-SSHCommand -index 0 'dir iptables.bash').ExitStatus -eq 0 ) {
    
            write-host -backgroundcolor "Green" -foregroundcolor "Black" "Services file was created!"
        
        } else {
        
            write-host -backgroundcolor "Red" -foregroundcolor "Black" "Services file was not created!"
        
        }
    }
    Windows
    {
        # Get the IP addresses discovered, loop through and append the bad ips to the "remoteip=" field
        # Then output this to a ps1 file
        (Get-Content -Path ".\ips-bad.tmp") | % `
        { $_ -replace "^", 'netsh advfirewall firewall add rule name="BLOCK BAD IPs" dir=in action=block remoteip=' -replace "$"} | `
        Out-File -FilePath "firerule_walls.ps1"
    }
}