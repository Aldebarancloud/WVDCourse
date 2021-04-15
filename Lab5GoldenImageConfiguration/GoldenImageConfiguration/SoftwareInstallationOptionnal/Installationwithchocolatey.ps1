Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install adobereader -y
choco install googlechrome -y
choco install firefox -y
choco install vlc -y
choco install vscode -y
choco install spotify -y
choco install drawio -y
choco install notepadplusplus.install -y
choco install zoom -y
choco install deepl -y
choco install teamviewer -y
choco install winrar -y