$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Join-Path $dir 'quran-clean.txt'
$out = Join-Path $dir '_word_census.txt'
$lines = [System.IO.File]::ReadAllLines($src, [System.Text.Encoding]::UTF8)
# count unique words containing صل
# letters: Sad=0635, Lam=0644, Waw=0648 ; stem صل
$stem = [string]([char]0x0635) + [char]0x0644 # "صل"
$words = @{}
foreach ($l in $lines) {
  $parts = $l -split '\|'
  $ref = "$($parts[0]):$($parts[1])"
  $text = $parts[2]
  foreach ($w in (-split $text)) {
    if ($w.Contains($stem)) {
      if (-not $words.ContainsKey($w)) { $words[$w] = New-Object System.Collections.Generic.List[string] }
      $words[$w].Add($ref)
    }
  }
}
$sb = New-Object System.Text.StringBuilder
foreach ($k in ($words.Keys | Sort-Object)) {
  [void]$sb.AppendLine("$k  (($($words[$k].Count)))  $($words[$k] -join ' ')")
}
[System.IO.File]::WriteAllText($out, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "unique words: $($words.Count)"
