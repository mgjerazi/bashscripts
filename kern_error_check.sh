#!/bin/bash
log show --predicate 'sender == "kernel"' --last 1h --style syslog | awk '
/^[0-9]{4}-[0-9]{2}-[0-9]{2}/ {
    if (entry ~ /(error|so_error): [^0]/) {
        print "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        print entry
        print "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    }
    entry = $0
    next
}
{ entry = entry " " $0 }
END {
    if (entry ~ /(error|so_error): [^0]/) {
        print "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        print entry
        print "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    }
}'
