$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$refs = @('74:1','74:2','74:3','74:4','74:5','74:6','74:7','74:8','74:9','74:10','74:11','74:12','74:13','74:14','74:15','74:16','74:17','74:18','74:19','74:20','74:21','74:22','74:23','74:24','74:25','74:26','74:27','74:28','74:29','74:30','74:31','74:32','74:33','74:34','74:35','74:36','74:37','74:42','74:43','74:44','74:45','74:46','74:47','74:48','74:49')
$sb = New-Object System.Text.StringBuilder
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-clean.txt'), [System.Text.Encoding]::UTF8)) {
  $p = $l -split '\|'
  $r = "$($p[0]):$($p[1])"
  if ($refs -contains $r) { [void]$sb.AppendLine("$r :: $($p[2])") }
}
[System.IO.File]::WriteAllText((Join-Path $dir '_ctx.txt'), $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output 'done'
