#!/bin/bash

LOS=$(uname);

EXTRAS="extrahosts$LOS";

echo "Extras file on this system is $EXTRAS";

if [ $LOS = "Darwin" ]; then
	SECOND=$EXTRAS;
	FIRST="extrahostsLinux";
else 	
	SECOND=$EXTRAS;
  FIRST="extrahostsDarwin";
fi

if [ ! -z "$1" ]; then
    DOMAINX=$(echo $1 | cut -d"/" -f3 | cut -d":" -f1);
    echo "0.0.0.0 $DOMAINX" >> "$EXTRAS";
    echo "appended 0.0.0.0 $DOMAINX to $EXTRAS";
    DOMAINZ=$(echo $DOMAINX | rev | cut -d"." -f 1,2 | rev);
    if [ "$DOMAINX" != "$DOMAINZ" ]; then
        echo "0.0.0.0 $DOMAINZ" >> "$EXTRAS";
        echo "appended $DOMAINZ to $EXTRAS";
    fi
fi
if  cp ../hosts ./hosts_tmp.txt; then
    cat ../myhosts >> hosts_tmp.txt;
    cat $FIRST >> hosts_tmp.txt;
    cat $SECOND >> hosts_tmp.txt;
    #sudo cp hosts_tmp.txt /etc/hosts;
    #rm hosts_tmp.txt;
    if [ "$LOS" = "Darwin" ]; then
				sudo cp hosts_tmp.txt /etc/hosts;
        dscacheutil -flushcache; sudo killall -HUP mDNSResponder;
    		tail /etc/hosts;
    elif [ "$LOS" = "Linux" ]; then
	 		  sudo cp hosts_tmp.txt /etc/hosts;
        sudo /etc/init.d/dns-clean restart;
        echo "addn-hosts=/etc/hosts
        domain-needed" | sudo tee /etc/NetworkManager/dnsmasq.d/hosts.conf;
        sudo systemctl restart NetworkManager.service;
        sleep 2;
        UUID=$(nmcli -t -f uuid c | tail -1);
        nmcli connection up uuid "$UUID";
    		tail /etc/hosts;
    else #on windows
        cp hosts_tmp.txt  /c/Windows/System32/drivers/etc/hosts
				tail /c/Windows/System32/drivers/etc/hosts
    fi
    rm hosts_tmp.txt;

    echo "Hosts file updated";
else
    echo "No new hosts file found";
fi
