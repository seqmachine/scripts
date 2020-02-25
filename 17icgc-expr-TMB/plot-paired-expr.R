#Feb 25, 2020
#read icgc sample information, 11:normal, 01:cancer
#some data points are redundant

args = commandArgs(trailingOnly=TRUE)
exprTable<-args[1] #input file
cancerType<-args[2] #cancer type

brca<-read.table(exprTable)
allExpr<-c(brca[,2], brca[,3])
minV<-log10(min(allExpr))
maxV<-log10(max(allExpr))

pdf(paste("./", paste(cancerType, "pdf", sep=".")))

plot(log10(brca[,2]), log10(brca[,3]),xlab="expression levels in normal samples", xlim=c(minV,maxV), ylab="expression levels in tumor samples", ylim=c(minV,maxV), main="Paired Tumor/Normal expression of TRAIP")
segments(minV,minV,maxV,maxV)

text(minV+0.15, maxV-0.15, cancerType)

dev.off()
