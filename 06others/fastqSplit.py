#/usr/bin/env python
#Jan 17, 2017
#Tian R. based on WeiGS and WangQ's script
#split combined paired end fq.gz file into r1, r2

#usage:
#python fastqSplit.py <combined.fq.gz> <name> 
#for example: 
#python fastqSplit.py test.fq.gz test

#@SRR2759114.1 FCC6LTUACXX:1:1101:1489:1983# length=180
#NGAAGGACGCGCGAGGGCCGGGACCCCGGGTGGCCGCCCCACCGGGGCCCGCGCGGCCAACCCCCGGGACGGGGACCGGCGGGGCACGGGCCGGGCCCGTGGCCCGCCGGTCCCCGTCCCGGGGGTTGGCCGCGCGGGCCCCGGTGGGGCGGCCACCCGGGGTCCCGGCCCTCGCGCGTC
#+SRR2759114.1 FCC6LTUACXX:1:1101:1489:1983# length=180
#1=DDDDFHDDHFGIIGIIJIJJGIHHHFD>BBDBDDDDDDD6B95<598B@BBBBBBB@<<07@>>B7@BBD><38&9959@-55?###@@BFFDDFHHHHGIIGIGIIHIIGIJJJJJGHFDD-7<BCCDDBB9BDBB@@BD7BDDD;@B3;7?BDDDDD5>BDDDB@BBABBDDD><


import os,sys,gzip
import re


infile=sys.argv[1]
name=sys.argv[2]


inf=gzip.open(infile,'rb')
outfr1=gzip.open(name+".r1.fq.gz",'wb')
outfr2=gzip.open(name+".r2.fq.gz",'wb')


pointer=0

for i in inf:
    if i.startswith('@SRR') or i.startswith('+SRR'):
    #if re.search("^@SRR[0-9]+", i) or re.search("^+SRR[0-9]+", i):
        pointer=1

	#try:
        x,y=i.strip("\n").split("=")
	new=str(int(y)/2) 
	i=x+"="+new+"\n" 
	#finally:      
        outfr1.writelines(i)	
       	outfr2.writelines(i)
        pointer=pointer+1
	continue

    if pointer==2:
        seq=i.strip("\n")
	half=(len(seq))/2
        outfr1.write(seq[0:half]+"\n")
	outfr2.write(seq[half:]+"\n")
        pointer=0
        continue

    outfr1.close()
    outfr2.close()

