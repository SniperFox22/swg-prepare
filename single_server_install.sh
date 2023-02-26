#!/bin/bash

#Pause function
function pause()
{
        printf -- "\n\n"
        read -s -n 1 -p "Press any button to continue setup or ctrl+c to quit..."
        printf -- "\n\n"
}

printf --  "\n####################\n\nWelcome to the SWG Server Preparation Script!\nThis script is designed primarily for Oracle/Alma/Rocky Linux 8.\nThis may not work on distros without those available packages.\n\n!!!This is the Single Server Installation and will install the Database and SWG Server on Oracle/Alma/Rocky Linux 8!!!\n\n\n####################\n"

pause

#Que up initialization script
printf -- "\nQue Up Initialization Script\n"
~/swg-prepare/oinit.sh

#Que up Oracle Installers
printf -- "\nQue Up Oracle Installation Scripts\n"
pause
~/swg-prepare/oracle_installer.sh

#Create Oracle Service
printf -- "\n\nCreate Oracle Service to start and stop the DB\n"
pause
~/swg-prepare/oservice.sh

#Make a folder for dependencies
printf --  "\n\nMaking a folder for SWG dependencies\n"
pause
mkdir ~/swg_dependencies
cd ~/swg_dependencies

#Que Oracle Utilities for download
printf --  "\n\nQueing Oracle Utilities for download\n"
pause
~/swg-prepare/server_downloads.sh

#Que up SWG Inititalization
printf -- "\nQue Up SWG Initialization Script\n"
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

#Install SWG
printf -- "\n\nInstalling SWG\n"
pause
cd ~/swg-main
ant swg

#Copy servercommon.cfg

printf -- "\n\nCopy servercommon.cfg to insert new java locations.\n"
pause
sudo cp ~/swg-prepare/servercommon.cfg ~/swg-main/exe/linux/servercommon.cfg
