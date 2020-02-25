#Feb 25, 2020
#TianR
#boxplots with data dots

#args = commandArgs(trailingOnly=TRUE)
#exprTable<-args[1] #input file
#cancerType<-args[2] #cancer type
#cancerType<-"BRCA"

#brca<-read.table("BRCA-US_TRAIP_.expr.paired.tab")
#stad<-read.table("STAD-US_TRAIP_.expr.paired.tab")

#boxplot(log10(brca[,2:3]),log10(stad[,2:3]))

#boxplot problem of data of different nrow!!!

#brca<-read.table("BRCA-US_TRAIP_.expr.paired.tab")

##################################################
#
low<-c(-6.8)
high<-c(-4.2)
longmax<-10.1
dotType<-2
i<-1
delt<-0.4 #left right range

pdf("./pancaner.pdf")
plot(0,low,xlim=c(0.8,longmax), ylim=c(low,high), main="Pan-cancer TRAIP expression in Tumor v.s. Normal", type="n", xlab="", ylab="sorted log10 of expression values") #not plotting, p point, l line, b both

plotSortedDots<-function(i,exprTable,cancerType){
  
  brca<-read.table(exprTable)
  
  points(seq(from=i-delt, to=i+delt, length.out=nrow(brca)), sort(log10(brca[,2])),pch=dotType, col="lightblue")
  segments(i-delt,median(log10(brca[,2])), i+delt, median(log10(brca[,2])), col="red", lwd=4)
  
  #abline(v=i-delt-0.1, col = "gray60")
  text(i-delt/2+0.1,high-delt-0.1,cancerType, cex=0.6)
  text(i-delt/2,high-delt-0.2,"normal", cex=0.6)
  
  points(seq(from=i+1-delt, to=i+1+delt, length.out=nrow(brca)), sort(log10(brca[,3])), pch=dotType, col="pink")
  segments(i+1-delt,median(log10(brca[,3])), i+1+delt, median(log10(brca[,3])), col="red", lwd=4)
  text(i+1-delt/2+0.1,high-delt-0.1,cancerType, cex=0.6)
  text(i+1-delt/2,high-delt-0.2,"tumor", cex=0.6)
  
  abline(v=i+1+delt+0.1, col = "gray60")
  
  #seprate normal/tumor
  segments(i+delt+0.1, low-0.2,i+delt+0.1, high+0.2, lty=2, col="grey")
}


i<-1
for (cancerType in c("LUAD-US", "LUSC-US", "STAD-US", "BRCA-US", "COAD-US")){
  plotSortedDots(i, exprTable = paste(cancerType,"_TRAIP_.expr.paired.tab", sep=""), cancerType)
  i<-i+2
}

dev.off()

##########################################################

#plotSortedDots(i=3,exprTable = "BRCA-US_TRAIP_.expr.paired.tab", cancerType = "BRCA-US")
#plotSortedDots(i=1,exprTable = "LIRI-JP_TRAIP_.expr.paired.tab", cancerType = "LIRI-JP")
#plotSortedDots(i=1,exprTable = "COAD-US_TRAIP_.expr.paired.tab", cancerType = "COAD-US")

#ncol-1
#first column is name

#for (i in 2:(ncol(brca))){
#  points(seq(from=0.6, to=1.4, length.out=nrow(brca)), sort(log10(brca[,i])), pch=2) 
#}