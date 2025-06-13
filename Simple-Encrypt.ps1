$ErrorActionPreference = "Stop"

$filetomodify = "./new.txt"
$tmpfile = "tmp.txt"
$asstream = [System.IO.MemoryStream]::new()
$streamwriter = [System.IO.StreamWriter]::new($asstream)
$streamwriter.Write($env:password)
$streamwriter.Flush()
$pwdhash = Get-FileHash -InputStream $asstream | 
    Select-Object Hash
$pwdarr = 
& .\Load-Env.ps1

switch ($args[0]) {
    "Encrypt" {
        Get-Content $filetomodify > $tmpfile
        Remove-Item $filetomodify
        Get-Content $tmpfile |
        Foreach-Object {
            $_ | ConvertTo-SecureString -AsPlainText -Force |
            ConvertFrom-SecureString -SecureKey $arr >> new.txt
        }
        Remove-Item $tmpfile
        break
    }
    "Decrypt" {
        
        break
    }

    default {echo hihihihihi}
}
#Get-Item .\checkpoints.txt -