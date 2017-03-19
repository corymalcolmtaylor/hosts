#!/usr/bin/awk -f
BEGIN {
    FS="/";
}
{
    if (NR > 1)
    {
        gsub(" ","",$0)
        if($3 != "")
        {
            print "0.0.0.0 " $3
        }
    }
}
