#!/bin/bash
#install prerequisits
sudo apt -y install perl libhttp-daemon-perl libjson-perl libsnmp-extension-passpersist-perl librrds-perl libfile-which-perl 

sudo apt -y install libencode-locale-perl liblwp-mediatypes-perl libio-html-perl liburi-perl
sudo apt -y install libipc-sharelite-perl aptitude
#The logo file goes to web directory
#in my case  /usr/share/rpimonitor/web/img/
sudo cp orange_pi_logo.png /usr/share/rpimonitor/web/img

#example for orange pi 4
cp armbian-orangepi4.conf armbian.conf
#the *.conf files goes to the etc dir structure /etc/rpimonitor/tempate
sudo cp cpu.conf cpu2.conf storage2.conf storage.conf wlan2.conf /etc/rpimonitor/template
sudo cp armbian.conf temperature.conf temperature2.conf /etc/rpimonitor/template

#the symbolic link /etc/rpimonitor/data.conf shall point to /etc/rpimonitor/armbian.conf
sudo rm /etc/rpimonitor/data.conf
sudo ln -s /etc/rpimonitor/template/armbian.conf /etc/rpimonitor/data.conf

#the service shall be restarted
sudo systemctl stop rpimonitor
sudo systemctl start rpimonitor 
#or
#sudo service rpimonitor stop
#sudo service rpimonitor start
