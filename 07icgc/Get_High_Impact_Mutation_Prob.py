#Tian R. <tianremiATgmail.com>
#Dec 12, 2015
#RPL10   ribosomal protein L10   chrX:153618315-153637504        Proteincoding   2/193   SKCM-US:1/335|STAD-US:1/289     2

#icgc mutation with high impact, likely deleterious, cancer gene census COSMIC database

import sys, math

def parseLine(line):

    gene2AllDict={}

    line=line.strip("\n").split("\t")
    gene=line[0]
    fullName=line[1]
    chrPos=line[2]
    probSet=line[5]
    gene2AllDict[gene]=[fullName, chrPos, probSet]

    return gene2AllDict



def getProbByProj(probSet, N): 

    #only take into account population size over 100
    cancer2prob={}
    eachProj=probSet.split("|")
    for pair in eachProj:
        cancer, num=pair.split(":")
	x, y=num.split("/")
	prob=float(x) / float(y)
        if float(y) >= N:
	    cancer2prob[cancer]=round(math.log(prob, 10), 3)
    if cancer2prob:
        return cancer2prob
        #only return dict if not empty
	

def main(inputFile, N=100):
    Dict={}
    fh=open(inputFile, "r")
    for line in fh:
        try:
    	    gene2AllDict=parseLine(line)
            for gene in gene2AllDict.keys():
	        cancer2prob=getProbByProj(gene2AllDict[gene][2], N)
                if cancer2prob:
                    Dict[gene]=cancer2prob
        except:
            print "Error, unusual data format!"
            pass 
    
    fh.close()
    return Dict 


if __name__=="__main__":
    Dict=main(sys.argv[1], float(sys.argv[2]))
    print Dict    
	
