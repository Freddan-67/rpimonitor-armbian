#!/bin/bash
find /sys/devices/platform  -name microvolts -print  > microvolt.data 
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
