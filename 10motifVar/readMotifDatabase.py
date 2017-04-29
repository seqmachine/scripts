#!/usr/bin/env python


#read motif database into dictionary

#>ATGACTCATC	AP-1(bZIP)/ThioMac-PU.1-ChIP-Seq(GSE21512)/Homer	6.049537	-1.782996e+03	0	9805.3,5781.0,3085.1,2715.0,0.00e+00
#0.419	0.275	0.277	0.028
#0.001	0.001	0.001	0.997
#0.010	0.002	0.965	0.023
#0.984	0.003	0.001	0.012
#0.062	0.579	0.305	0.054
#0.026	0.001	0.001	0.972
#0.043	0.943	0.001	0.012
#0.980	0.005	0.001	0.014
#0.050	0.172	0.307	0.471
#0.149	0.444	0.211	0.195
#>SCCTSAGGSCAW	AP-2gamma(AP2)/MCF7-TFAP2C-ChIP-Seq(GSE21234)/Homer	6.349794	-24627.169865	0	T:26194.0(44.86%),B:5413.7(9.54%),P:1e-10695

import sys
import gzip
import math
import random as rm

def readMotif(infile):
	pWM=[]
	motifDict={}
	idLine=""
	i=0
	value=[]
	countDict={}
	for line in open(infile):
		line=line.strip("\n")
		if line.startswith(">"):
			idLine=line
		elif line.startswith("0"):
			a, c, g, t=line.split("\t")
			plist=[float(a), float(c), float(g), float(t)]
			array=idLine.split("\t")
			tfID=array[1].split("/")[0]
			key=array[0].split(">")[1]+"_"+tfID
			if key not in motifDict:
				motifDict[key]=plist
				k=1
			else:
				if k==1:
					value.append(motifDict[key])
					value.append(plist)
					k=k+1
					motifDict[key]=value
					value=[]
				else:		
					for v in motifDict[key]:
						value.append(v)
					value.append(plist)
					motifDict[key]=value
					value=[]
	return motifDict	



def scoreFasta(seq, pWeiMat):
	'''
	Given a fasta sequence, score per locus based on PWM
	scoreFasta("atgct",[[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]])
	'''
	lenSeq=len(seq)
	lenMotif=len(pWeiMat) #list
	
	score=[]

	if lenSeq >= lenMotif:
		i=lenMotif
		start=0
		while (i<=lenSeq):
			window=seq[start:i]
			#print window
			s=0
			for j in range(len(window)):
				base=window[j:(j+1)]
				if base.upper()=="A":
					s=s+math.log(pWeiMat[j][0])			
				elif base.upper()=="C":
					s=s+math.log(pWeiMat[j][1])
				elif base.upper()=="G":
					s=s+math.log(pWeiMat[j][2])
				elif base.upper()=="T":	
					s=s+math.log(pWeiMat[j][3])

			score.append(s)
			s=0
			i=i+1
			start=start+1

		return score




def scanPairs(refSeq, altSeq, motifDict):
	'''
	scan paired ref, alt seq for all motifs, ref, alt should have the same length and same genomic coordinates.
	scanPairs("atgct", "aagct", {">motif1":[[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]]})
	'''	
	diffList=[]
	logRDict={}
	
	for id in motifDict:
		refScore=scoreFasta(refSeq, motifDict[id])
		altScore=scoreFasta(altSeq, motifDict[id])

		if len(refScore) == len (altScore):
			for index in range(len(refScore)): #what about indel???
				diffList.append(round((refScore[index]-altScore[index]),2))# diff log ratio
				
		logRDict[id]=diffList
		diffList=[]

	return logRDict



def getMaxabs(list):
	max=0
	min=0
	for v in list:
		if v > max:
			max=v
		if v < min:
			min=v
	return [max, min]



