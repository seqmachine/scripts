#!/bin/user/env python

import sys

#Jan 21, 2019
#Jan 23, 2019 
#read vcf into user understandable SNP info
#May 9, 2019


#tianrMac:humanTalent tianr$ head -n2 25loci.txt 
#intergenic(CREB1 LOC151194)	ht014675690	2	207643083
#OXTR	ht0153576	3	8762685
#tianrMac:humanTalent tianr$ head -n2 ht01.fa
#>chr2:207642933-207643233
#agcaatctgcccgccttggcctcccaaagtgctgggattataggcgtgagtcaccatgcccggccTCAAACAcattttttctatccatatttactgggtgtcttttatcaagcagattctgtgttagatgctgaaacacaaaaaaagaacgaaacagaACAGATCAGACAAAAAAGTATTGGGAAACATACCCATCATTTCTTCCTCCTTCATGAATGTTTTTCAAGGATGATTCTAGAAGGAACTAGAGGAGTAGGTAACAGCAGCATTGATGGAAGATTCTGAGAGGCAGTAAGTCAC

#chr4:55435052-55435352  150     .       A       G       21.4243 .       AB=0.333333;ABP=4.45795;AC=1;AF=0.5;AN=2;AO=2;CIGAR=1X;DP=6;DPB=6;DPRA=0;EPP=3.0103;EPPR=11.6962;GTI=0;LEN=1;MEANALT=1;MQM=60;MQMR=60;NS=1;NUMALT=1;ODDS=4.92589;PAIRED=0;PAIREDR=0;PAO=0;PQA=0;PQR=0;PRO=0;QA=82;QR=164;RO=4;RPL=0;RPP=7.35324;RPPR=5.18177;RPR=2;RUN=1;SAF=1;SAP=3.0103;SAR=1;SRF=3;SRP=5.18177;SRR=1;TYPE=snp        GT:DP:AD:RO:QR:AO:QA:GL 0/1:6:4,2:4:164:2:82:-5.9735,0,-13.3437
#chrX:43731639-43731939  150     .       G       T       64.8189 .       AB=0;ABP=0;AC=2;AF=1;AN=2;AO=2;CIGAR=1X;DP=2;DPB=2;DPRA=0;EPP=3.0103;EPPR=0;GTI=0;LEN=1;MEANALT=1;MQM=60;MQMR=0;NS=1;NUMALT=1;ODDS=7.37776;PAIRED=0;PAIREDR=0;PAO=0;PQA=0;PQR=0;PRO=0;QA=81;QR=0;RO=0;RPL=2;RPP=7.35324;RPPR=0;RPR=0;RUN=1;SAF=1;SAP=3.0103;SAR=1;SRF=0;SRP=0;SRR=0;TYPE=snp    GT:DP:AD:RO:QR:AO:QA:GL 1/1:2:0,2:0:0:2:81:-7.68573,-0.60206,0
#SRR2192721.ht01.vcf (END)



def getSNPDict(infile):
	#infile is 25loci.txt, this file is ordered
	snpDict={}
	array=[]
	snpList=[] #the preset order is kept, ht01###,,,

	fh=open(infile, "r")
	for line in fh:
		array=line.strip("\n").split("\t")
		#array[1] is ht01####
		snpDict[array[1]]=["chr"+array[2],array[3],array[0]]
		snpList.append(array[1])
	fh.close()

	return [snpDict,snpList]


def readVCF(infile):
	fh=open(infile, "r")

	vcfDict={}
	for line in fh:
		array=line.strip("\n").split("\t")
		
		chrom=array[0]# chr3
		
		pos=array[1]# 8762685
		
		ref=array[3]#
		alt=array[4]#

		geno=array[9]
		GTList=geno.split(":")
		gt=GTList[0]#
		dp=GTList[1]
		

		if gt=="0/0":
			snp=ref+ref
		elif gt=="1/1":
			snp=alt+alt
		elif gt=="0/1" or gt=="1/0":
			if ref < alt:
				snp=ref+alt#"ACGT" in order
			else:
				snp=alt+ref
		else:
			snp="strange"
		
		vcfDict[chrom+":"+pos]=snp
		#vcfList.append([chrom+":"+pos, snp])

	return vcfDict



#"25loci.txt"
snpInfoFile=sys.argv[1]

a=getSNPDict(snpInfoFile)
snpDict=a[0]
snpList=a[1]

#"/Users/tianr/ncbi/public/sra/SRR2192721.ht01.vcf"
vcfFile=sys.argv[2]

vcfList=readVCF(vcfFile)

outDict={}
for snp in snpList:
	chrpos=snpDict[snp][0]+":"+snpDict[snp][1]
	if chrpos in vcfList.keys():
		outDict[snp]=vcfList[chrpos]

for i in range(len(snpList)):
	snp=snpList[i]
	if snp in outDict.keys():
		print snp+"\t"+outDict[snp]
	else:
		print snp+"\tNA"

