#March 27, 2020
#transpose dataframe

args = commandArgs(trailingOnly=TRUE)

infile<-args[1]
#61.loci.peaks 
transposeTable<-function(infile){
	sage1<-read.table(infile)
	write.table(t(sage1), file=paste(infile,".t", sep=""), quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)
       } 


transposeTable(infile)
