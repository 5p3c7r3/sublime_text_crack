#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit
fi

if [ "$1" != "" ]; then
	SUBL_PATH=$1
else
	SUBL_PATH=/opt/sublime_text/sublime_text
fi

if [ ! -f $SUBL_PATH ]; then
	echo "$SUBL_PATH is not found"
	exit
elif [ ! -x $SUBL_PATH ]; then
	echo "$SUBL_PATH is not a valid sublime_text binary"
	exit
fi

VER=`exec $SUBL_PATH -v | sed -e 's/^.*[^0-9]//g'`
ARCH=`uname -m`

case $VER in
3132)
	case $ARCH in
	x86_64)
		OFFSET=0xe119
		VALUE=95
		;;
	*)
		echo "Not supported Linux architecture"
		exit
	esac
	;;
3126)
	case $ARCH in
	x86_64)
		OFFSET=0xc62e
		VALUE=95
		;;
	*)
		echo "Not supported Linux architecture"
		exit
	esac
	;;
3124)
	case $ARCH in
	x86_64)
		OFFSET=0xc668
		VALUE=95
		;;
	*)
		echo "Not supported Linux architecture"
		exit
	esac
	;;
*)
	echo "Not supported Sublime Text version"
	exit
	;;
esac

printf "\x$VALUE" | dd seek=$(($OFFSET)) conv=notrunc bs=1 of=$SUBL_PATH

if [ $? -eq 0 ]; then
	echo "Sublime Text has been cracked successfully!"
else
	echo "Failed to crack Sublime Text"
fi
