#!/bin/bash

help(){
    echo ""
    echo "COMMAND: bash subenum.sh [file-containing-root-domains]"
    echo ""
    echo "REQUIREMENTS: subfinder, amass, assetfinder, jq, anew, httpx"
    echo ""
}

domain_file=$1
if [[ $domain_file == "" ]]
then
    help
    exit
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
    cat subdomains.txt | grep -v "*" | tee subdomains.txt
    echo ""
    echo "total number of testing domains found: $(wc -l < subdomains.txt)"
    echo ""
}
domain_enum

httpx_scan(){
    rm -rf httpx_scan.txt
    echo ""
    echo "[+] httpx running..."
    echo ""
    cat subdomains.txt | httpx -silent -sc -mc 200,302,403,404 -title -td -location | anew httpx_scan.txt
    echo ""
    echo "total number of testing domains found: $(wc -l < httpx_scan.txt)"
    echo ""
}
httpx_scan
