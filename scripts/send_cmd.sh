if [ "$1" = "reset" ] ; then
	CMD="f0"
else
	CMD="e0"
fi

echo -n -e \'\x$CMD\' > /dev/ttyUSB$2
