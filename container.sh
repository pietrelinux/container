#!/bin/sh
apt-get install -y debootstrap
mkdir debian
debootstrap --foreign stretch debian
> config.sh
cat <<+ >>  config.sh
#!/bin/sh
echo " Configurando debootstrap segunda fase"
sleep 3
/debootstrap/debootstrap --second-stage

echo "deb http://deb.debian.org/debian stretch main" > /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security/ stretch/updates main" > /etc/apt/sources.list 
echo "deb http://deb.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
echo "deb http://deb.debian.org/debian stretch-updates main contrib non-free" > /etc/apt/sources.list
echo "Reconfigurando parametros locales"
sleep 1
apt-get install locales
export LANG=C
dpkg-reconfigure locales
locale-gen es_ES.UTF-8
export LC_ALL="es_ES.UTF-8"
update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8 LC_MESSAGES=POSIX
dpkg-reconfigure locales
dpkg-reconfigure -f noninteractive tzdata
apt-get upgrade -y
echo "debian" >> /etc/hostname
apt-get -f install
mkdir /home
apt-get clean
adduser debian
addgroup debian sudo
addgroup debian adm
+
chmod +x config.sh
cp config.sh debian/home
chroot debian /bin/sh -i /home/config.sh && exit 
