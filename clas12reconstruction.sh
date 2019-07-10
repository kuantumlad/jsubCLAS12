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
analysisType="REC"
jsub_dir='/u/home/bclary/batch_submit/batch_jsubs/'

genType=$1
mcType=$2
i=0
fdir="/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/DCODEclas12/dec_""$genType""_""$mcType/"

UserPrompt (){

    echo ">> Do you want to submit the jobs to the farm? Enter true or false: "
    read jsubmit

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
    for hipofile in "$fdir"*.hipo
    do
	echo "$hipofile"
	jsubfile=$'job_'$i'_'$analysisType'_'$genType'_'$mcType'.jsub'
	echo "JOBNAME:  bc$analysisType""_"$i >> $jsubfile
	echo "OS:       centos7" >> $jsubfile
	echo "TRACK:    simulation" >> $jsubfile
	echo "MEMORY:   10000 MB" >> $jsubfile
	echo "PROJECT:  clas12" >> $jsubfile
	echo "COMMAND:  ./run_recon $genType" >> $jsubfile
	echo " " >> $jsubfile
	echo "OTHER_FILES:" >> $jsubfile
	echo "/u/home/bclary/CLAS12/validation/farm/run_recon" >> $jsubfile
	#echo "/lustre/expphy/work/halla/sbs/bclary/extras/coatjava-4a.8.1.tar" >> $jsubfile
	echo "/lustre/expphy/work/hallb/clas12/bclary/extras/coatjava-4a.8.2.tar" >> $jsubfile
	echo " " >> $jsubfile
	echo "OUTPUT_DATA: reconstructed.hipo" >> $jsubfile
	echo "OUTPUT_TEMPLATE: /lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/RECclas12/rec_""$genType""_""$mcType""/*.hipo " >> $jsubfile
	echo " " >> $jsubfile    
	echo "INPUT_DATA: $genType.hipo" >> $jsubfile
	echo "INPUT_FILES:">> $jsubfile
	echo "$hipofile" >> $jsubfile
	#LOOP OVER FILES TO ADD AS INPUT FILES
	#WILL NEED MODIFICATIONS, probably a text of all files would work best
	#fdir="/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/DCODEclas12/dec_$genType""_""$mcType/"
	#echo ">> $fdir"
	#jcounter=0
	#for hipofile in "$fdir"*.hipo
	#do
	#echo ">> Making jsub file for job type $analysisType for job $jcounter "
	#echo "$hipofile" >> $jsubfile
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
	for f in "$jsub_dir"*"$analysisType"*.jsub
	do
	    echo "$f"
	    jsub $f
	done
    fi
#    rm job*.jsub
    echo ">> Finished submitting jobs to farm"
}

UserPrompt
if Confirm
then
    CreateJSubs
    SubmitJSubs
fi
