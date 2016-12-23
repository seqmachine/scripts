#Tian R.
#Dec 23, 2016

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
    stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
    outfile= paste(args[1],".ratio", sep="")}


get_ratio<-function(input){
    data<-read.table(input, header=F)
    res<-sum((data[,2]/sum(data[,2]))[1:2])
    return (res)
}

ratio<-get_ratio(args[1])

write.table(ratio, file=outfile, col.names=FALSE, row.names=FALSE, quote=FALSE)

