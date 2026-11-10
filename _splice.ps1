$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$progPath = Join-Path $dir 'PROGRESS.md'
$newPath = Join-Path $dir '_newprog.txt'
$lines = [System.Collections.Generic.List[string]]([System.IO.File]::ReadAllLines($progPath, [System.Text.Encoding]::UTF8))
$i = -1
for ($k = 0; $k -lt $lines.Count; $k++) { if ($lines[$k] -like '## CURRENT POSITION*') { $i = $k; break } }
$j = -1
for ($k = $i + 1; $k -lt $lines.Count; $k++) { if ($lines[$k] -like '*## Step 3*') { $j = $k; break } }
if ($i -ge 0 -and $j -gt $i) {
  $lines.RemoveRange($i, $j - $i)
  $new = [System.Collections.Generic.List[string]]([System.IO.File]::ReadAllLines($newPath, [System.Text.Encoding]::UTF8))
  $lines.InsertRange($i, $new)
  [System.IO.File]::WriteAllLines($progPath, $lines, [System.Text.Encoding]::UTF8)
  Write-Output "rebuilt ok; now $($lines.Count) lines"
} else {
  Write-Output "anchors not found: i=$i j=$j"
}
