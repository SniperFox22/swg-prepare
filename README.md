# SWG Server Preparation Guide:

Original Guide by Tekohswg

Modified by RezecNoble - Designed for Oracle Linux 8 / Alma Linux 8 / Rocky Linux 8
(Should also apply to RedHat Linux 8 which these distros are based on)

Modified by SniperFox22 to add missing steps and the procedure for enabling atmospheric flight on your own servers

The first step is to install Oracle Linux 8.7 server
Download the Oracle 8.7 server ISO
https://yum.oracle.com/ISOS/OracleLinux/OL8/u7/x86_64/OracleLinux-R8-U7-x86_64-dvd.iso
Download Rufus (Tool for creating USB boot drive)
https://rufus.ie/en/
Use Rufus to create a USB boot drive from the ISO you downloaded. After you select the "device" as the USB drive you want to use, and select the ISO you downloaded aas "boot_selection" hit start. When you get the popup choose "dd" install

After you create the boot drive reboot into this drive by hitting F12 on your keyboard as it is restarting to get to your boot menu. Select to boot from the USB boot drive you just created.
This should start the Oracle 8.7 install, after choosing your language hit next.

Now setup a root password as "swg"

Now setup a user as "swg" and there password as "swg" and hit the checkbox for "administrator" so they have sudo rights.

After this select the location to install the system, and configure your network and install the operating system.
After this is done restart and log in as the "swg” user using “swg” as the password

This guide and script are going to assume the hostname/username of swg. Future releases will include a config file for defining custom variables.

Starting off, we want our server to have a static IP address. First, it’s helpful to know what our current IP address is. Open a terminal and run this command:

`ifconfig`

You’ll get an output that looks like this. Pay attention to the numbers that correspond with the ones circled in red. Yours will be different. Once you’ve noted this IP address, you may close the terminal.

<p align="center">
  <img src="/screenshots/img1.jpg">
</p>

Now, click the network icon (the ethernet jack) on the right side of the taskbar and click Edit Connections.... 

<p align="center">
  <img src="/screenshots/img2.jpg">
</p>

In the window that appears, select Wired connection 1 and click the gear icon at the bottom of the window. 

<p align="center">
  <img src="/screenshots/img3.jpg">
</p>

Click on the tab called IPv4 settings. For the Method, select Manual. Then under addresses, click Add. For your address, enter an address that has the same first three numbers as the IP address you noted earlier, but substitute the fourth number for something that is available on your network. Selecting a large fourth number like 250 is almost always be safely outside your DHCP address pool. If you press Tab when you’re done, the Netmask will be populated automatically. If it doesn’t, it should usually be 24. The Gateway should be the IP address of your router. (If you’re not sure, check for a sticker on your router or maybe the manual. You can also run route -n from a terminal.) For your DNS servers, enter 1.1.1.2, 1.0.0.2. Click Save when you’re done and close the Network Connections window.

<p align="center">
  <img src="/screenshots/img4.jpg">
</p>

If not already set, please set your hostname to something memorable, for this example I will use 'swg'

`hostnamectl set-hostname swg`

We should now add our static IP address to the hosts file. Open a terminal and enter this command:

`sudo vi /etc/hosts`

<p align="center">
  <img src="/screenshots/img5.jpg">
</p>

`Press     'esc' :wq      to save and exit.`

Go ahead and reboot the server at this point

`sudo reboot`

Now, we can install git using this command:

`sudo yum install git -y`

Next, we want to download the swg-prepare repository. This repository contains stuff you need to get your system ready.

`git clone https://github.com/SniperFox22/swg-prepare.git`

Start off by running the following command:

`~/swg-prepare/main.sh`

This will launch a menu with four options.

- "Single Server Install"
- "Multi Server Install - Database"
- "Multi Server Install - Gameserver (Oracle/Alma/Rocky 8)"
- "Multi Server Install - Gameserver (Debian 11)" (Still being tested, do not use)

<em>Single Server Installations</em> are meant for running your DB and Gameserver on a single installation of Oracle 8.
This option is best for prepping a new VM, running a test server or a development server.
!!It is NOT recommended to use that setup for a production server. In production you should run separate servers.

<em>Multi Server Options:</em>

The first option is meant for installing the Oracle database and setting the necessary configurations on a server running Oracle/Alma/Rocky Linux 8.

The second option is meant for installing the Gameserver on a server running Oracle/Alma/Rocky Linux 8.

