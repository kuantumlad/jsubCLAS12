#!/bin/bash

JCOUNTER=1
DCOUNTER=1
DATLIMIT=250
SETFILES=/lustre/expphy/volatile/halla/sbs/bclary/dvcs/*.dat

if [ ! -e runGemcDVCS$JCOUNTER.jsub ]; then
    cp temprunGemcDVCS.txt runGemcDVCS$JCOUNTER.jsub
fi

for f in $SETFILES
do
    if [ $DCOUNTER -lt $DATLIMIT ]; then
	echo $f >> runGemcDVCS$JCOUNTER.jsub
    elif [ $DCOUNTER == $DATLIMIT ]; then
	echo $f >> runGemcDVCS$JCOUNTER.jsub	
	jsub runGemcDVCS$JCOUNTER.jsub
	let JCOUNTER=JCOUNTER+1
	cp temprunGemcDVCS.txt runGemcDVCS$JCOUNTER.jsub
	DCOUNTER=0
    fi    
    let DCOUNTER+=1
    return 0	
done

rm runGemcDVCS*.jsub

