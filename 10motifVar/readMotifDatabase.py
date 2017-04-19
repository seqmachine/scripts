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


def readMotif(infile):
	pWM=[]
	motifDict={}
	idLine=""
	i=0
	for line in gzip.open(infile):
		line=line.strip("\n")
		if line.startswith(">"):
			idLine=line
		elif line.startswith("0"):
			a, c, g, t=line.split("\t")
			plist=[float(a), float(c), float(g), float(t)]
			if idLine not in motifDict:
				motifDict[idLine]=plist
			else:
				motifDict[idLine]=[motifDict[idLine], plist]
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
















