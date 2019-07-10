#!/bin/bash

###################
##
## 
## Main Analyzer for CLAS12 analysis
## Allows users to specify analysis type:
## reconstruction or analysis.
## 
## Written by Brandon Clary
## Version 1.0 - 8/24/2017
##
##
##################


Opener (){

    echo "--------------------------- CLAS12 Analyzer ----------------------------"
    echo " "
    echo "  A shell script to easily submit jobs for reconstruction & analysis    "
    echo "                           By: Brandon Clary                            "
    echo "                              Version 1.0                               "
    echo " -----------------------------------------------------------------------"

}

UserPrompt (){

    echo ">> Are you submitting jobs for: "
    echo ">> generating events - GEN "
    echo ">> simulation events - SIM "
    echo ">> decoding events - DEC "
    echo ">> reconstructing events - REC "
    echo ">> Please type 'GEN', 'SIM', 'DEC', 'REC' or 'ANA' then press enter"
    read task
   
}

UserPromptSDR (){

    echo ">> Do you want to submit the jobs to the farm? Enter true or false: "
    read jsubmit

    echo ">> For pi0 generator type enter : "
    echo ">> 1 - aao_norad  "
    echo ">> 2 - aao_rad    "
    echo ">> 3 - fx_norad_phi "
    echo ">> 4 - markov_flat_accp "
    echo ">> 5 - markov_q4_accp "
    echo ">> 6 - markov_sin_accp "
    read genOption

#    genType=""
    if [ "$genOption" = "1" ]
    then
	genType="aao_norad"
	mcType="pi0mc"
    elif [ "$genOption" = "2" ]
    then
	genType="aao_rad"
	mcType="pi0mc"
    elif [ "$genOption" = "3" ]
    then
 	genType="fx_norad"
	mcType="phi"
    elif [ "$genOption" = "4" ]
    then
	genType="markov_flat"
	mcType="accp"
    elif [ "$genOption" = "5" ]
    then
	genType="markov_q4"
	mcType="accp"
    elif [ "$genOption" = "6" ]
    then
	genType="markov_sin"
	mcType="accp"
    fi
   
}


Opener
UserPrompt

if [[ "$task" == "SIM" ||  "$task" == "DEC" ||  "$task" == "REC" ]]
then
    UserPromptSDR
fi

if [ "$task" == "SIM" ];
then
    echo ">> Program will now execute SIMULATION script. "
    ./clas12simulation.sh $genType $mcType
elif [ "$task" == "DEC" ];
then
    echo ">> Program will now execute DECODER script. "
    ./clas12decoder.sh $genType $mcType
elif [ "$task" == "REC" ];
then
    echo ">> Program will now execute RECONSTRUCTION script. "
    ./clas12reconstruction.sh $genType $mcType
elif [ "$task" == "ANA" ];
then
    echo ">> Program will now execute ANALYSIS script. "
    ./clas12analysis.sh
fi

#merge feature will be added at a later date.
