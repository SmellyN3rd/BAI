lsblk -do NAME,SIZE
echo 
read -p 'Pick the drive to install to: ' DRIVE
DRIVE=/dev/$DRIVE
SWAPSIZE=+$(grep MemTotal /proc/meminfo | awk '{print $2 / 900000}')G

(
  echo o;

  echo n;
  echo;
  echo;
  echo;
  echo $SWAPSIZE;

  echo n;
  echo p;
  echo;
  echo;
  echo a;
  echo 1;

  echo w;
) | fdisk $DRIVE
