import os
import glob

######################################################################
# INPUT 
#runs_to_check = open("runListFall2018Part2.txt","r")

beam='10'



######################################################################
######################################################################

def get_files(base_dir,file_type):
    file_list=[]
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            #print file[-5:]
            if file.endswith(file_type):                
                #if file[:5] == 'data_':
                #    file=file[5:]
                #if file[:11] == 'calibration':
                #    file=file[11:]
                if file[-5:] == '.hipo':
                    file=file[:-5]
                #elif file[:8] == 'monitor_':
                #    file=file[8:]
                file_list.append(file)

    return file_list;

######################################################################
######################################################################

inDirLunds="/work/clas12/bclary/CLAS12/electron_studies/elastic/lund/elas_10gev_6_60_theta/"
inDirRecon="/work/clas12/bclary/CLAS12/electron_studies/elastic/sim/recon/elas_10gev_6_60_theta/"

lund_files=get_files(inDirLunds,".lund");
recon_files=get_files(inDirRecon,".hipo")
    
#get diff in file lists
not_reconstructed =list(set(lund_files) - set(recon_files)) 
    
print ' Files Recon %d out of %d lund files' %  (len(recon_files), len(lund_files))
print ' Number of files not reconstructed: %d ' % (len(not_reconstructed))
resub_files = open('files_resub_'+beam+'_txt','w')

# sort the files not reconstructed to get the ones that are consecutive to the reconstrcuted ones
sort_not_reconstructed = sorted(not_reconstructed)        

f_resub_counter=0
for f in sort_not_reconstructed:
    #print 'adding file %s to resubmission file' % (f)
    resub_files.write(f+'\n')
    f_resub_counter+=1
    
resub_files.close()
print ' will need to resubmit %d files ' % (f_resub_counter)
    

