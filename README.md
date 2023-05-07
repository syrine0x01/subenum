# SubEnum

my custom subdomain enumeration tool

## Pre-Requirements
- subfinder
- amass
- assetfinder
- jq
- anew
- httpx

## Installing Pre-Requirements
```
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/owasp-amass/amass/v3/...@master
go install -v github.com/tomnomnom/assetfinder@latest
sudo apt install jq -y
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
```

## Setting Up Commands
```
sudo cp ~/go/bin/* /usr/local/bin/
```

## Command
`subenum [file-containing-root-domains]`

## Install
```
git clone https://github.com/syrine0x01/subenum.git
cd subenum
bash subenum
```

## Ease Task
```
sudo chmod +x subenum
sudo mv subenum /usr/local/bin/
cd ..
rm -rf subenum
```
