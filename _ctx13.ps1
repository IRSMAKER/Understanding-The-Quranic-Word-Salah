$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$refs = @('88:1','88:2','88:3','88:4','88:5','88:6','88:7','88:8','88:9','88:10','88:11','88:12','88:13','88:14','88:15','88:16','92:1','92:2','92:3','92:4','92:5','92:6','92:7','92:8','92:9','92:10','92:11','92:12','92:13','92:14','92:15','92:16','92:17','92:18','92:19','92:20','92:21','111:1','111:2','111:3','111:4','111:5')
$sb = New-Object System.Text.StringBuilder
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-clean.txt'), [System.Text.Encoding]::UTF8)) {
  $p = $l -split '\|'
  $r = "$($p[0]):$($p[1])"
  if ($refs -contains $r) { [void]$sb.AppendLine("$r :: $($p[2])") }
}
[System.IO.File]::WriteAllText((Join-Path $dir '_ctx.txt'), $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output 'done'
