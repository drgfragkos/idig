#!/bin/bash

## idig.py - Dig all hosts from a Class D IP address to their domain names.                ##
## You may modify, reuse and distribute the code freely as long as it is referenced back   ##
## to the author using the following line: ..based on idig.py by @drgfragkos               ##

OCT3=$(echo $1 | sed 's/\(.*\)\..*/\1/') ##
NET=$OCT3

if [[ $NET.0 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && ! [[ $NET.1 =~ (^127\.)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.) ]]; then  ##simple IPv4 check, need a better regex for IPv4 validation
    #echo True
    for n in $(seq 1 254); do
    	ADDR=${NET}.${n}
    	echo -e "${ADDR}\t$(dig -x ${ADDR} +short)" | grep -E [a-zA-Z] | sed 's/[\.]$//' 
    	##Echo only the IP addresses which return with a domain and remove the tailing character if it is a dot (.)
    	##To echo the opposite lines (return no domain info), use: grep -v -E [a-zA-Z]
	done | tee idig_Log_${NET}.txt

else
    #echo False
    echo "Dig all hosts from a Class D IP address to their domain names."
    echo "Usage: $0 IPv4_Address"
    echo "   IPv4_Address    For IP: A.B.C.D, will attempt to resolve the domain name for"
    echo "                   each one of the 254 hosts in the given Class C IP address. "
    echo "                   Will not resolve Private IPs:   127.0.0.1"
    echo "                                                    10.0.0.0 - 10.255.255.255"
    echo "                                                  172.16.0.0 - 172.31.255.255"
    echo "                                                 192.168.0.0 - 192.168.255.255"

fi

