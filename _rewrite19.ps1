$ErrorActionPreference = 'Stop'
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$notes = Join-Path $dir '3_Study_Notes.md'
$fix = Join-Path $dir '_a19fix.txt'
$lines = [System.Collections.Generic.List[string]]([System.IO.File]::ReadAllLines($notes, [System.Text.Encoding]::UTF8))
$start = -1
for ($k = 0; $k -lt $lines.Count; $k++) { if ($lines[$k] -like '## A19 *') { $start = $k; break } }
if ($start -ge 0) {
  $lines.RemoveRange($start, $lines.Count - $start)
  $new = [System.Collections.Generic.List[string]]([System.IO.File]::ReadAllLines($fix, [System.Text.Encoding]::UTF8))
  $lines.InsertRange($start, $new)
  [System.IO.File]::WriteAllLines($notes, $lines, [System.Text.Encoding]::UTF8)
  Write-Output "rewritten from line $($start+1); now $($lines.Count) lines"
} else { Write-Output "A19 header not found" }
