#!/bin/bash
# on raspberry /sys/devices/platform
# on armbian /sys/devices/platform
# on nvidia-jetson /sys/devices/regulators and /sys/devices/pwm_regulators and /sys/devices/7000d000.i2c
find /sys/devices  -name microvolts -print  > microvolt.data 
echo "#!/bin/bash"
echo "#autocreated by microvolt-create.sh"
input="microvolt.data"
while read line
do
    echo "if [ -f $line ] ; then"
    comment=`echo $line | sed -e 's/\/sys\/devices\/platform\///' -e 's/\/regulator\/regulator//' -e 's/\/microvolts//' -e 's/ff[a-f0-9]*\.//' -e 's/\/i2c-0\///'`
    echo "  echo $comment";
    echo "  cat $line"
val=$(cat $line)
    echo "  #value $val"
    echo "fi"
    echo ""
done < "microvolt.data"
