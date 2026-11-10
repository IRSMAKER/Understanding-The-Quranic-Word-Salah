$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$refs = @('33:50','33:51','33:52','33:53','33:54','33:55','33:56','33:57','33:58','33:59','33:60','33:61','33:62')
$sb = New-Object System.Text.StringBuilder
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-clean.txt'), [System.Text.Encoding]::UTF8)) {
  $p = $l -split '\|'
  $r = "$($p[0]):$($p[1])"
  if ($refs -contains $r) { [void]$sb.AppendLine("$r :: $($p[2])") }
}
[System.IO.File]::WriteAllText((Join-Path $dir '_ctx.txt'), $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output 'done'
