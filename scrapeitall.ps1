$destination = "sitemap.xml"

$xmlprefs = @{
    Indent = $true
    IndentChars = "	" # this is a tab btw
}

[System.Xml.XmlWriterSettings]$settings = [System.Xml.XmlWriterSettings]::new()
foreach ($pref in $xmlprefs.Keys) {$settings.$pref = $xmlprefs[$pref]}
[System.Xml.XmlWriter]$writer = [System.Xml.XmlWriter]::create($destination,$settings)

#obviously just having fun experimenting with xmlwriter stuff
$writer.WriteString("`n")
$writer.WriteComment("Sup! You're looking at an encrypted sitemap. Can't get any links from it!")
$writer.WriteString("`n")
$writer.WriteStartElement("a","b")
$writer.WriteAttributeString("b","c")
$writer.WriteAttributeString("ddd","gootbye")
$writer.WriteElementString("new","line")
$writer.WriteEndElement()
$writer.Flush()
$writer.Close()