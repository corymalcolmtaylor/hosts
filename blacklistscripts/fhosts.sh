#!/bin/bash

LOS=$(uname);

EXTRAS="extrahosts$LOS";

echo "Extras file is $EXTRAS";


if [ ! -z "$1" ]; then
    DOMAINX=$(echo $1 | cut -d"/" -f3 | cut -d":" -f1);
    echo "0.0.0.0 $DOMAINX" >> "$EXTRAS";
    echo "appended 0.0.0.0 $DOMAINX to $EXTRAS";
    DOMAINZ=$(echo $DOMAINX | rev | cut -d"." -f 1,2 | rev);
    echo "0.0.0.0 $DOMAINZ" >> "$EXTRAS";
    echo "appended $DOMAINZ to $EXTRAS";
fi
if  cp ../hosts ./hosts_tmp.txt; then
    cat extrahosts >> hosts_tmp.txt;
    cat extrahostslinux >> hosts_tmp.txt;
    sudo cp hosts_tmp.txt /etc/hosts;
    rm hosts_tmp.txt;
    if [ "$LOS" = "Darwin" ]; then
        dscacheutil -flushcache; sudo killall -HUP mDNSResponder;
    elif [ "$LOS" = "Linux" ]; then
        sudo /etc/init.d/dns-clean restart;
        echo "addn-hosts=/etc/hosts
        domain-needed" | sudo tee /etc/NetworkManager/dnsmasq.d/hosts.conf;
        sudo systemctl restart NetworkManager.service;
        sleep 2;
        UUID=$(nmcli -t -f uuid c | tail -1);
        nmcli connection up uuid "$UUID";
    fi

    echo "Hosts file updated";
else
    echo "No new hosts file found";
fi
