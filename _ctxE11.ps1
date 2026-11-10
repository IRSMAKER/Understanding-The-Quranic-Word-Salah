$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$refs = @('75:27','75:28','75:29','75:30','75:31','75:32','75:33','75:34','75:35','75:36','75:37','75:38','75:39','75:40')
$sb = New-Object System.Text.StringBuilder
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-clean.txt'), [System.Text.Encoding]::UTF8)) {
  $p = $l -split '\|'
  $r = "$($p[0]):$($p[1])"
  if ($refs -contains $r) { [void]$sb.AppendLine("$r :: $($p[2])") }
}
[System.IO.File]::WriteAllText((Join-Path $dir '_ctx.txt'), $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output 'done'
