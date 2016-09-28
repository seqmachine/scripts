#!/bin/env Rscript
#Aug 24, 2016

args <- commandArgs(trailingOnly = TRUE)

infile<-args[1]

library(DNAcopy)
data<-read.table(infile)

colnames(data)<-c("chr", "start", "end", "info", "pos", "dpn", "dpc", "dpln", "dplc", "lrn", "lrc", "lrln", "lrlc")
CNA.object<-CNA(cbind(data$lrc, data$lrln, data$lrlc), data$chr, data$start, data.type="logratio", sampleid=c("lrc","lrln", "lrlc"))
smoothed.CNA.object<-smooth.CNA(CNA.object)
segment.smoothed.CNA.object <- segment(smoothed.CNA.object, undo.splits="sdundo",  undo.SD=3, verbose=1)
segment.smoothed.CNA.object$output[1:10,]


subset.CNA.object <- subset(segment.smoothed.CNA.object, samplelist="lrc")
gainLoss<-glFrequency(subset.CNA.object, threshold=3)

subset.CNA.object <- subset(segment.smoothed.CNA.object, samplelist="lrln")
gainLoss<-cbind(gainLoss, glFrequency(subset.CNA.object, threshold=3))

subset.CNA.object <- subset(segment.smoothed.CNA.object, samplelist="lrlc")
gainLoss<-cbind(gainLoss, glFrequency(subset.CNA.object, threshold=3))



head(gainLoss)
write.table(gainLoss, file=paste(infile, ".gl", sep=""), quote=F, row.names=F)



#pdf(paste(infile, ".pdf", sep=""))
#plot(segment.smoothed.CNA.object, plot.type="w")
#plot(segment.smoothed.CNA.object, plot.type="c")
#plot(segment.smoothed.CNA.object, plot.type="p")



#plot(segment.smoothed.CNA.object, plot.type="s")
#dev.off()

