#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

file1<-args[1]
file2<-args[2]
output<-args[3]

#Rscript computeLongShortIndex.R twoRong2020-12-11.txt twoRong2020-12-18.txt out.txt

#Tian R.
#Dec 21, 2020

#library("optparse")
 
#option_list = list(
#	make_option(c("-f1", "--file1"), type="character", default=NULL, 
#    			help="stock exchange previous dataset file name", metavar="character"),
#	make_option(c("-f2", "--file2"), type="character", default=NULL, 
#        		help="stock exchange now dataset file name", metavar="character"),
#   make_option(c("-o", "--out"), type="character", default="out.txt", 
#        		help="output file name [default= %default]", metavar="character")
#); 
 
#opt_parser = OptionParser(option_list=option_list);
#opt = parse_args(opt_parser);


#twoRongData0<-read.table("twoRong2020-12-11.txt", header=T)
#twoRongData1<-read.table("twoRong2020-12-18.txt", header=T)

twoRongData0<-read.table(file1, header=T)
twoRongData1<-read.table(file2, header=T)


codeVector<-c()
rongziDiffVector<-c()
rongquanDiffVector<-c()
ratioStartVector<-c()
ratioEndVector<-c()
comNameVector<-c()
#longIndexVector<-c()

#total=2
total=dim(twoRongData0)[1]

for (i in 1:total){
  code0<-twoRongData0[i,1]
  code1<-twoRongData1[i,1]
  if (code0 == code1){
    rongziDiff<-100*(twoRongData1[i,3]-twoRongData0[i,3])/(twoRongData0[i,3]+1)
    rongquanDiff<-100*(twoRongData1[i,6]-twoRongData0[i,6])/(twoRongData0[i,6]+1)
    ratioStart<-log10((twoRongData0[i,3]+1)/(twoRongData0[i,6]+1))
    ratioEnd<-log10((twoRongData1[i,3]+1)/(twoRongData1[i,6]+1))
    comName<-twoRongData0[i,2]
    
    rongziDiffVector<-c(rongziDiffVector,rongziDiff)
    rongquanDiffVector<-c(rongquanDiffVector,rongquanDiff)
    ratioStartVector<-c(ratioStartVector,ratioStart)
    ratioEndVector<-c(ratioEndVector,ratioEnd)
	#longIndexVector<-c(longIndexVector,(ratioEnd-ratioStart))
	#longIndexVector
    codeVector<-c(codeVector,code0)
    comNameVector<-c(comNameVector,comName)
    
    }
}

#get longIndex rank changes:
#bigger longIndex, stronger the long side

outData<-data.frame(code=codeVector,rongziChange=round(rongziDiffVector,2),
					rongquanChange=round(rongquanDiffVector,2),
					ratioBegin=round(ratioStartVector,2), ratioNow=round(ratioEndVector,2),
					longIndex=(rank(ratioEndVector)-rank(ratioStartVector)))
#head(outData)
#sort by longIndex, descreasing

write.table(outData[order(-outData[,6]),],file=output, sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

