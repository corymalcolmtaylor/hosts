#!/bin/bash

LOS=$(uname);

EXTRAS="extrahosts$LOS";

./fhostsbatch.awk temp.urls >> "$EXTRAS";
./fhosts.sh;
