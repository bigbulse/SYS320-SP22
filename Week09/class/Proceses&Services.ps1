# Get a lsit of running processess

#Get-Process
# Get list of members
# Get-process | Get-Member

# Get a list of processes: name, id, path
# Get-Process | Select-Object ProcessName, id, Path

# Save the Output to a CSV file
# Get-process | Select-Object ProcessName, id, Path | Export-Csv -Path "C:\Users\blais\Desktop\processes.CSV"

# System Services and properties
# Get-service | get-member
# Get-service | Select-Object Status, Name, DisplayName, BinaryPathName | export-csv -Path $outputName
$outputName = "C:\Users\blais\Desktop\runningServices.CSV"

# Get a list of running services
Get-service | Where-Object { $_.Status -eq "Running" } | export-csv -Path $outputName

# Check to see if the file exists
if ( Test-Path $outputName) {
    
    write-host -backgroundcolor "Green" -foregroundcolor "Black" "Services file was created!"

} else {

    write-host -backgroundcolor "Red" -foregroundcolor "Black" "Services file was not created!"

}