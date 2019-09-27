#!/bin/env/python

#Sep 21, 2019


#declare constants:
#class I, exon 1 seq

C1Exon1="ATGGCCGTCATGGCGCCCAGAACCCTCCTCCTGCTACTCTCGGGGGCCCTGGCCCTGACCCAGACCTGGGCGG"





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
            #A*01:01:01:01
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
    deExon1Seq=""
    trimmedSeq=""

    #for class I genes, exon2+exon3
    coreLen=0
    if antigen.startswith("A"):
        coreLen=546
    elif antigen.startswith("B"):
        coreLen=546
    elif antigen.startswith("C"):
        coreLen=546

    #A*01:01: redundancy, take only one
    fourList=[]
    for key in sorted(faDict.keys()):
        gt=":".join(key.split(":")[:2])
        fourList.append(gt)

        if key.startswith(antigen) and fourList.count(gt) <2:
            print ">"+key
            rawSeq=faDict[key]
            if rawSeq.startswith("ATG"):
            #if rawSeq[:73]==C1Exon1:
                #rawSeq has exon 1
                deExon1Seq=rawSeq[73:] 
                #print deExon1Seq
            else:
                deExon1Seq=rawSeq

            if len(deExon1Seq) > coreLen:
                    trimmedSeq=deExon1Seq[:coreLen]
            else:
                trimmedSeq=deExon1Seq
            print trimmedSeq       
            #print len(trimmedSeq)     

    
        


if __name__=="__main__":
    main()
   


