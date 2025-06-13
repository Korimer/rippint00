Get-Content .env -Encoding UTF8 | 
    Where-Object {
        -not($_.ToString().StartsWith("#")) -and 
        $_.ToString().Contains("=")
    } |
    ForEach-Object {
        $k,$v = $_ -split "=", 2
        Set-Content "Env:\$k" $v
    }