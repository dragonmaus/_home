#!/bin/sh

set -e

uid=$(id -u)

case $uid in
(0)
	crontab=/etc/crontab
	;;
(*)
	crontab=$HOME/etc/crontab
	;;
esac

rm -f $crontab.tmp
cp -p $crontab $crontab.tmp

${EDITOR:-vi} $crontab.tmp

fsync $crontab.tmp

if cmp -s $crontab.tmp $crontab
then
	print "vicron: $crontab.tmp unchanged"
	rm -f $crontab.tmp
else
	mv -f $crontab.tmp $crontab
fi
