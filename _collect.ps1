$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ---- load census word -> refs ----
$census = Join-Path $dir '_word_census.txt'
$map = @{}
foreach ($ln in [System.IO.File]::ReadAllLines($census, [System.Text.Encoding]::UTF8)) {
  if (-not $ln.Trim()) { continue }
  $m = [regex]::Match($ln, '^(.+?)\s+\(\((\d+)\)\)\s+(.*)$')
  if ($m.Success) { $map[$m.Groups[1].Value] = ($m.Groups[3].Value -split ' ') }
}

# ---- the true S-L-W root family words (from census; everything else is a foreign root) ----
$family = @([System.IO.File]::ReadAllLines((Join-Path $dir 'family_words.txt'), [System.Text.Encoding]::UTF8) | Where-Object { $_ -and $_.Trim() })
$dropVerse = @([System.IO.File]::ReadAllLines((Join-Path $dir 'drop_verses.txt'), [System.Text.Encoding]::UTF8) | Where-Object { $_ -and $_.Trim() })

# build ref -> [words] from family only
$refWords = @{}
foreach ($w in $family) {
  if (-not $map.ContainsKey($w)) { Write-Output "MISSING in census: $w"; continue }
  foreach ($r in $map[$w]) {
    if ($dropVerse -contains $r) { continue }
    if (-not $refWords.ContainsKey($r)) { $refWords[$r] = New-Object System.Collections.Generic.List[string] }
    $refWords[$r].Add($w)
  }
}

# ---- load clean + original text ----
$clean = @{}
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-clean.txt'), [System.Text.Encoding]::UTF8)) {
  $p = $l -split '\|'; $clean["$($p[0]):$($p[1])"] = $p[2]
}
$orig = @{}
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-simple-min.txt'), [System.Text.Encoding]::UTF8)) {
  if ($l -match '^\d+\|\d+\|') { $p = $l -split '\|'; $orig["$($p[0]):$($p[1])"] = $p[2] }
}

# ---- emit collection file ordered by ref ----
$out = Join-Path $dir '1_Salah_Verses.md'
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# The Word Salah (Saad-Lam-Waw root) - all verses collected")
[void]$sb.AppendLine()
$ordered = $refWords.Keys | Sort-Object { [int]($_ -split ':')[0] }, { [int]($_ -split ':')[1] }
$sura = ''
foreach ($r in $ordered) {
  $s = ($r -split ':')[0]
  if ($s -ne $sura) { $sura = $s; [void]$sb.AppendLine(); [void]$sb.AppendLine("## Surah $s") }
  $ws = ($refWords[$r] | Sort-Object -Unique) -join ' | '
  [void]$sb.AppendLine("**$r** [$ws]")
  [void]$sb.AppendLine()
  [void]$sb.AppendLine($orig[$r])
  [void]$sb.AppendLine()
}
[System.IO.File]::WriteAllText($out, $sb.ToString(), [System.Text.Encoding]::UTF8)

Write-Output ("distinct verse refs with S-L-W root: " + $refWords.Count)
$svc = 0; foreach ($v in $refWords.Values) { $svc += $v.Count }
Write-Output ("total word occurrences: " + $svc)
# word inventory count (unique forms)
Write-Output ("unique word forms included: " + $family.Count)
[void]$null
