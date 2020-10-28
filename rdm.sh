#!/bin/bash

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

echo '=======================Clone RDM repository======================='
git clone --recursive https://github.com/uglide/RedisDesktopManager.git rdm

echo "=======================Switch to latest tag: ${TAG}===================="
cd $SHELL_FOLDER/rdm
TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
echo 'switch to latest tag: '$TAG
cd $SHELL_FOLDER/rdm
git checkout -b $TAG $TAG

echo '=======================Build lz4======================='
cd $SHELL_FOLDER/rdm/3rdparty/lz4/build/cmake
cmake -DLZ4_BUNDLED_MODE=ON -DBUILD_SHARED_LIBS=ON --build .
ls
make -s -j 8


echo '=======================Modify RDM version======================='
cd $SHELL_FOLDER
python ./rdm/build/utils/set_version.py ${TAG} > ./rdm/src/version.h
cd $SHELL_FOLDER/rdm/src
echo 'backup rdm.pro'
cp rdm.pro rdm.pro.bak
echo 'modify rdm.pro'
sed -i "" "/^\( *\)VERSION=.*/s//\1VERSION=$TAG/" rdm.pro


echo '=======================Release Translations======================='
cd $SHELL_FOLDER/rdm/src
lupdate rdm.pro
lrelease -verbose rdm.pro


echo '=======================Install Python requirements======================='
mkdir -p $SHELL_FOLDER/rdm/bin/osx/release
cd $SHELL_FOLDER/rdm/bin/osx/release
cp -rf $SHELL_FOLDER/rdm/src/py .
cd py
echo six >> requirements.txt
sudo pip3 install -t . -r requirements.txt
sudo python3 -m compileall -b .
sudo find . -name "*.py" | sudo xargs rm -rf
sudo find . -name "__pycache__" | sudo xargs rm -rf
sudo find . -name "*.dist-info" | sudo xargs rm -rf
sudo find . -name "*.egg-info" | sudo xargs rm -rf


echo "=======================Build RDM ${TAG}======================="
cd $SHELL_FOLDER/rdm/src/resources
echo 'copy Info.plist'
cp Info.plist.sample Info.plist
cd $SHELL_FOLDER/rdm/src
qmake rdm.pro CONFIG-=debug
make -s -j 8


echo "=======================Copy Translations======================="
cd $SHELL_FOLDER/rdm/src
mkdir ../bin/osx/release/RDM.app/Contents/translations
cp -f ./resources/translations/*.qm ../bin/osx/release/RDM.app/Contents/translations
echo "OK!"

echo "=======================SUCCESS======================="
echo 'App file is:'$SHELL_FOLDER/rdm/bin/osx/release/RDM.app
