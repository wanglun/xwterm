#!/bin/bash

#######################################################################
### List your source files here                                     ###
### SRC="<source1> <source2>"                                       ###
#######################################################################
export SRC="terminalmain.cpp sdl/sdlcore.cpp sdl/sdlterminal.cpp terminal/seqparser.cpp terminal/terminalconfigmanager.cpp terminal/terminal.cpp terminal/terminalstate.cpp terminal/vtterminalstate.cpp util/configmanager.cpp util/databuffer.cpp util/logger.cpp util/point.cpp"

#######################################################################
### List the libraries needed.                                      ###
### LIBS="-l<libname>"                                              ###
#######################################################################
export LIBS="-lSDL -lpdl -lgles11 -lSDL_ttf -lSDL_image"

#######################################################################
### Name your output executable                                     ###
### OUTFILE="<executable-name>"                                     ###
#######################################################################
export OUTFILE="xwterm_plugin"

#######################################################################
### Name your output executable                                     ###
### OUTFILE="<executable-name>"                                     ###
#######################################################################
export MYCPPFLAGS=" -I../plugin/"


###################################
######## Do not edit below ########
###################################

###################################
######## Checking the setup #######
###################################

if [ ! "$PalmPDK" ];then
        export PalmPDK=/opt/PalmPDK
fi

CC="arm-none-linux-gnueabi-g++"
INCLUDEDIR="${PalmPDK}/include"
LIBDIR="${PalmPDK}/device/lib"
SYSROOT="${PalmPDK}/arm-gcc/sysroot"
PATH=$PATH:${PalmPDK}/arm-gcc/bin:${PalmPDK}/i686-gcc/bin

# Set the device specific compiler options. By default, a binary that
# will run on both Pre and Pixi will be built. These option only need to be
# set for a particular device if more performance is necessary.
if [ "$1" == "emulator" ]; then
	CC="i686-nptl-linux-gnu-gcc"
	LIBDIR=
	LIBDIR="${PalmPDK}/emulator/lib"
	SYSROOT="${PalmPDK}/i686-gcc/sys-root"
elif [ "$1" == "pre" ]; then
	DEVICEOPTS="-mcpu=cortex-a8 -mfpu=neon -mfloat-abi=softfp"
else 
	DEVICEOPTS="-mcpu=arm1136jf-s -mfpu=vfp -mfloat-abi=softfp"
fi

export BUILDDIR="Build_Device"

PATH=$PATH:${PalmPDK}/arm-gcc/bin

ARCH=""

INCLUDEDIR="${PalmPDK}/include"
CPPFLAGS="-I${INCLUDEDIR} -I${INCLUDEDIR}/SDL --sysroot=$SYSROOT"${MYCPPFLAGS}
LDFLAGS="-L${LIBDIR} -Wl,--allow-shlib-undefined"
SRCDIR="../plugin"
###################################

if [ -e "$BUILDDIR" ]; then
	rm -rf "$BUILDDIR"
fi
mkdir -p $BUILDDIR

if [ "$SRC" == "" ];then
	echo "Source files not specified. Please edit the SRC variable inside this script."
	exit 1
fi

if [ "$OUTFILE" == "" ];then
	echo "Output file name not specified. Please edit the OUTFILE variable inside this script."
	exit 1
fi
echo "Building for Device"
FILES=""
for i in $SRC
do
    FILES=${FILES}$SRCDIR/$i" "
done
echo "$CC $DEVICEOPTS $CPPFLAGS $LDFLAGS $LIBS -o $BUILDDIR/$OUTFILE $FILES"
$CC $DEVICEOPTS $CPPFLAGS $LDFLAGS $LIBS -o $BUILDDIR/$OUTFILE $FILES

echo -e "\nPutting binary into $BUILDDIR.\n"
