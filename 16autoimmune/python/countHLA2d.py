#!/bin/env python
#HLA:HLA01593_DRA*01:02:02_765_bp	27704
#HLA:HLA06454_DRA*01:02:03_765_bp	24815
#HLA:HLA00663_DRA*01:02:01_683_bp	20737
#HLA:HLA06468_DRA*01:01:02_765_bp	19589
#HLA:HLA06470_DRA*01:01:01:03_765_bp	18082
#HLA:HLA00662_DRA*01:01:01:01_765_bp	18072
#HLA:HLA06469_DRA*01:01:01:02_765_bp	17452
#HLA:HLA01451_C*04:09N_1197_bp	11255
#HLA:HLA18604_S*01:03_268_bp	8187
#HLA:HLA06457_DMA*01:01:01:03_786_bp	5059

import sys
import operator
#from statistics import mean

def readCounts(file):
	'''
	bwa first round mapping against HLA cDNA reference is messy, needs to be cleaned by four digits
	input *.counts, output:
	{'DRB1*10:01': 3474, 'DRA*01:01': 8896, 'DRA*01:02': 8396}
	'''
	
	countList=[]
	typingDict={}

	fh=open(file, "r")
	for line in fh:
		title,count=line.strip("\n").split("\t")	
		array=title.split("_")[1].split(":")
		if len(array) >=2:
			hla=":".join(array[0:2]) #0,1, not reach 2
			
		else:
			hla=array[0]
			#print "##################"
	
		#collect all counts assigned to the same typing
		if hla not in typingDict.keys():
			
			typingDict[hla]=count
			#print typingDict
		else:
			#print hla
			typingDict[hla]=typingDict[hla]+","+count
		
		
	fh.close()

	#get mean
	for hla in typingDict.keys():
		L=[]
		for count in typingDict[hla].split(","):
			L.append(int(count))	
	
		typingDict[hla]=int(sum(L)/float(len(L)))

	return typingDict


def rankByAntigen(typingDict, antigen):
	'''
	summarize the 4 digits typing counts dict by antigen separately
	hla ref file messy, redundant, A01 may 500, A09 may 30 fasta files
	needs to be normalized
	no good	
	'''	 
	total=0
	byAntigenDict={}

	for key in typingDict.keys():
		x,y=key.split("*")
		if x==antigen:
			total+=typingDict[key]

	for key in typingDict.keys():
		x,y=key.split("*")
		if x==antigen:
			byAntigenDict[key]=round(float(typingDict[key])/float(total), 4)
	
	return byAntigenDict					




def Count2digts(typingDict, antigen):
	'''
	HLA-A, A1, A2...
	output {'DRA*01': 17292}	
	'''
	dictTwoDigt={}
	for key in typingDict.keys():
		x,y=key.split("*")
		if x==antigen:
			try:
				digt2,digt4=key.split(":")
				#print digt2
				if digt2 not in dictTwoDigt:
					dictTwoDigt[digt2]=typingDict[key]
				else:
					dictTwoDigt[digt2]+=typingDict[key]	
			except:
				
				if key not in dictTwoDigt:
					dictTwoDigt[key]=typingDict[key]
				else:
					dictTwoDigt[key]+=typingDict[key]
	return dictTwoDigt


def normalize2digits(dictTwoDigt, alleleStatFile):
	"""
	#2digits.alleles.stat
	#A*01    463
	#A*02    1220
	#A*03    497
	"""
	alleleDict={}
	dictTwoDigtNorm={}

	fh=open(alleleStatFile, "r")
	for line in fh:
		d2allele, total=line.strip("\n").split("\t")
		alleleDict[d2allele]=float(total)		
		
	for key in dictTwoDigt.keys():
		try:
			dictTwoDigtNorm[key]=round(float(dictTwoDigt[key])/float(alleleDict[key]),0)
		except:
			pass
	return dictTwoDigtNorm



def main():

	readsHit=sys.argv[1]	
	
	dict=readCounts(readsHit) #hla raw stat
	
	ag=sys.argv[2]

	dictA=Count2digts(dict, ag) #A, B, C,....

	dictANorm=normalize2digits(dictA,"../python/refData/2digits.alleles.stat")
	
	dictB=rankByAntigen(dictANorm, ag)
	

	#print dict
	#print rankByAntigen(dict, "DRA")
	#print dictA
	#print normalize2digits(dictA,"2digits.alleles.stat")
	
	for key, value in sorted(dictB.items(), key=lambda x: x[1], reverse=True):
		print key, value	


if __name__=="__main__":
	main()
