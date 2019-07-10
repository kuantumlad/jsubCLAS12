import glob
import os
import sys, getopt


inDir=''
inputFileList = ''
inputRunNumber = ''
inputTorusPol = ''
inputSolenoidPol =''
outDir=''
inStub=''
extStub=''
jobName=''
in_resubmit=''
in_tag=''
in_gcard=''
resubmit=False

argv = sys.argv[1:]

try:
    opts, args = getopt.getopt(argv,"hl:r:t:s:i:o:p:e:n:a:T:g:",["fileList=","runNumber=","torusPol=","solenoidPol=","inDir=","outDir=","inStub=","extStub=","jobName=","resubmit=","tag=","gcard="])
except getopt.GetoptError:
    print 'run-clas12master.py -l <fileList> -r <runNumber> -t <torusPol> -s <solenoidPol> -i <inDir> -o <outDir> -p <inStub> -e <extStub> -n <jobName> -a <resubmit> -T <tag> -g <gcard>'
    sys.exit(2)
for opt, arg in opts:
    if opt == '-h':
        print 'run-clas12master.py -l <fileList> -r <runNumber> -t <torusPol> -s <solenoidPol> -i <inDir> -o <outDir> -p <inStub> -e <extStub> -n <jobName> -a <resubmit> -T <tag> -g <gcard>'
        sys.exit()
    elif opt in ("-l", "--fileList"):
        inputFileList = arg
    elif opt in ("-r", "--runNumber"):
        inputRunNumber = arg
    elif opt in ("-t", "--torusPol"):
        inputTorusPol = arg
    elif opt in ("-s", "--solenoidPol"):
        inputSolenoidPol = arg
    elif opt in ("-i", "--inDir"):
        inDir = arg
    elif opt in ("-o", "--outDir"):
        outDir = arg
    elif opt in ("-p", "--inStub"):
        inStub = arg
    elif opt in ("-e", "--extStub"):
        extStub = arg
    elif opt in ("-n", "--jobName"):
        jobName = arg
    elif opt in ("-a", "--resubmit"):
        in_resubmit = arg
    elif opt in ("-T", "--tag"):
        in_tag = arg
    elif opt in ("-g", "--gcard"):
        in_gcard = arg


if in_resubmit == "True":
    resubmit=True
    

# read in the files list
infile = open(inputFileList)

l_infile = []
for f in infile:
    print f
    l_infile.append(f)

# split files into N groups
# implelemt later inplace of resubmit
farm_scaling_int=10
group_file_list = [l_infile[i * farm_scaling_int:(i + 1) * farm_scaling_int] for i in range((len(l_infile) + farm_scaling_int - 1) // farm_scaling_int )]

print group_file_list


n_files = len(open(inputFileList).readlines(  ))
n_jobs=1

if n_files > 10 :
    n_jobs = n_files/10

print ' Need to make %d jobs for %d ' % (n_jobs, n_files)
min_file=0
max_file=10

for j in range(0,n_jobs):
    print ' creating jsub for job %d ' % (j)

    
    jsub_script = open("/work/clas12/bclary/CLAS12/simulation/farm/batch_jobs/"+jobName+"/jsub_script_"+in_tag+"_"+str(j)+".jsub","w")
    jsub_script.write("JOBNAME:  bc" + jobName + str(j) + " \n")
    jsub_script.write("OS:       centos7"+ " \n")
    jsub_script.write("TRACK:    simulation"+ " \n")
    jsub_script.write("MEMORY:   5 GB"+ " \n")
    jsub_script.write("PROJECT:  clas12"+ " \n")
    jsub_script.write("NODE_TAG: farm18" + " \n")
    jsub_script.write("COMMAND: run-master " + inputRunNumber + " " + inputTorusPol + " "+ inputSolenoidPol + " input.lund " + os.path.basename(in_gcard) + " \n" )
    jsub_script.write("OTHER_FILES: "+ " \n")    
    jsub_script.write(in_gcard + " \n")
    jsub_script.write("/w/hallb-scifs17exp/clas12/bclary/CLAS12/simulation/farm/run_gemc"+ " \n")
    jsub_script.write("/w/hallb-scifs17exp/clas12/bclary/CLAS12/simulation/farm/run_decode"+ " \n")
    jsub_script.write("/w/hallb-scifs17exp/clas12/bclary/CLAS12/simulation/farm/run_recon"+ " \n")
    jsub_script.write("/w/hallb-scifs17exp/clas12/bclary/CLAS12/simulation/farm/run-master"+ " \n")
    jsub_script.write("OUTPUT_DATA: recon.hipo" + " \n")
    jsub_script.write("OUTPUT_TEMPLATE: " + outDir + "*.hipo "+ " \n")
    jsub_script.write("INPUT_DATA: input.lund "+ " \n")
    jsub_script.write("INPUT_FILES: "+ " \n")

    if resubmit == False:
        for f in range(min_file,max_file):
            print " min %d max %d " % (min_file, max_file)
            jsub_script.write(inDir+inStub+str(f)+ extStub + " \n")

    elif resubmit == True:
        for f in range(min_file,max_file): 
            print " resubmitting file %s " % str(l_infile[f])[:-1]
            jsub_script.write(inDir+str(l_infile[f][:-1])+" \n")
        

    min_file=min_file+10;
    max_file=max_file+10
        
    
    



