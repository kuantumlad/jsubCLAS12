#!/bin/bash

##################################################
##
##   Bash script to send jobs 
##   for clas12 analysis to farm.
##   Specifically for decoding simulated files.
##
##   By: Brandon Clary
##   Version 1.1 - 8/25/2017
##   
##   Note: Processes lund to final hipo file
##
##################################################

#SET VARIABLES 
dec=false
analysisType="DEC"
jsub_dir='/u/home/bclary/batch_submit/batch_jsubs/'

genType=$1
mcType=$2

sim_dir="/volatile/halla/sbs/bclary/clas12Analysis/SIMclas12/sim_""$genType""_""$mcType""/" #/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/SIMclas12/sim_fx_norad_phi/'

i=0

UserPrompt (){

    echo ">> Do you want to submit the jobs to the farm? Enter true or false: "
    read jsubmit

    echo ">> Run Number, Torus polarity, and Solenoid polarity must be specified."
    echo ">> Enter Torus polarity and then press Enter"
    read torusPolarity
    echo ">> Enter Solenoid polarity and then press Enter"
    read solenoidPolarity
    echo ">> Enter Run number and then press Enter"
    read runNumber
    
}

Confirm (){

    echo ">> Do you want to continue? Enter y or n."
    echo "   y - will create jsub files."
    echo "   n - will exit program."
    read proceed

    if [ "$proceed" = "y" ]
    then 
	# 0 = true
	return 0
    elif [ "$proceed" = "n" ]
    then
	# 1 = false
	return 1
    fi
}



CreateJSubs (){

    echo ">> Creating jsub file for $analysisType " 
    #NEED TO ADD LOOP HERE TO DIVIDE UP LUND FILES INTO N JOBS
    for eviofile in "$sim_dir"*.evio
    do
	jsubfile=$'job_'$i'_'$analysisType'_'$genType'_'$mcType'.jsub'
	echo "JOBNAME:  bc$analysisType""_"$i >> $jsubfile
	echo "OS:       centos7" >> $jsubfile
	echo "TRACK:    simulation" >> $jsubfile
	echo "MEMORY:   5120 MB" >> $jsubfile
	echo "PROJECT:  clas12" >> $jsubfile
	echo "COMMAND:  run_decode $runNumber $torusPolarity $solenoidPolarity $genType" >> $jsubfile
	echo " " >> $jsubfile
	echo "OTHER_FILES:" >> $jsubfile
	echo "/u/home/bclary/CLAS12/validation/farm/run_decode" >> $jsubfile
	#echo "/lustre/expphy/work/hallb/clas12/bclary/extras/coatjava-4a.8.2.tar" >> $jsubfile
	echo " " >> $jsubfile
	echo "OUTPUT_DATA: decoded.hipo" >> $jsubfile
	echo "OUTPUT_TEMPLATE: /lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/DCODEclas12/dec_""$genType""_""$mcType""/*.hipo " >> $jsubfile
	echo " " >> $jsubfile    
	echo "INPUT_DATA: $genType.evio" >> $jsubfile
	echo "INPUT_FILES:">> $jsubfile
	echo "$eviofile" >> $jsubfile
    #LOOP OVER FILES TO ADD AS INPUT FILES
    #WILL NEED MODIFICATIONS, probably a text of all files would work best
    #fdir="/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/SIMclas12/sim_$genType""_""$mcType/"
    #echo ">> IN $fdir"
    #jcounter=0
    #echo "$fdir"
    #for eviofile in "$fdir"*.evio
    #do
	#echo ">> Making jsub file for job type $analysisType for job $jcounter "
	#echo "$eviofile" >> $jsubfile
	#jcounter=$((jcounter+1))
    i=$((i+1))
    done
    
    MoveJSubs
}


MoveJSubs (){

    echo ">> $i Jobs have been created for submission to the farm"
    echo ">> Moving the jsubs to $jsub_dir"
    mv *.jsub $jsub_dir
}

SubmitJSubs (){

    cd $jsub_dir
    if [ $jsubmit = false ]
    then
	testfile=$(ls | head -1)
	echo ">> Testing submission of one job to farm for $analysisType"
	jsub $jsub_dir$testfile
    elif [ $jsubmit = true ]
    then
	echo ">> Submitting all jobs to farm"
	for f in "$jsub_dir"*"$analysisType"*"$genType"*.jsub
	do
	    echo "$f"
	    jsub $f
	done
    fi
    echo ">> Finished submitting jobs to farm"
}

UserPrompt
if Confirm
then
    CreateJSubs
    SubmitJSubs
fi

