$ErrorActionPreference = "Stop"

$checkpointsFile = "checkpoints.txt"
$destinationFolder = "obsidian"
$allowedhosts = @(
  "angusnicneven.com"
  "sw.eusv.net"
  "depthk027.catsleydabluecatboi.xyz"
)
$escapeafter = 99999999 # max number of links to visit
$waitsecs = 0 # Time (in seconds) to wait between page visits. If you dont wanna ddoss someone, it's probably nice to keep it relatively large. lol.

$pgs = @{}
$tovisit = [System.Collections.Generic.LinkedList[Uri]]::new()

$SYShashset = [System.Collections.Generic.HashSet[string]]
function Screen-Ref {
  param (
    [Parameter(Mandatory=$true)][string]$PotentialLink,
    [uri]$Parent = $null
  )

  $uri = $null
  $canConvert = if ($null -eq $Parent) {
    # If no parent is given, assert the link is absolute
    [Uri]::TryCreate(
      [string]$PotentialLink,
      [System.UriKind]::Absolute,
      [ref]$uri
    )
  } else {
    # If a parent is given, the link can be local
    [Uri]::TryCreate(
      [Uri]$Parent,
      [string]$PotentialLink,
      [ref]$uri
    )
  }
  # Either way, the resulting uri is guaranteed to be absolute

  if ($canConvert) {
    if (-not($pgs.ContainsKey($uri))) {
      $pgs[$uri] = $SYShashset::new()
      $tovisit.Add($uri) | Out-Null
    }
    if ($null -ne $Parent) {
      $pgs[$Parent].Add($uri) | Out-Null
    }
  }
  else {
    Write-Host "link ""$potentialLink"" from page $uri is not a valid link!"
  }
}

Get-Content $checkpointsFile | % { Screen-Ref -PotentialLink $_ }

$SYShashset = [System.Collections.Generic.HashSet[string]]
$timer = [System.Diagnostics.Stopwatch]::StartNew()
$escape = 0
while ($null -ne ($curNode = $tovisit.First)) {
  $timer.Restart()
  $tovisit.RemoveFirst()
  $curUri = $curNode.Value
  Write-Host "visiting $curUri"

  $page = Invoke-WebRequest -Uri $curUri -AllowInsecureRedirect
  $links = $page.Links.href 

  foreach ($link in $links) {
    Screen-Ref -PotentialLink $link -Parent $curUri
  }
  
  $escape++
  if ($escape -ge $escapeafter) {break;}

  while ($timer.ElapsedMilliseconds -lt ($waitsecs * 1000)) {
    Start-Sleep -Seconds 1
  }
}

function Name-Page {
  param ([uri]$uri, [switch]$LocalRef)
  $shortname = $uri.PathAndQuery
  $len = $shortname.Length
  if ($len -gt 1) {
    $shortname = $shortname.Substring(1,$len-1)
  }
  $encoded = [System.Net.WebUtility]::UrlEncode($shortname)
  if ($localRef) {
    if (-not($pgs.ContainsKey($uri))) {
      return "!![[$($encoded)]]!!"
    } else {
      return "[[$($encoded)]]"
    }
  } else {
    return $encoded
  }
}

$saveFolder = Resolve-Path $destinationFolder
New-Item -ItemType Directory -Force $saveFolder
foreach ($key in $pgs.Keys) {
  $filename = "$saveFolder/$(Name-Page $key).md"
  &{
    "[$key]($key)"
    $pgs[$key] | % { Name-Page $_ -LocalRef }
  } | Out-File -Encoding utf8 $filename
}

echo "$escape pages visited. Found $($pgs.Count) unique links."
