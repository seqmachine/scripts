#!/bin/env Rscript
#Aug 26, 2016

args <- commandArgs(trailingOnly = TRUE)

infile<-args[1]

#infile<-"Patient5_mg5.list.merged.logR.nr.gl.m4"

data<-read.table(infile, sep="\t", na.strings=NA)

gene.total<-length(as.vector(unique(data[,4])))

clean.multi.probe<-function(data=data, gene=gene){

	chr<-unique(as.vector(data[data[,4]==gene,1]))
	start<-min(as.vector(data[data[,4]==gene,2]))
	end<-max(as.vector(data[data[,4]==gene,3]))
	depth<-as.vector(apply(data[data[,4]==gene,6:13],2,mean))

	type<-length(table(as.vector(data[data[,4]==gene,5])))
	freq.max<-0
	i.max<-0
	for (i in 1:type){
		if (table(as.vector(data[data[,4]==gene,5]))[[i]] >freq.max){freq.max<-table(as.vector(data[data[,4]==gene,5]))[[i]]
		i.max<-i
             }
	}
	gainLoss<-attr(table(as.vector(data[data[,4]==gene,5]))[i.max], "names")
	res<-c(chr, start, end, gene, gainLoss, round(depth,2))

	return (res)
}

output<-c()
for (j in 1:gene.total){

	gene<-as.vector(unique(data[,4]))[j]

	if (gene != ""){output<-rbind(output, clean.multi.probe(data, gene))}
	}

write.table(output, file=paste(infile,".u", sep=""), sep="\t", quote=F, row.names=F, col.names=F)



