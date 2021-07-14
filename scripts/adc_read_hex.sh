#!/bin/sh
BYTES=1

bash -c "cat $1 | od -v -tx1 -w$BYTES --address-radix=n"