The third option is meant for installing the Gameserver on a server running Debian 11. (Still being tested, do not use)


# Post Install:

At any point in the future you can access sqldeveloper using the following command.

`/opt/sqldeveloper/sqldeveloper.sh`

As SQL Developer loads, it will ask you if you want to import your preferences. Click No. After loading some more, it will ask you about reporting your usage to Oracle. Uncheck the box to opt out and click OK.

We want to add some new connections. Click the green plus icon on the left-hand side under Connections. First, enter these inputs and click Save.

`Connection name: system@swg
Username: system
Password: swg
[x] Save Password
SID: swg`

<p align="center">
  <img src="/screenshots/img6.png">
</p>

Create another connection with these inputs and click save again:

`Connection name: swg@swg
Username: swg
Password: swg
[x] Save Password
SID: swg`

<p align="center">
  <img src="/screenshots/img7.png">
</p>

With both these connections created, close this window. Your two new connections will now appear on the list on the left-hand side. Double-click on system@swg to connect as system.

Now we want to rebuild the server with Atmospheric flight enabled
In a new terminal window navigate to the src directory
`cd ~/swg-main/src`
Then checkout the atmo branch
`git checkout atmo`
now switch the dsrc folder and do the same
`cd ~/swg-main/dsrc`
`git checkout atmo`
after this we need to re-compile the game again
`cd ~/swg-main`
`ant compile`
let this compile finish, after it is done the game is now compiled with the atmospheric flight branch.
Now restart, and on restart log back into the "swg" user and open a terminal window (THESE ARE THE STEPS YOU USE TO START YOUR SERVER AFTER STARTING THE SYSTEM EACH TIME)
Switch to the oracle user
`sudo -i -u oracle`
now login to sqlplus
`sqlplus i as sysdba`
wait for this to load then type
`startup`
wait for the service to start then type
`exit`
after it goes back to the oracle user type this to start the listener
`lsnrctl start`
once the listener has started we are ready to startup the server, go back to the main directory
`cd ~/swg-main'
and start the server using
`./startServer.sh`
this should start the server and when it says "cluster is ready for players" your server is good to go
Now to setup the client on another PC. This is what you will use to login to your server. I struggle for many weeks before I figured out the SWGSource client DOES NOT WORK with the atmospheric flight branch compiled. You will just crash it when you try to login.
Use either the SWG New Beginnings or SWG Evolve clients as those were both build by Rezec and he did an amazing job. I use NB but im sure both work with atmospheric flight.
Note: if you didnt install the atmospheric flight branch you CAN use the SWGsource client.
Download and install the client (NB linked below)
https://github.com/SWGNB/Client-exe
OR
https://www.swgevolve.com/SWGEvolveLauncher.7z
After you install the client you need to change the server address in the config file (login.cfg), as per below. Make this your static IP address of the server. 

![68747470733a2f2f692e696d6775722e636f6d2f4e363651344e562e6a7067](https://user-images.githubusercontent.com/125770994/224504809-02d6babe-e476-476c-912f-a5d84017edcb.jpg)
(Credit to SWGSource VM setup for this image)
 
After yous set the "LoginServerAdrdress" to your server address you can start the client. Double click SwgClient_r.exe. To login use "swg" as username and "swg" as password.
You should now be all set to play in your new server.
I will now discuss how to test/try the atmospheric flight feature.
Use the follow WIKI to setup God Mode, the QA tool, and the blue frog tool. Use the blue frog tool to generate ships and to set your pilot license to ACE for whatever faction you want. 
Then use a startship terminal to add all the ship components (w/o components the ship will not move in atmospheric flight). After you setup the ship at a starport you are ready to try atmospheric flight. 
Now its time to launch your ship in atmosphere. Go to your datapad and right click on the ship you just built. There should be a new button for "launch ship". Thats it! Your flying in atmosphere now.  Same process for landing ship from datapad, you will notice that your character gets stuck in space when you land your ship but this resolves itself in a few sections and resets your player to ground level.
Current the atmospheric flight is in its preliminary stages of development so things like combat damage, collision with building, and PvP combat have not been developed yet. As new features are added you can update the atmo branch (using the same steps above, checkout atmo branch, then ant compile the code again) and try them out.

When you are done playing on your server, go back to the main director in a new terminal window
`cd ~/swg-main`

then use this to stop the server prior to shutting down the PC

`ant stop`