def permutateScanPairs(refSeq, altSeq, pWeiMat, N=10000): #use random, test!!!!
	'''
	permute N=1000 times of position weighted matrix of motif to compute distribution and p value of logRatio
	[[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]]
	permutateScanPairs("atgct", "aagct", [[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]], N=10)
	'''
	diffList=[]
	totalList=[]
	for i in range(N):
		nrow=rm.randint(0,(len(pWeiMat)-1))
		v=pWeiMat[nrow]
		rm.shuffle(v)
		pWeiMat[nrow]=v	
		refScore=scoreFasta(refSeq, pWeiMat)
		altScore=scoreFasta(altSeq, pWeiMat)
		if len(refScore) == len (altScore):
			for index in range(len(refScore)): #what about indel???
				diffList.append(round((refScore[index]-altScore[index]),2))# diff log ratio
		totalList.append(getMaxabs(diffList))
		diffList=[]
	return totalList


#>chr1_10440_C_A
#cctaacccta accctaaccc taaccctaac ccctaaccctaaccctaaccctaaccctcg
#>chr1_544787_G_C
#CTCTGTGGCC AGCAGGCGGC GCTGCAGGAG AGGAGATGCCCAGGCCTGGCGGCCGGCGCA

###which position???
### test 3, instead of 30
### critical!!!
def compileFasta(seqID, seq, flankDistance):
	'''
	compileFasta(">chr1_544787_G_C", "CTCTGTGGCCAGCAGGCGGCGCTGCAGGAGAGGAGATGCCCAGGCCTGGCGGCCGGCGCA", 30)
	'''
	altSeq=""
	chrom, center, ref, alt=seqID.split("_")
	if len(ref) < flankDistance:
		if seq[(flankDistance-1):(flankDistance-1+len(ref))].upper() == ref.upper():
			left=seq[:(flankDistance-1)]
			right=seq[(flankDistance-1+len(ref)):]
			altSeq=left+alt+right
	else:
		print "Error! Only small Indel is considered!"
	return [seq, altSeq]	 



def readFastaFile(infile, flankDistance, motifDict):
	faDict={}
	for line in open(infile, "r"):
		line=line.strip("\n")
		if line.startswith(">"):
			seqID=line
		else:	
			seq=line
		
			pairedSeqList=compileFasta(seqID, seq, flankDistance)
			
			logRDict=scanPairs(pairedSeqList[0], pairedSeqList[1],motifDict)
			
			faDict[seqID]=logRDict
	return faDict




def removeZero(list):
	outdict={}
	i=0
	for x in list:
		if x==0:
			pass
		else:
			outdict[i]=x
		i=i+1
	if not outdict:
		outdict={"null":0}
	return outdict	



def reduceSortlogR(logRDict):
	'''
	{">seq1":{"motif1":[0,0,2,3,0,0]}}
	{1:8,2:9}
	'''
	reducedMotifDict={}
	
	
	for seqID in logRDict:
		motifDict=logRDict[seqID]
		for motif in motifDict:
			outdict=getMaxabs(motifDict[motif])
			reducedMotifDict[motif]=outdict		
			#outdictSorted=sorted(outdict.items(), lambda x, y: cmp(abs(x[1]), abs(y[1])), reverse=True)
			#abs highlight on diff
			#reducedMotifDict[motif]=outdictSorted[0]
		#motifDictSorted=sorted(reducedMotifDict.items(), lambda x, y: cmp(abs(x[1]), abs(y[1])), reverse=True)
		#logRDict[seqID]=motifDictSorted
		logRDict[seqID]=reducedMotifDict
		reducedMotifDict={}
	return logRDict



def main():
	motifDB=sys.argv[1]#gz file
	faFile=sys.argv[2] #fasta file
	flankD=int(sys.argv[3])
	
	motifDict=readMotif(motifDB)
	#print motifDict
	faDict=readFastaFile(faFile, flankD, motifDict)
	#print faDict
	#seqID=">chr1_10180_T_C" 
	#print seqID
	#print faDict[seqID]

	resDict=reduceSortlogR(faDict)
	#print resDict
	for seqID in resDict:
		print seqID
		for motif in resDict[seqID]:
			print motif+"\t"+"\t".join([str(v) for v in resDict[seqID][motif]])


if __name__=="__main__":
	main()	



