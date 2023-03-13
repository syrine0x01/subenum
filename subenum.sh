#!/bin/bash

# requirements: subfinder, amass, assetfinder, jq, anew, altdns, httpx

# command: 'bash subenum.sh [root domains list file] [dns list] [resolver list]'

help(){
    echo ""
    echo "COMMAND: bash subenum.sh [root domains list file] [dns list] [resolver list]"
    echo ""
    echo "if you don't specify [dns list] , [resolver list] , then subenum will use default list"
    echo ""
}

domain_file=$1
if [[ $domain_file == "" ]]
then
    help
    exit
fi

dnslist=$2
if [[ $dnslist == "" ]]
then
    dnslist="dns.txt"
fi

resolvers=$3
if [[ $resolvers == "" ]]
then
    dnslist="resolvers.txt"
fi

domain_enum(){
    rm -rf subdomains.txt
    echo ""
    echo "[+] subfinder running..."
    echo ""
    subfinder -silent -dL $domain_file | anew subdomains.txt
    echo ""
    echo "[+] assetfinder running..."
    echo ""
    cat $domain_file | assetfinder -subs-only | anew subdomains.txt
    echo ""
    echo "[+] amass running..."
    echo ""
    amass enum -passive -df $domain_file | anew subdomains.txt
    echo ""
    echo "[+] crt.sh running..."
    echo ""
    for url in $domain_file
    do
        json=$(curl -s https://crt.sh/\?q\=$url\&output\=json)
        echo $json | jq -r '.[].common_name' | anew subdomains.txt
    done
}
domain_enum

resolving_domains(){
    rm -rf altdns.txt
    echo ""
    echo "[+] resolving domains..."
    echo ""
    altdns -i $domain_file -w $dnslist -d $resolvers -o altdns.txt
    cat altdns.txt subdomains.txt | grep -v "*" | anew subdomains.txt
    rm -rf altdns.txt
    echo ""
    echo "total number of subdomains found: $(wc -l < subdomains.txt)"
    echo ""
}
resolving_domains

httpx_scan(){
    rm -rf httpx_scan.txt
    echo ""
    echo "[+] httpx running..."
    echo ""
    cat subdomains.txt | httpx -sc -mc 200,302,403,404 -title -td -location | anew httpx_scan.txt
    echo ""
    echo "total number of testing domains found: $(wc -l < httpx_scan.txt)"
    echo ""
}
httpx_scan
