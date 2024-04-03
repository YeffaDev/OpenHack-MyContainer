#Use this repo to download source code and configuration files
git clone https://github.com/YeffaDev/OpenHack-MyContainer

#Configure git account
#https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
#Configure github credential
sudo git config --system --unset credential.helper
git config --global user.name "user1"
git config --global user.email "user1@domain.com"

#Create the "OpenHack-YourNameCOntainer" repo to manage your own configuration files
#Create a new repo in the github portal console

#Create local repo

cd ~/Openhack
mkdir OpenHack-YourNameContainer
echo "# OpenHack-YourNameContainerLab" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main

#Sync remote repo
git remote add origin https://github.com/user1/OpenHack-YourNameContainer.git
git push -u origin main

