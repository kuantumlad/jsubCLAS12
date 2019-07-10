#!/bin/bash

##################################################
##
##   Bash script to send jobs 
##   for clas12 analysis to farm.
##   
##
##   By: Brandon Clary
##   Version 1.1 - 8/24/2017
##   
##   Note: Processes lund to final hipo file
##
##################################################

#SET VARIABLES 
rec=false
analysisType="SIM"
jsub_dir='/u/home/bclary/batch_submit/batch_jsubs/'
fx_phi_lund="/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/LUNDclas12/fx_norad_phi/" #/lustre/expphy/volatile/clas12/fxgirod/phi/lund/"

genType=$1
mcType=$2
i=0

markov_accp_lund="/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/LUNDclas12/$genType""_""$mcType""/"

UserPrompt (){

    echo ">> Do you want to submit the jobs to the farm? Enter true or false: "
    read jsubmit

    fdir="/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/LUNDclas12/$genType""_""$mcType"
    echo "$fdir"    
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
    for lundfile2 in "$markov_accp_lund"*.txt
    #while [ $i -lt 250 ]
    do
    jsubfile=$'job_'$i'_'$analysisType'_'$genType'_'$mcType'.jsub'
    echo "JOBNAME:  bc$analysisType""_"$i >> $jsubfile
    echo "OS:       centos7" >> $jsubfile
    echo "TRACK:    simulation" >> $jsubfile
    echo "MEMORY:   6144 MB" >> $jsubfile
    echo "DISK_SPACE: 6144 MB" >> $jsubfile
    echo "PROJECT:  clas12" >> $jsubfile
    echo "COMMAND:  ./run_gemc $genType" >> $jsubfile
    echo " " >> $jsubfile
    echo "OTHER_FILES:" >> $jsubfile
    echo "/u/home/bclary/CLAS12/validation/farm/run_gemc" >> $jsubfile
    echo " " >> $jsubfile
    echo "OUTPUT_DATA: sim" >> $jsubfile
    echo "OUTPUT_TEMPLATE: /lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/SIMclas12/sim_$genType""_""$mcType/*.evio " >> $jsubfile
    echo " " >> $jsubfile    
    echo "INPUT_DATA: $genType.txt" >> $jsubfile
    echo "INPUT_FILES:">> $jsubfile
    echo "$lundfile2" >> $jsubfile
    #LOOP OVER FILES TO ADD AS INPUT FILES
    #WILL NEED MODIFICATIONS, probably a text of all files would work best
#    fdir="/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/LUNDclas12/$genType""_""$mcType/"
#    jcounter=0
#    for lundfile in "$fdir"*.lund
#    do
#	echo ">> Making jsub file for job type $analysisType for job $jcounter "
#	echo "$lundfile" >> $jsubfile
#	jcounter=$((jcounter+1))
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
	for f in "$jsub_dir"*"$analysisType"*.jsub
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
