$ErrorActionPreference = "SilentlyContinue"

$filetomodify = "checkpoints.txt"
$tmpfile = "tmp.txt"

& .\Load-Env.ps1

$marshal = [System.Runtime.InteropServices.Marshal]
$asstream = [System.IO.MemoryStream]::new()
$streamwriter = [System.IO.StreamWriter]::new($asstream)
$streamwriter.Write($env:password)
$streamwriter.Flush()
$pwdhash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($asstream)

$behavior = $args[0].ToString().ToLower()
$loop = $true

while ($loop) {
    switch ($behavior) {
        "encrypt" {
            Get-Content $filetomodify > $tmpfile
            Remove-Item $filetomodify
            Get-Content $tmpfile -Encoding utf8 |
            Foreach-Object {
                $_ | ConvertTo-SecureString -AsPlainText -Force |
                ConvertFrom-SecureString -Key $pwdhash | Out-File $filetomodify -Encoding utf8 -Append
            }
            Remove-Item $tmpfile
            $loop = $false; break
        }
        "decrypt" {
            Get-Content $filetomodify > $tmpfile
            Remove-Item $filetomodify
            Get-Content $tmpfile -Encoding utf8 |
            Foreach-Object {
                $secure = $_ | ConvertTo-SecureString -key $pwdhash
                $ptr = $marshal::SecureStringToBSTR($secure) 
                $marshal::PtrToStringAuto($ptr) | Out-File $filetomodify -Encoding utf8 -Append
            }
            Remove-Item $tmpfile
            $loop = $false; break
        }
        
        default {$behavior = Read-Host "Please choose whether you wish to encrypt or decrypt `"$(Split-Path $filetomodify -Leaf)`""}
    }
}
