$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Join-Path $dir 'quran-simple-min.txt'
$dst = Join-Path $dir 'quran-clean.txt'
$lines = [System.IO.File]::ReadAllLines($src, [System.Text.Encoding]::UTF8)
$out = New-Object System.Collections.Generic.List[string]
$bad = New-Object System.Collections.Generic.List[string]
foreach ($l in $lines) {
  if ([string]::IsNullOrWhiteSpace($l)) { continue }
  $parts = $l -split '\|'
  if ($parts.Count -lt 3) { $bad.Add($l); continue }
  $sura = [int]$parts[0]; $aya = [int]$parts[1]
  $text = $parts[2 .. ($parts.Count-1)] -join '|'
  # strip diacritics & Quranic marks
  $clean = $text -replace '[\u064B-\u065F\u0670\u06D6-\u06ED\u08F0-\u08FF\u0640]', ''
  $out.Add("$sura|$aya|$clean")
}
[System.IO.File]::WriteAllLines($dst, $out, [System.Text.Encoding]::UTF8)
Write-Output "verses: $($out.Count)  badlines: $($bad.Count)"
$bad | ForEach-Object { Write-Output "BAD: $_" }
