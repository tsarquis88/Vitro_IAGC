#!/bin/sh
DEV="/dev/ttyUSB0"
BYTES=1

sudo cat $DEV | od -v -tu1 -w$BYTES --address-radix=n
