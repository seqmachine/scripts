#Dec 13, 2020
#a quant strategy by monitoring hs300/zz500 ranking changes per week
#TianR.

#!/bin/python

#chinese character support issue, chaotic formats cleaning issue

#startPrice nowPrice cutoff outfile
#python compareRank.py zz500/zz500-2020-12-04.txt zz500/zz500-2020-12-11.txt 4 zz500

import sys
import operator
from collections import OrderedDict

def readWeb(infile):
    
#read webpages downloaded into list of two dicts (code:price, code:name)
	
	dictPrice={}
	dictID={}
	fh=open(infile, "r")
	for line in fh:
		if line.startswith("sh") or line.startswith("sz"):
	    	#format control
			
			array=line.split() #no matter how many spaces, treat as one
			stockCode=array[0] 
			comName=array[1]
			price=array[6] #the 7th col, sell price
			#english chinese mixed file parsing, big issue!

			try:
				dictPrice[stockCode]=float(price)
				dictID[stockCode]=comName
			except:
				pass

	fh.close()
	
	return ([dictPrice, dictID])



def getRank(dictPrice):

#given code:price, get the rank of code by price			
	priceList=[]
	rankDict={}

	priceList=dictPrice.values()
		#priceList=priceList.append(dictPrice[code]) #read num into list, somethin wrong!

	priceList.sort()

	for code in dictPrice.keys():
		rankDict[code]=priceList.index(dictPrice[code])+1			

	return (rankDict)



def pickDiff(rankStart, rankEnd, cutoff):

#given two code:rank dicts, report codes differ by cutoff, e.g.,3-5/100
	dictPick={}

	for code in rankStart.keys():
		try:
			diff=rankStart[code]-rankEnd[code]
			if diff >= cutoff or diff <=  -cutoff:
				dictPick[code]=diff
		except:
			pass
	return (dictPick)			


def main():
	startFile=sys.argv[1]
	endFile=sys.argv[2]
	cutoff=int(sys.argv[3])
	outFile=sys.argv[4]+".diff"
	fh=open(outFile, "w")	
	fh.write("companyCode"+"\t"+"company"+"\t"+"f_price"+"\t"+"now_price"+"\t"+"rank_change"+"\n")	

	listStart=readWeb(startFile)
	listEnd=readWeb(endFile)

	dictPriceStart=listStart[0]
	dictPriceEnd=listEnd[0]
	
	dictIDStart=listStart[1]

	rankStart=getRank(dictPriceStart)
	rankEnd=getRank(dictPriceEnd)	

	dictPick=pickDiff(rankStart, rankEnd, cutoff)

	#sort by values, output tuple
	sorted_tuples = sorted(dictPick.items(), key=operator.itemgetter(1))	

	for i in range(len(sorted_tuples)):
		code=sorted_tuples[i][0]
		diff=sorted_tuples[i][1]
		comName=dictIDStart[code]
		price0=dictPriceStart[code]
		price1=dictPriceEnd[code]
		
		fh.write("\t".join([code, comName, str(price0), str(price1), str(diff)])+"\n")
	fh.close()

if __name__=="__main__":
	main()


