$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$refs = @('58:1','58:2','58:3','58:4','58:5','58:6','58:7','58:8','58:9','58:10','58:11')
$sb = New-Object System.Text.StringBuilder
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-clean.txt'), [System.Text.Encoding]::UTF8)) {
  $p = $l -split '\|'
  $r = "$($p[0]):$($p[1])"
  if ($refs -contains $r) { [void]$sb.AppendLine("$r :: $($p[2])") }
}
[System.IO.File]::WriteAllText((Join-Path $dir '_ctx.txt'), $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output 'done'
