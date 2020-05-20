# rpimonitor-armbian
rpimonitor for armbian devices.
I have created an adaption of the excellent work from https://github.com/XavierBerger/RPi-Monitor to adapt rpimonitor to my armbian devices

short file description
orange_pi_logo.png
cpu2.conf is for small/big cpu's with two different kind of cores, like rockchip rk3399
cpu2.debug.conf is a hint how I found out which sensors to use on orange pi 4B
cpu.conf is for one kind of core's cpu
temperature.conf is for SBC's with one sensor
temperature2.conf is for SBC's with two sensors
storage.conf is for SBC's with no memory card, but USB memory ext4 sda1.
storage2.conf is for SBC's with built in memory card, and USB memory ext4 sda1.
wlan2.conf is for SCB's with usb wifi and built in wifi (my orange pi prime was unstable for a long time so it has two wifi)
armbian.conf is the replacer for raspian.conf
uptime.conf replaced the word "raspbian" with "armbian"

To adapt to your own armbian device:
Voltage regulators intro:
If you have an armbian device I do not have, you can debug device tree and check for suspect voltage regulators.
Doing some statistics with them you could figure out how they work. For instance I needed only a day worth of statistics to figure out how the orange pi 4B sensors worked.
to find the suspected voltage regulators I run 
microvolt-create.sh > microvolt.sh
In microvolt.sh I get a list of voltage regulator for the device I am currently running.
For a device I do not own, you yourself have to run the command, check the file microvolt.sh.
The voltage regulators at 3V or higher do normally not have anything to do with the CPU.

Orange Pi 4B
For Orange Pi 4B there are 5 regulators at 800mV - 1200mV span.
Of these 2 goes to the cpu groups.
To find out which regulators was intresting I did run microvolt-create > microvolt.sh
I gathered all regulators giving below 1.5V (regulator 8,9,10,23,24)
I added them to a debug file cpu2.debug.conf, where I plotted all regulators against time.
Comparing the output of this debug file to the freqcuencies of the processor gave that regulator 10 was for the ARM A53:s and regulator 23 was used for ARM A72.

Orange Pi Prime
For Orange Pi Prime there is one regulator (was named regulator 5, name replaced to regulator 4)
Also the wifi network is unstable due to unstable driver. I have an USB network card added.
To get statistics from this added card, i comment out every line in /lib/udev/rules/73-usb-net-by-mac.rules

#Use MAC based names for network interfaces which are directly or indirectly
#on USB and have an universally administered (stable) MAC address (second bit
#is 0). Don't do this when ifnames is disabled via kernel command line or
#customizing/disabling 99-default.link (or previously 80-net-setup-link.rules)
#or if the interface name was provided by user-space.

#ACTION=="remove", GOTO="usb_net_by_mac_end"
#SUBSYSTEM!="net", GOTO="usb_net_by_mac_end"
#ATTR{name_assign_type}=="3", GOTO="usb_net_by_mac_end"

#IMPORT{cmdline}="net.ifnames"
#ENV{net.ifnames}=="0", GOTO="usb_net_by_mac_end"

#SUBSYSTEMS=="usb", NAME=="", \
#    ATTR{address}=="?[014589cd]:*", \
#    TEST!="/etc/udev/rules.d/80-net-setup-link.rules", \
#    TEST!="/etc/systemd/network/99-default.link", \
#    IMPORT{builtin}="net_id", NAME="$env{ID_NET_NAME_MAC}"
#LABEL="usb_net_by_mac_end"


Orange Pi PC+
For Orange Pi Pc+ there is on regulator, named regulator 5

For temperature sensors there can be one or several thermal sensors
They are all placed in /sys/devices/virtual/thermal/thermal_zone[0-9]/temp

There is one sensor on orange pi pc+. 

There are three sensors the file system of Orange Pi Prime, of which the 2 first works.

There are two working sensors on Orange Pi 4B

They purpose can be found in /sys/devices/virtual/thermal/thermal_zone[0-9]/type (gpu-thermal, soc-thermal or cpu-thermal)

A general rule is that keep your data names short. The rpimonitor seems to like max 8 character long names for statistics.

install
On armbian you need perl and some libraries
sudo apt -y install perl libhttp-daemon-perl libjson-perl libsnmp-extension-passpersist-perl librrds-perl libfile-which-perl 
sudo apt -y install libencode-locale-perl  liblwp-mediatypes-perl libio-html-perl liburi-perl

first install rpimonitor, you should select the right init. For debian I use systemV
testrun that rpimonitor do not crash because of I forgot to list a needed perl library by running it in foreground

sudo rpimonitord
if everything works you can access your armbiandevice

direct a web browser to the IP of your armbian device, port 8888
My router tells me devices with adress on my network if they are configured with avahi.
Activate avahi in armbian-config.
in my example http://192.168.1.11:8888

files
#orange_pi_logo.png should go to /usr/share/rpimonitor/web/img/
sudo cp orange_pi_logo.png /usr/share/rpimonitor/web/img/
#all the conf files shold go to /etc/rpimonitor/template
sudo cp *.conf /etc/rpimonitor/template
#the soft link /etc/rpimonitor/data.conf should be relinked to /etc/rpimonitor/template/armbian.conf
sudo rm /etc/rpimonitor/data.conf
sudo ln -s /etc/rpimonitor/template/armbian.conf /etc/rpimonitor/data.conf
#the service should be restarted
sudo systemctl rpimonitor stop
sudo systemctl rpimonitor start
you should edit /etc/

kill the foreground process and start the deamon
sudo systemctl rpimonitor start
check that the deamon runs
ps -e|grep rpimon
