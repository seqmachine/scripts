#!/usr/bin/python
#TianR, tianremiATgamil.com
#Jan 5, 2017

#input must be sorted properly first!
#sort -k1,1 -k2,2n -k3,3n -k6,6 $id".mr" -o t

#meth pipe, .mr format
#chr22	29971	30072	FREDDYKRUEGER_0001:1:26:268:1868#0/2	0	-	AGGTTTAAGGTTTTTAAAATAGTTGATATTTTTAAATTGGTTTTTTTGTATATTAAATTAAAGAAATTAGGTTTTTAAATTAAGGAAAATGAATGATAGTT	e_ab_adg_ggggagec]c]_ab^bageggggggggggbggggfgggggegbggggegfgggggffegfggggggggebefdgggggeegggggffebggg
#chr22	29976	30077	FREDDYKRUEGER_0001:1:26:268:1868#0/1	0	-	GATTTAGGTTTAAGGTTTTTAAAATAGTTGATATTTTTAAATTGGTTTTTTTGTATATTAAATTAAAGAAATTAGGTTTTTAAATTAAGGAAAATGAATGA	ggggggfghgggggghgggggggggggggggggggggggcgggggggggggggggggggggggggdgfgdggggcgegggggdggggggPecgWgePefeg

import sys

def keepOne(infile):
	fh=open(infile, "r")
	marker=""
	for eachline in fh:

		line=eachline.split("\t")
		chrom=line[0]
		start=line[1]
		end=line[2]
		strand=line[5]

		new="_".join([chrom, start, end, strand])
		#print marker
		if new != marker:
			print eachline.strip("\n")
			marker=new
		else:
			pass



def main():
	keepOne(sys.argv[1])



if __name__=="__main__":
	main()
