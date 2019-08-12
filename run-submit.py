import os
import glob

# setenv PATH /site/scicomp/auger-slurm/bin:$PATH


rootdir="/work/clas12/bclary/CLAS12/simulation/farm/batch_jobs/"
tag="CLAS12_7GeV"
for subdir, dirs, files in os.walk(rootdir):
    for file in files:
        #print os.path.join(subdir, file)
        filepath = subdir + os.sep + file

        if file.endswith(".jsub"):
            print 'Submitting file %s :'  % (file)
            os.system("jsub %s" % filepath)
            
