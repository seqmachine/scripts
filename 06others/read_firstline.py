#!/bin/python

#Aug 12, 2016

#for results of coverageBed -d, take only first line to reduce the file size

import sys

inputfile=sys.argv[1]

chr=""
start=""
chr_ref=""
start_ref=""


for line in open(inputfile, "r"):
	array=line.strip("\n").split("\t")
	chr, start=array[0], array[1]
	if chr != chr_ref or start != start_ref:
		print line.strip("\n")
	else:
		pass
	
	chr_ref=chr
	start_ref=start
 	
