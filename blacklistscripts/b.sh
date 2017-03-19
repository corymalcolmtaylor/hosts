#!/bin/bash

LOS=$(uname);

EXTRAS="extrahosts$LOS";

./batchfhosts.awk temp.urls >> "$EXTRAS";
./fhosts.sh;

echo 'this file should be populated in full with the copied trace from the chrome extension "link redirect trace"' > temp.urls;
