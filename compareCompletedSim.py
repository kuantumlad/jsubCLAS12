import os
import glob

######################################################################
# INPUT 

######################################################################
######################################################################

def get_files(base_dir):
    file_list=[]
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            print file[:-5]
            if file.endswith(".hipo") or file.endswith(".txt"):                
                #if file[:5] == 'data_':
                #    file=file[5:]
                #if file[:11] == 'calibration':
                #    file=file[11:]
                if file[-5:] == '.hipo':
                    file=file[:-5]
                elif file[:8] == 'monitor_':
                    file=file[8:]
                file_list.append(file)

    return file_list;

######################################################################
######################################################################
n_completed_runs=0
n_nodecoded_runs=0
n_runs=0


# get files in decoded and reconstructed directories

inDirLund="/work/clas12/bclary/clas12_lunds/phi/lunds/"
inDirRecon ="/work/clas12/bclary/CLAS12/phi_analysis/simulation/"

lund_files=get_files(inDirLund);
recon_files=get_files(inDirRecon)

#get diff in file lists
not_reconstructed =list(set(lund_files) - set(recon_files)) 

print ' Number of files not completed %d ' %(len( not_reconstructed ))

fout = open("resubmitSimPhi.txt","w+")
for f in not_reconstructed:
    print ' adding %s to list to reconstruct again ' % (f)
    fout.write( f + "\n")

fout.close()
