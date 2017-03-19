#!/bin/python

##[weigs@rainbow test]$ head contig2chr.tab 
#NW_014804496.1	1
#NW_014804497.1	1
#[weigs@rainbow test]$ head test.gff3
##gff-version 3
##sequence-region NW_014804496.1 1 501166
##species https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=9544
#NW_014804496.1	RefSeq	region	1	501166	.	+	.	ID=id0;Dbxref=taxon:9544;Name=1;chromosome=1;country=USA: Southwest National Primate Research Center at the Southwest Foundation for Biomedical Research%2C San Antonio%2C TX;gbkey=Src;genome=genomic;isolate=17573;mol_type=genomic DNA;note=derived from Indian origin rhesus;sex=female

import sys

table=sys.argv[1]
gffFile=sys.argv[2]

def getTable(input):
	dict={}
	fh=open(input, "r")
	for line in fh:
		contig, chr=line.strip("\n").split("\t")
		dict[contig]=chr
	return dict


fh2=open(gffFile, "r")
dict_con2chr=getTable(table)

for line in fh2:
	line=line.strip("\n")
	array=line.split("\t")
	if line.startswith("#"):
		pass
	if line.startswith("NW"):

		array[0]=dict_con2chr[array[0]]
		print ("\t").join(array)


	
	
