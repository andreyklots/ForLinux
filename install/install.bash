#!/bin/bash

##################################
# Define major system parameters #
##################################

# Which verssion of KDE to install?
# 0-none; 1-minimal; 2-full
KDEtype=1

# Sources list for apt
SourcesList="/etc/apt/sources.list"
# Version of Debian
DebianVersion="buster"



# not necessary
PythonVersion="Python3.7"

##################################









# Make files to input y/n
echo "n" > PRINT_n.TXT
echo "y" > PRINT_y.TXT
#########################

echo "1. MODIFYING APT SOURCE LIST..."
echo "   OLD LIST MOVED TO /etc/apt/sources.list_old"

if grep -Fxq "# ORIGINAL FILE MOVED TO " $SourcesList
then
    echo "    $SourcesList has already been backed up. skipping backup"
else	
    mv $SourcesList  "$SourcesList""_old"
fi

echo "# THIS FILE HAS BEEN MODIFIED BY install_stuff.sh - script" > $SourcesList
echo "# ORIGINAL FILE MOVED TO $SourceList""_old" > $SourcesList

echo "deb http://deb.debian.org/debian $DebianVersion main" >> $SourcesList
echo "deb-src http://deb.debian.org/debian $DebianVersion main" >> $SourcesList
echo "" >> $SourcesList
echo "deb http://deb.debian.org/debian-security/ $DebianVersion-security main" >> $SourcesList
echo "deb-src http://deb.debian.org/debian-security/ $DebianVersion-security main" >> $SourcesList
echo "" >> $SourcesList
echo "deb http://deb.debian.org/debian $DebianVersion-updates main" >> $SourcesList
echo "deb-src http://deb.debian.org/debian $DebianVersion-updates main" >> $SourcesList

apt update  < PRINT_y.TXT
apt upgrade  < PRINT_y.TXT

echo "1. DONE. APT SOURCES UPDATED."





echo "2. INSTALLING gcc..."
apt install gcc < PRINT_y.TXT
echo "2. DONE. gcc INSTALLED"

echo "3. INSTALLING make..."
apt install make < PRINT_y.TXT
echo "3. DONE. make INSTALLED"


echo "4. INSTALLING pip3/python..."
apt install python3-pip < PRINT_y.TXT
echo "4. DONE. pip3/python INSTALLED"


echo "5. INSTALLING Python modules..."
pip3 install --upgrade pip
pip3 install --upgrade Pillow
pip3 install numpy
pip3 install matplotlib
pip3 install scipy
pip3 install ipython
echo "5. DONE. Python modules INSTALLED"



#echo "6. INSTALLING kde..."
if (( KDEtype==0 ))
then
    echo "KDE INSTALATION NOT CHOSEN"
fi

if (( KDEtype==1 ))
then
    apt -y install kde-plasma-desktop plasma-nm 
fi

if (( KDEtype==2 ))
then
    apt -y install task-kde-desktop < PRINT_y.TXT
fi
echo "6. DONE. kde INSTALLED"








# Delete files for input of y/n
rm PRINT_n.TXT
rm PRINT_y.TXT
#########################


