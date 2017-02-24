#Tian R.
#Dec 23, 2016
#Jan 18, 2017
#Jan 20, 2017
#Feb 23, 2017


#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

chrList<-c("chr17", "chr13") #BRCA1,2

#chrList<-c("chr5","chr17") #NPM, TP53


# test if there is at least one argument: if not, return an error
if (length(args)==0) {
    stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
    outfile= paste(args[1],".ratio", sep="")}


get_ratio<-function(input, chrList){
    data<-read.table(input, header=F)
    totalReads<-sum(data[,2])
    #res<-sum((data[,2]/sum(data[,2]))[1:2])
    rato<-c()
    res<-c()
    for (i in 1:length(chrList)){
        rato<-(data[data[,1]==chrList[i],2])/totalReads
        rato<-round(rato, 3)
	res<-c(res,rato)
	}
#/totalReads
    return (data.frame(chr=chrList,ratio=res))
}

ratio<-get_ratio(args[1], chrList)

write.table(ratio, file=outfile, col.names=FALSE, row.names=FALSE, quote=FALSE)

