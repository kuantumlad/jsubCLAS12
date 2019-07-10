import os
import glob

#USER MUST SET FILE LOCATIONS HERE
genType = "markov_sin_accp"
simparameters = "tm1sp1"
file_prefix = "sinLund"
files_to_reconstruct = "/lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/DCODEclas12/dec_"+genType+"/"
print " >> file to recon location " + files_to_reconstruct 

file_type = "*.hipo"


#SET NUMBER OF CLARA LIST TO CREATE


n_list = 5

print files_to_reconstruct+file_type

for name in os.listdir(files_to_reconstruct):
    if os.path.isfile(name):
        #print "hi"

        print name

n_files = len([name for name in os.listdir(files_to_reconstruct) if os.path.isfile(os.path.join(files_to_reconstruct,name))])

n_files_per_list = n_files/n_list
print(" NUMBER OF FILES PER LIST %d" %n_files_per_list ) 

if n_files_per_list > 0 :
    

    print "NUMBER OF FILES" 
    print n_files

    i = 0;
    k = 0;
    while i <= n_list:

        print("LIST %d"%(i) )
        print( " >>  MAKE LIST NUMBER %d HERE"%i  )
        list_file_name = "files_" + str(i) + ".list";
        print list_file_name
        list_file = open(list_file_name, "w+")

        clara_file = open("CLARA_config_" + str(i) + ".clara", "w+")
        clara_file.write("set servicesFile /lustre/expphy/work/halla/sbs/bclary/extras/myClara/plugins/clas12/config/services.yaml" + "\n");
        clara_file.write("set fileList /lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/CLARA_LISTS/files_" + str(i) + ".list" + "\n")
        clara_file.write("set inputDir /lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/DCODEclas12/dec_" + genType + "\n" )
        clara_file.write("set outputDir /lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/RECclas12/rec_" + genType + "\n")
        clara_file.write("set logDir /lustre/expphy/volatile/halla/sbs/bclary/clas12Analysis/RECclas12/rec_" + genType + "/" + "log" + "\n")
        clara_file.write("set threads 32" + "\n")
        clara_file.write("set description " + simparameters + "\n")
        clara_file.write("set javaMemory 2" + "\n")
        clara_file.write("set farm.cpu 16" + "\n")
        clara_file.write("set farm.time 1440" + "\n")

        j = 0;
        while j <= n_files_per_list:
            print (" ADD FILE %d HERE" %k )
            #recon_file = file_prefix + str(k) + ".txt.evio.hipo"
            new_recon_file =  file_prefix + str(k)+ ".hipo"        
            if os.path.exists(files_to_reconstruct + new_recon_file) or os.path.exists(files_to_reconstruct + new_recon_file):
                print " >> EXISTS " + files_to_reconstruct + new_recon_file 
                print new_recon_file
                #print " >> RENAMING FILE "
                #os.rename(files_to_reconstruct + recon_file, files_to_reconstruct + "phi_lund_" + str(k) + ".hipo")    
                list_file.write(new_recon_file + "\n")

            j=j+1
            k = k+1
        i=i+1


        list_file.close()
        clara_file.close()
