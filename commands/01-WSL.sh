#Install Docker locally on Ubuntu WSL
https://docs.docker.com/engine/install/ubuntu/
https://github.com/YeffaDev/learn-kubernetes-brownbag/blob/master/lab/setup/06.Docker.md

#WSL2 resolv bug
#https://github.com/hashicorp/terraform/issues/30549
vi /etc/resolve.conf
nameserver 8.8.8.8

#Ubuntu folder(WSL)
\\wsl.localhost
/mnt/c/Users/<UserName>/Project$

#AzureCLI on WSL (install azcli on Ubuntu,don't use windows host azcli)
https://learn.microsoft.com/en-us/cli/azure/reference-docs-index
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az --version

#Open Ubuntu wsl from PowerShell and launch Visual Code
wsl
code .

#or install remote WSL extension in Visual Code
Open Command Palette (CTRL+SHIFT+P) -- >  Connect to WSL

#Open Windows Folder
ReOpen folder on windows