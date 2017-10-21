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




def scanPairsII(refSeq, altSeq, pWeiMat):
	'''
	scan paired ref, alt seq for all motifs, ref, alt should have the same length and same genomic coordinates.
	scanPairsII("atgct", "aagct", [[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]])
	'''	
	diffList=[]
	altList=[]
	
	refScore=scoreFasta(refSeq, pWeiMat)
	altScore=scoreFasta(altSeq, pWeiMat)

	if len(refScore) == len (altScore):
		for index in range(len(refScore)): #what about indel???
			altList.append(round(altScore[index],3))
			diffList.append(round((refScore[index]-altScore[index]),3))# diff log ratio
	return [altList,diffList]



def getPValue(x, tlist, N=10000): #bug!!! #estimated p value
	'''
	get p value by permutation, nonparametric.
	getPValue(-10, [-3,2,3,3,3,-3,-3,5,9,-9,-9])
	'''
	countDict={}
	n=len(tlist)
	summ=0
	he=0
	for t in tlist:
		if not countDict.has_key(t):
			countDict[t]=1
		else:
			countDict[t]=countDict[t]+1
	#outdictSorted=sorted(outdict.items(), lambda x, y: cmp(abs(x[1]), abs(y[1])), reverse=True)
	tSorted=sorted(countDict.keys()) #not redundant
	#default ascending order, 1,2,3
	if x > tSorted[-1]:
		#max
		return 1/N #N=10,000, 0.0001
	elif x < tSorted[0]:
		#min
		return 1/N
	else:
		for t in tSorted:
			#print str(t)+"----------------"
			if x < 0 and x >= t:
				#print str(t)+"\t"+str(countDict[t])
				summ=summ+countDict[t]
			if x > 0 and x <=t:
				he=he+countDict[t]
				#print str(t)+"\t"+str(countDict[t])
		if x <0 :
			return round(float(summ)/n,4)
		elif x >0:
			return round(float(he)/n, 4)
								 	


def getMaxabs(list):
	max=0
	min=0
	for v in list:
		if v > max:
			max=v
		if v < min:
			min=v
	return [max, min]



def permutateScanPairs(refSeq, altSeq, pWeiMat, cutoff=0.5, N=10000): #use random, test!!!!
	'''
	permute N=1000 times of position weighted matrix of motif to compute distribution and p value of logRatio
	[[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]]
	permutateScanPairs("atgct", "aagct", [[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]], N=10)
	'''
	diffList=[]
	totalList=[]
	v=[]
	logR=0.0
	#fh=open(permDistri, "w")
	oriList=scanPairsII(refSeq, altSeq, pWeiMat)
	reducedOri=getMaxabs(oriList)
	for i in xrange(N):
		nrow=rm.randint(0,(len(pWeiMat)-1))
		v=pWeiMat[nrow]
		rm.shuffle(v)
		pWeiMat[nrow]=v	
		#		diffList.append(logR)# diff log ratio
		#		fh.write(str(logR)+"\n")
		diffList=scanPairsII(refSeq, altSeq, pWeiMat)
		totalList.append(getMaxabs(diffList)[0]) 
		totalList.append(getMaxabs(diffList)[1])
	#fh.close()
	alpha=getPValue(reducedOri[0], totalList, N)
	beta=getPValue(reducedOri[1], totalList, N)
	if alpha < cutoff or beta < cutoff:
		return {reducedOri[0]:alpha, reducedOri[1]:beta}



def mutatePWMStat(pWeiMat, N=10000): #get permutation based p value of logRatio, diff
	'''
	[[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]]
	mutatePWM([[0.9, 0.01, 0.02, 0.07], [0.07, 0.01, 0.02, 0.9]],10)

	'''
	#score perfect hit
	score=0.0
	for i in xrange(len(pWeiMat)):
		score=score+math.log(getMaxabs(pWeiMat[i])[0])
	#print score	
	mutScore=0.0
	
	diff=0.0
	allProb=[round(score,3)]
	diffList=[]
	for j in xrange(N):
		#nrow=rm.randint(0,(len(pWeiMat)-1))
		#v=pWeiMat[nrow]
		#rm.shuffle(v)
		#pWeiMat[nrow]=v	
		for i in xrange(len(pWeiMat)):
			pos=rm.randint(0,3)# a, c, g, t, random take one position
			mutScore=mutScore+math.log(pWeiMat[i][pos])#
		#print mutScore
		allProb.append(round(mutScore,3))# store all possible prob
		mutScore=0.0	
	
	for k in range((len(allProb)-1)):
		diff=allProb[k]-allProb[k+1]
		diffList.append(round(diff,3))	

	return [allProb,diffList]
		





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




