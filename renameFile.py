import os
import glob

#SET FILE LOCATIONS

#directory = "/volatile/halla/sbs/bclary/clas12Analysis/LUNDclas12/markov_sin_accp/" 
directory = "/volatile/halla/sbs/bclary/clas12Analysis/DCODEclas12/dec_markov_sin_accp/"

for f in os.listdir(directory):
    print f
    #os.rename(directory + f, directory + f + ".txt");
    os.rename(directory + f, directory + f.strip(".txt.evio.hipo.hipo") + ".hipo")
    
