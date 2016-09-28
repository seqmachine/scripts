#!/bin/env R
#Sep 27, 2016
judge.cnv<-function (x, cutoff){
	y<-c()
	for (i in 1:length(x)){
	if (x[i] >=cutoff) {
	y[i]<-"gain"} else if ( x[i] < 0 && abs(x[i]) >=cutoff ){
	y[i]<-"loss"} else
	y[i]<-"-"
	}	
	return (y)
	}	

args <- commandArgs(trailingOnly = TRUE)

infile<-args[1]

data<-read.table(infile, header=F)

write.table(cbind(data[,1:4],apply(data[,1:12], 2, function(x) judge.cnv(x,2.5))),file=paste(infile, ".tab", sep=""), sep="\t", quote=F, row.names=F, col.names=F)


