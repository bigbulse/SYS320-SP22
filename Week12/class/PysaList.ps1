# List files in a directory and
# list all file and print full path
# Get-ChildItem -Recurse -Include *.docx,*.pdf, *.txt -Path .\Documents | Select FullName
#Get-ChildItem -Recurse -Include *.docx,*.pdf, *.txt -Path .\Documents | export-csv `
#-Path files.csv 

# Import CSV file.
$fileList = Import-Csv -Path .\files.csv -Header FullName

# Loop through the results
foreach ($f in $fileList) {

    Get-ChildItem -Path $f.FullName
    
}