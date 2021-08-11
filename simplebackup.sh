#!/bin/bash

# simplebackup.sh creates copy of files
# adding .bak to the filename
# example:
# simplebackup.sh filename1 filename2
# output:
# filename1.bak
# filename2.bak

# set changes bash behaviour
# -e fail whole script when one of commands fail
# -u fail if scripts uses variable never defined
# -x prints whole run of script
# -o pipefail  ($? variable set to last failed command in pipe)

set -euxo pipefail

dat=$(date +%F_%R)

for i in $(find /etc/ -iname \*.conf)
do
	if [[ -f ${i}.bak ]]
	then
		echo "Won\'t copy file ${i}.${dat}.bak"
		continue
	fi
	echo $i
	cp $i $i.bak
done
