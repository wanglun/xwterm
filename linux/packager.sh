#!/bin/sh
#author Wang Lun
# package ipk with CONTROL(postins etc..) included
# Usage: packager.sh STAGE CONTROL

if [ $# -ne 2 ]
then
    echo "palm-package --help"
    exit 1
fi

palm-package $1
if [ $? -ne 0 ]
then
    exit 1
fi
CONTROL=$2
# insert the CONTROL files(postinst/preinst/postrm/prerm)
IPK=`ls *.ipk`
IPK_FILES=`ar t $IPK`
ar x $IPK
if [ -f $CONTROL/* ]
then
    CTRLS=`ls $CONTROL`
    gunzip control.tar.gz
    cp control.tar $CONTROL && cd $CONTROL
    tar --owner root --group root -r -f control.tar ./$CTRLS && mv control.tar .. && cd .. 
    gzip control.tar
fi
ar r $IPK $IPK_FILES
rm $IPK_FILES
