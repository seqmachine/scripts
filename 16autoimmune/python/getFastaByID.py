#!/bin/env/python

#Sep 21, 2019


def readFa(infile):
    """
    >HLA:HLA00001_A*01:01:01:01_1098_bp
    ATGGCCGTCATGGCGCCCCGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACC
    CAGACCTGGGCGGGCTCCCACTCCATGAGGTATTTCTTCACATCCGTGTCCCGGCCCGGC
    """
    
    faDict={}
    fh=open(infile, "r")

    for line in fh:
        if line.startswith(">"):
            seqID=line.strip("\n").split("_")[1]
            if seqID not in  faDict:
                faDict[seqID]="" #initialize the dict
        else:
            faDict[seqID]=faDict[seqID]+line.strip("\n")
    fh.close()
    return faDict


def main():
    import sys
    
    #HLA-A*01============> A*01
    #HLA-B*02:01=========> B*02:01
    antigen=sys.argv[2]
    
    faDict=readFa(sys.argv[1])

    for key in faDict.keys():
        if key.startswith(antigen):
            print ">"+key
            print faDict[key]            

    
        


if __name__=="__main__":
    main()
   


