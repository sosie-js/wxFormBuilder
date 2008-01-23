#!/bin/bash

if [ -f wxformbuilder-*.orig.tar.gz ]
then
   echo "Please clean old source tarballs first"
   exit 1
fi

# get source tarball
debian/rules get-orig-source

#extract it
tar xzf wxformbuilder_*.orig.tar.gz

#determine version
changelog=`cd wxformbuilder_*.orig && dpkg-parsechangelog -linstall/linux/debian/changelog`
version=`expr match "$changelog" '.*Version: \([0-9]\.[0-9]\{1,2\}\.[0-9]\+\).*'`

#rename it
sourcedir=wxformbuilder-$version
mv wxformbuilder_*.orig $sourcedir

#move debian dir to base
cp -R  $sourcedir/install/linux/debian $sourcedir/debian

#save current dir
currentdir=`pwd`

#enter source dir
cd $sourcedir

#make debian source archive
dpkg-buildpackage -S -si -rfakeroot

#cleanup
cd $currentdir
rm -r $sourcedir
