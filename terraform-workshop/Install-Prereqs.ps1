# Chocolatey to make it easier to install other things
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Terraform 
choco install terraform -y

# Visual Studio Code
choco install vscode -y

# Google Chrome
choco install googlechrome -y

# Microsoft Teams
choco install microsoft-teams -y

