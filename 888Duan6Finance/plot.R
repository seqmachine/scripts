#Oct 21, 2017
#Tian R.
#plot Return of Equity and Equity (net asset)

args = commandArgs(trailingOnly=TRUE)
infile<-args[1]

tong<-read.table(infile, header=F)

#         V1     V2     V3
#1 1993-12-31 1.0315 0.1189

dat<-as.matrix(tong[,2:3])
rownames(dat)<-as.vector(tong[,1])

pdf(paste("./", paste(infile, ".pdf", sep=""), sep=""))
par(mfrow=c(2,1))
barplot(dat[,2]/dat[,1], las=2, col="pink", main="ROE")
medianROE<-round(median(dat[,2]/dat[,1]),3)
abline(h=medianROE, lwd=2, col="blue")
legend("top", paste("median ROE=", medianROE, sep=""), text.col="blue")
abline(h=0.05, lwd=2, col="red")

barplot(dat[,1], las=2, col="lightblue", main="Net Asset")

dev.off()
