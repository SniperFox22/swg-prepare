#!/bin/bash

#Pause function
function pause()
{
        printf -- "\n\n"
        read -s -n 1 -p "Press any button to continue setup or ctrl+c to quit..."
        printf -- "\n\n"
}

printf --  "\n####################\n\nWelcome to the SWG Server Preparation Script!\nThis script is designed primarily for Oracle Linux 8.\nThis may not work on distros without those available packages.\n\n!!!This is the Mulit Server Installation and will ONLY install the SWG GameServer on Oracle Linux 8!!!\n\n\n####################\n"

pause

#Make a folder for dependencies
printf --  "\n\nMaking a folder for SWG dependencies\n"
mkdir ~/swg_dependencies
cd ~/swg_dependencies

printf --  "\n\nInstalling Python and Pip\n"
pause
#Install Python (This command could vary by distro)
sudo yum install python39 -y
sudo yum install python39-pip -y

#Que Oracle Utilities for download
printf --  "\n\nQueing Oracle Utilities for download\n"
pause
~/swg-prepare/server_downloads.sh

#Que up SWG Inititalization
printf -- "\n\nQue Up SWG Initialization Script\n"
pause
~/swg-prepare/swginit.sh

#source the profiles
printf -- "\nSourcing profiles from previous step\n"
pause
source /etc/profile.d/oracle.sh
source /etc/profile.d/java.sh

printf -- "\n\nFetching Install files from Source\n"
pause
#Fetch Install files from Source
git clone https://github.com/SniperFox22/swg-main.git ~/swg-main

pause
printf -- "\n\n##############################\n\n"
printf -- "\n\nSTOP! Before Continuing to the next step you must refer to the guide for configuring connections to your DB Server!\n\n"
printf -- "\n\n##############################\n\n"
pause

printf -- "\n\n##############################\n\n"
printf -- "\n\nLast Warning! At this point installation will fail if you have not setup connection to your DB Server\n\n"
printf -- "\n\n##############################\n\n"
pause

#Install SWG
printf -- "\n\nInstalling SWG\n"
cd ~/swg-main
ant swg

#Copy servercommon.cfg
printf -- "\n\nCopy servercommon.cfg to insert new java locations.\n"
pause
sudo cp ~/swg-prepare/servercommon.cfg ~/swg-main/exe/linux/servercommon.cfg
