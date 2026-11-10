$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$refs = @('69:31','19:70','58:8','17:18','92:15','36:64','52:16','84:12','6:136','4:115','11:70','4:90','13:21','13:25','28:35','11:81','100:10','2:61','2:264','4:23','28:51')
$idx = @{}
foreach ($l in [System.IO.File]::ReadAllLines((Join-Path $dir 'quran-simple-min.txt'), [System.Text.Encoding]::UTF8)) {
  if ($l -match '^\d+\|\d+\|') { $p = $l -split '\|'; $idx["$($p[0]):$($p[1])"] = $p[2] }
}
$sb = New-Object System.Text.StringBuilder
foreach ($r in $refs) { [void]$sb.AppendLine("REF $r :: $($idx[$r])") }
[System.IO.File]::WriteAllText((Join-Path $dir '_refs_check.txt'), $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Output "done"
