#Tian R. <tianremiATgmail.com>
#Dec 12, 2015
#RPL10   ribosomal protein L10   chrX:153618315-153637504        Proteincoding   2/193   SKCM-US:1/335|STAD-US:1/289     2

#icgc mutation with high impact, likely deleterious, cancer gene census COSMIC database

import sys, math, operator

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
	

#{"colon":-2, "brca":-1} ###should double check!!!!
def sumLogProbPerProj(geneList, metaTableDict):
    #
    sumDict={}
    for gene in geneList:
        if metaTableDict.has_key(gene):
            probDict=metaTableDict[gene]
            for cancer in probDict.keys():
                if not sumDict.has_key(cancer):
                    sumDict[cancer]=probDict[cancer]
                else:
                    sumDict[cancer]=sumDict[cancer]+probDict[cancer]
    #sort dict by value, output sorted tuples
    sumDict_sorted=sorted(sumDict.items(), key=operator.itemgetter(1))
    sumDict_sorted.reverse()#get descending order
    return sumDict_sorted



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
            #print "#Error, unusual data format!"
            pass 
    
    fh.close()
    return Dict 




if __name__=="__main__":
    Dict=main(sys.argv[1], float(sys.argv[2]))
    geneListfile=sys.argv[3]
    fh=open(geneListfile, "r")
    for line in fh:
        glist=line.split("\n")
    clist=sumLogProbPerProj(glist, Dict)
    for tu in clist:
	#math.pow()
	prob=round(math.pow(10, tu[1]),4)
        print tu[0]+"\t"+str(prob)



