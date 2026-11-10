$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$refs = @('2:151','2:152','2:153','2:154','2:155','2:156','2:157','2:158','2:159','2:160','2:161','2:162','2:163')
$sb = New-Object System.Text.StringBuilder
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-clean.txt'), [System.Text.Encoding]::UTF8)) {
  $p = $l -split '\|'
  $r = "$($p[0]):$($p[1])"
  if ($refs -contains $r) { [void]$sb.AppendLine("$r :: $($p[2])") }
}
[System.IO.File]::WriteAllText((Join-Path $dir '_ctx.txt'), $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output 'done'
