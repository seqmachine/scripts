library(DNAcopy)
data<-read.table("Patient1_qs1.list.merged.logR.nr")
colnames(data)<-c("chr", "start", "end", "info", "pos", "dpn", "dpc", "dpln", "dplc", "lrn", "lrc", "lrln", "lrlc")
CNA.object<-CNA(cbind(data$lrc, data$lrln), data$chr, data$start, data.type="logratio", sampleid=c("lrc","lrln"))
smoothed.CNA.object<-smooth.CNA(CNA.object)
segment.smoothed.CNA.object <- segment(smoothed.CNA.object, verbose=1)
segment.smoothed.CNA.object$output[1:10,]
pdf("/a.pdf")
plot(segment.smoothed.CNA.object, plot.type="w")
plot(segment.smoothed.CNA.object, plot.type="c")
plot(segment.smoothed.CNA.object, plot.type="p")
dev.off()

