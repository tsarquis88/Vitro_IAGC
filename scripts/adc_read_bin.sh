#!/bin/sh
BYTES=1

bash -c "cat $1 | od -v -tu1 -w$BYTES --address-radix=n"