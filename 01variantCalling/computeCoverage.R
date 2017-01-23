#Tian R.
#Dec 23, 2016
#Jan 18, 2017

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
    stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==2) {
  # default output file
    outfile= paste(args[1],".xls", sep="")
    depth=args[2]
    }


get_ratio<-function(input, depth){
    data<-read.table(input, header=F)
    cov<-as.vector(data[,1])
    #median(cov)
    res<-100*length(cov[cov>=as.integer(depth)])/length(cov)
    return (c(res,median(cov)))
}

ratio<-get_ratio(args[1], depth)

cat (args[1], ",",args[2], ",", ratio[1],",", ratio[2], "\n")

write.table(ratio, file=outfile, col.names=FALSE, row.names=FALSE, quote=FALSE, sep=",")

