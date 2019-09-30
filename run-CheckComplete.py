import os

input_set = set()
cooked_set = set()

################################################################
## Files that are supposed to be processed in the text file
file_list = "mizak_gen_7gev.txt"
infile = open(file_list)
l_infile = []

for f in infile:
    input_set.add(f[:-1]);
    l_infile.append(f[:-1])#[:-5])



################################################################
## Files that are cookedd in sim
rootdir="/volatile/clas12/bclary/simulation_out/inclusive/7GeV/rad/"
#tag="CLAS12_7GeV"
for subdir, dirs, files in os.walk(rootdir):
    for file in files:
        #print os.path.join(subdir, file)
        filepath = subdir + os.sep + file

        if file.endswith(".hipo"):
            #print 'Submitting file %s :'  % (file[:-5])
            cooked_set.add(file[:-5])
            #os.system("jsub %s" % filepath)




files_no_cooked = input_set - cooked_set
print (" Number of files not cooked %d " % len(files_no_cooked))

for not_cooked in files_no_cooked:
    print not_cooked
