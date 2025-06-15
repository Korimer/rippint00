$ErrorActionPreference = "Stop"
$destination = "sitemap.xml"
$baseurl = "angusnicneven.com"

$xmlprefs = @{
    Indent = $true
    IndentChars = "	" # this is a tab btw
}

[System.Xml.XmlWriterSettings]$settings = [System.Xml.XmlWriterSettings]::new()
foreach ($pref in $xmlprefs.Keys) {$settings.$pref = $xmlprefs[$pref]}
# [System.Xml.XmlWriter]$writer = [System.Xml.XmlWriter]::create($destination,$settings)

# convinence
$SYShashset = [System.Collections.Generic.HashSet[string]]
$escapedurl = $baseurl -replace "([.+*?^$)(\\\[\]}{|])", '(\$1)'
$SiteMatcher = "^(?:(?:https?:\/\/)?(?:www\.)?$escapedurl|(?!https?:\/\/|www\.))" # Confirms that a link is either local or referencing the site you wanna map.
$PageMatcher = "^(?>(?:.*\/)?)(.*)$" # Captures the name of the trailing page, minus the url and such 

$pgs = @{}
$tovisit = [System.Collections.Generic.LinkedList[string]]::new()
$tovisit.Add("")

# $writer.WriteWhitespace("`n`n")
# $writer.WriteComment("Sup! You're looking at an xml sitemap. Should be pretty self-explanatory, to be honest.")
# $writer.WriteWhitespace("`n`n")

$escape = 0

while ($null -ne ($cur = $tovisit.First)) {
    $tovisit.RemoveFirst()
    $curpg = $cur.Value
    "Visiting $baseurl/$curpg"
    (Invoke-WebRequest -Uri "$baseurl/$curpg").Links.href | Where-Object {$_ -ne $null -and $_ -match $SiteMatcher} | ForEach-Object {
        $link = ($_ | Select-String -Pattern $PageMatcher).Matches.Groups[1] # Where-Object validation means this should never be null
        if (-not $pgs.ContainsKey($link)) {
            $pgs[$link] = $SYShashset::new()
            $tovisit.Add($link) >> $null
        }
        $pgs[$link].Add($curpg) >> $null
    }
    $escape++
    if ($escape -ge 25) {break;}
}
$pgs.Keys | % {$_.Value}
echo "$escape pages visited. Found $($pgs.Count) unique links."

#obviously just having fun experimenting with xmlwriter stuff
# $writer.WriteStartElement("Pages","b")
# $writer.WriteElementString("new","line")
# $writer.WriteEndElement()
# $writer.Flush()
# $writer.Close()