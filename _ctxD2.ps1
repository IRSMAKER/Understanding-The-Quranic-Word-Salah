$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$refs = @('2:108','2:109','2:110','2:111','2:112','2:113')
$sb = New-Object System.Text.StringBuilder
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-clean.txt'), [System.Text.Encoding]::UTF8)) {
  $p = $l -split '\|'
  $r = "$($p[0]):$($p[1])"
  if ($refs -contains $r) { [void]$sb.AppendLine("$r :: $($p[2])") }
}
[System.IO.File]::WriteAllText((Join-Path $dir '_ctx.txt'), $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output 'done'
