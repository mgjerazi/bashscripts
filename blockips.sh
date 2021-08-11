#!/bin/bash

set -euo pipefail

IFS='#'

INPUT="ipstoblock.txt"

while read -r ip comment
do
	echo "iptables -A INPUT -s $ip -m comment --commment $comment -j DROP"
done < "$INPUT"
