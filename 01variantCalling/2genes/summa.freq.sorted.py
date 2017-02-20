#Feb 13, 2017
#Tian R.
#sorted, left ID, right number
#chr17@7578432@7578432@T@G@exonic@TP53@synonymous SNV@TP53:NM_000546:exon5:c.A498C:p.S166S       1.54%
#chr17@7578432@7578432@T@G@exonic@TP53@synonymous SNV@TP53:NM_000546:exon5:c.A498C:p.S166S       1.55%

#must be sorted first!!!

import sys

inputfile=sys.argv[1]

fh=open(inputfile,"r")
mut=""
rate=""
num=0
count=1
ave=0
he=0.0
for line in fh:
	id, freq=line.strip("\n").split("\t")
	num=num+1
	
	if num==1:
		mut=id
		rate=freq
		he=he+float(freq)
	else:
		if mut == id:
			he=he+float(freq)
			rate=rate+","+freq
			count=count+1			
		if mut !=id:		
			ave=float(he/count)
			if count==1:
				print str(count)+"\t"+mut+"\t"+rate+"%\t"+rate
			else:
				print str(count)+"\t"+mut+"\t"+str(round(ave,2))+"%\t"+rate
			mut=id
			rate=freq
			count=1
			he=float(freq)

	



			
