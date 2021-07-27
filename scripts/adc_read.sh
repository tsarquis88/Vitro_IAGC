#!/bin/sh
BYTES=1

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <USB-PORT> <DATA-TYPE>"
	echo "Example: $0 0 h"
	exit
fi

bash -c "cat /dev/ttyUSB$1 | od -v -t$21 -w$BYTES --address-radix=n"