def readFastaFile(infile, flankDistance):
	'''
	return {seqID:[ref, alt]}
	'''
	faDict={}
	pairedSeqList=[]

	for line in open(infile, "r"):
		line=line.strip("\n")
		if line.startswith(">"):
			seqID=line
		else:	
			seq=line
		
			pairedSeqList=compileFasta(seqID, seq, flankDistance)
		faDict[seqID]=pairedSeqList
	return faDict

		


def stepWiseScanMotif(seqID, pairedSeqList, motifDict, cutoff=0.5, N=100):
	'''
	input stepWiseScanMotif(seqID='>chr1_10333_C_T', pairedSeqList=['aaccccaaccccaaccccaaccctaacccctaaccctaaccctaaccctaccctaaccct', 'aaccccaaccccaaccccaaccctaacccTtaaccctaaccctaaccctaccctaaccct'], motifDict=readMotif("test.motifs"), cutoff=0.5, N=100)
	return {'>chr1_10333_C_T': {'ATGACTCATC_AP-1(bZIP)': {6.879: 0.2555, -6.179: 0.2675}, 'SCCTSAGGSCAW_AP-2gamma(AP2)': {-6.905: 0.2295, 6.841: 0.296}}
	'''
	eachDict=[]
	newMotifDict={}
	logRDict={}

	for motif in motifDict:
		eachDict=permutateScanPairs(pairedSeqList[0], pairedSeqList[1], motifDict[motif], cutoff, N)
		if eachDict: #if this returns value
			newMotifDict[motif]=motifDict[motif]						
			logRDict[motif]=eachDict
	return [seqID, pairedSeqList, newMotifDict, logRDict]




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
	cut=float(sys.argv[4])
	N=int(sys.argv[5])
	#default N=10000
	
	motifDict=readMotif(motifDB)
	#print motifDict
	#compute database:
	dbDict={}
	stat=[]
	for motif in motifDict:
		stat=mutatePWMStat(pWeiMat=motifDict[motif], N=N)
		dbDict[motif]=stat	
	#print len(dbDict)
	#print "#-------------------------------------------------------------------------------------------------"
	#print dbDict['CTTGGCACNGTGCCAA_NF1(CTF)'] # 3 min	
	
	#get fasta file dict, seqID:fasta
	faDict=readFastaFile(infile=faFile, flankDistance=flankD)
	
	for seqID in faDict:
	#seqID=">chr1_10180_T_C"
	#if seqID==">chr1_10180_T_C":
		print seqID
		pairs=faDict[seqID]
		#print pairs
		for motif in motifDict:
			try:
				scoreList=scanPairsII(refSeq=pairs[0], altSeq=pairs[1], pWeiMat=motifDict[motif])
				#print scoreList
				if scoreList !=[[], []]:
					#hitScore=getMaxabs(scoreList[0])[0] #max
					#print hitScore
					hitScore= max(scoreList[0])
					diffPerf=getMaxabs(scoreList[1])		
					refstat=dbDict[motif]
					a=getPValue(hitScore, refstat[0])
					b=getPValue(diffPerf[0], refstat[1])
					c=getPValue(diffPerf[1], refstat[1])
					#if a < cut:
					if b < cut or c < cut:
						try:
							print motif+"\t"+str(hitScore)+"\t"+str(a)+"\t"+str(diffPerf[0])+"\t"+str(b)+"\t"+str(diffPerf[1])+"\t"+str(c)
						except:
							pass
			except:
				pass

#python readMotifDatabase.py test.motifs test.fa 30 0.1 10000

if __name__=="__main__":
	main()	



