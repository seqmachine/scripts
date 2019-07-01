#!/user/local/bin python
#May 27, 2019
#SNP annotation table is based on snpedia, openSNP etc. There are plus/minus strand issues, dbSNP at NCBI always use strand plus. So there is a need to transform.

import sys

#loci needs adjustments:
#lociList=["ht011801260","ht011018381","ht012143340","ht016265","ht011800497","ht011799913","ht011800012"]

#loci for SK02
#lociList=["sk021800896","sk021050450","sk02322458","sk02763035","sk02582757","sk024880","sk022153271","sk0217553719","sk02747650","sk021800566"]

infile=sys.argv[1]

#July 1, 2019 add one more argument
ptype=sys.argv[2]
#ptype, shell variable $type

if ptype=="ht01":
	#loci needs adjustments:
	lociList=["ht011801260","ht011018381","ht012143340","ht016265","ht011800497","ht011799913","ht011800012"]
elif ptype=="sk02":
	#loci for SK02
	lociList=["sk021800896","sk021050450","sk02322458","sk02763035","sk02582757","sk024880","sk022153271","sk0217553719","sk02747650","sk021800566"]
else:
	raise ValueError("product type is not assigned, error!")


transTable={"AA":"TT","TT":"AA","CC":"GG","GG":"CC","AC":"GT","AG":"CT","CT":"AG","GT":"AC"}
fh=open(infile, "r")
for line in fh:
	loci, geno=line.strip("\n").split("\t")
	if loci in lociList:
		geno_adj=transTable[geno]		
		print loci+"\t"+geno_adj
	else:
		print loci+"\t"+geno
fh.close()

