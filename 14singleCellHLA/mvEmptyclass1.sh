#!/bin/bash



mkdir -p empty3.22

for root in `ls *-ClassI-class.expression |cut -d "-" -f1`

do
    infile=$root"-ClassI-class.expression"
    if [ -s $infile ]; then
        echo "not empty"
    else
        echo $root" is empty!"
        mv $root* empty3.22
    fi
    
done




