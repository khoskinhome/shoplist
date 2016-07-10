#!/bin/bash -v


if [[ ! $1 ]]; then

    echo "you need to feed this script with the server hostname or ip address"
    exit 1

else
    PIHOST=$1
fi

#USER=pi
USER=root

PI_INSTALL_DIR=/opt/shoplist

# sanity checks to make sure we're in the correct place :
if [ ! -f install-to-vm.bash ]; then

    echo "can't find install-to-vm.bash you mush be running this script from the wrong dir"
    exit 1;

fi

if [ ! -d install ]; then

    echo "can't find dir 'install' you mush be running this script from the wrong dir"
    exit 1;

fi

echo "#############################################################"
echo "installing to $USER@$PIHOST:$PI_INSTALL_DIR"
echo "#############################################################"

cd ./install


#chmod 755 ./libpy/*.py
## chmod 755 ./hackingpython/*.py
#chmod 755 ./bin/*
#chmod 755 ./www-bin/*

ssh $USER@$PIHOST "if [ ! -d $PI_INSTALL_DIR ] ; then sudo mkdir -p $PI_INSTALL_DIR; fi;"
#
## make sure old files aren't hanging around , just to break things like pyc's can when the main py has been renamed :
ssh $USER@$PIHOST "rm \`find $PI_INSTALL_DIR | egrep \"\\.(py|pyc|pl|bash|sh|swp)$\"\`"
#

# not currently using libpy . so its excluded ....
# tar --exclude='./libpy' -zcf  - ./ | ssh $USER@$PIHOST "( cd $PI_INSTALL_DIR ; sudo tar zxvf - )"

echo "tar -zcf  - ./ | ssh $USER@$PIHOST '( cd $PI_INSTALL_DIR ; sudo tar zxvf - )'"
tar -zcf  - ./ | ssh $USER@$PIHOST "( cd $PI_INSTALL_DIR ; sudo tar zxvf - )"

