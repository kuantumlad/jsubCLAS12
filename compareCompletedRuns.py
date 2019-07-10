import os
import glob

######################################################################
# INPUT 
runs_to_check = open("runListFall2018Check.txt","r")




baseDir="/volatile/clas12/clas12/data/calib/decoded/r" 
######################################################################
######################################################################

def get_files(base_dir):
    file_list=[]
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            #print file
            if file.endswith(".hipo"):                
                #if file[:5] == 'data_':
                #    file=file[5:]
                #if file[:11] == 'calibration':
                #    file=file[11:]
                if file[:5] == 'clas_':
                    file=file
                elif file[:8] == 'monitor_':
                    file=file[8:]
                file_list.append(file)

    return file_list;

######################################################################
######################################################################
n_completed_runs=0
n_nodecoded_runs=0
n_runs=0
for f in runs_to_check:
    #print f[:-1]

    # get files in decoded and reconstructed directories
    s_run = "00"+f[:-1]
    #inDirDecoded="/volatile/clas12/clas12/data/calib/decoded/r" + s_run #
    inDirDecoded="/work/clas12/rg-a/data/decoded/r" + s_run
    #inDirRecon="/w/hallb-scifs17exp/clas12/rg-a/production/recon/calib/v0/unfiltered/" + s_run 
    inDirRecon="/work/clas12/rg-a/production/recon/pass0/v0/mon/" + s_run + "/" 


    decoded_files=get_files(inDirDecoded);
    recon_files=get_files(inDirRecon)
 
    #get diff in file lists
    not_reconstructed =list(set(decoded_files) - set(recon_files)) 

 #   print ' Files Recon %d out of %d decoded files' %  (len(recon_files), len(decoded_files))
  #  print ' Number of files not reconstructed: %d ' % (len(not_reconstructed))
    resub_files = open('/w/hallb-scifs17exp/clas12/rg-a/software/clara_data/coatjava-5bp7p8/config/files_clas12-2_'+s_run+'.txt','w')
    
    # sort the files not reconstructed to get the ones that are consecutive to the reconstrcuted ones
    sort_not_reconstructed = sorted(not_reconstructed)        
    n_diff = 10 - len(recon_files)    

    #    if len(recon_files) > 5 and 
    if len(decoded_files) > 9:
        n_completed_runs+=1
        #print f[:-1]
    #elif len(recon_files) < 10 and len(decoded_files) > 1:
        #print f[:-1]
    elif len(decoded_files) <= 9:
        n_nodecoded_runs+=1
        print f[:-1]  

    f_resub_counter=0
    for ff in sort_not_reconstructed:
        if f_resub_counter < n_diff:
            #print ff
            #print 'adding file %s to resubmission file' % (f)
            resub_files.write(ff+'\n')
        f_resub_counter+=1

    resub_files.close()

    if len(decoded_files) > 1:
        n_runs+=1

print ' total number of completed runs is %d out of %d ' % (n_completed_runs,n_runs)
print ' total number of runs without decoded files is %d out of %d ' % (n_nodecoded_runs, n_runs)
