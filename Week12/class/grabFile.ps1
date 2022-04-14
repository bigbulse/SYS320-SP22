# Create a commandline parameter to copy a file and place into an evidence directory
param(

[parameter(Mandatory = $true)]
[int]$reportlib,

[parameter(Mandatory = $false)]
[string]$filepath

)

# Create a dir with the report number
$reportDir = "rpt$reportNo"

# Create a new directory
mkdir $reportDir

# Copy the file into the new dir
copy-item $filepath $reportDir