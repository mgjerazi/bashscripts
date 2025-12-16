#!/bin/bash
set -euo pipefail

servers=(www.wp.pl www.google.pl www.hgrdgfrdg.com)

for server in "${servers[@]}"; do
    if ping -c 1 -q "$server" &>/dev/null; then
        echo "Server $server is alive"
    else
        echo "Server $server is down"
    fi
done
