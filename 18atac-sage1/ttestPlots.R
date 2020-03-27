#March 27, 2020
#compare peak signals grouped by SAGE1 exprs

args = commandArgs(trailingOnly=TRUE)
joinedData<-args[1]
cutoff<-args[2]

#0.01
data<-read.table(joinedData, header=T)
#"375.combined.tab"

plist<-c()
#cutoff<-0.01
for (i in 3:ncol(data)){
	positive<-data[data$sage1_expr>0,i]
	negative<-data[data$sage1_expr==0,i]
	p<-t.test(positive, negative)$p.value
	plist<-c(plist,p)
	if (mean(positive) >mean(negative) & p < cutoff) {
		pdf(paste("./output/", paste(colnames(data)[i],".pdf",sep="")))
		boxplot(list(SAGE1_positive=positive,SAGE1_negative=negative), ylab="ATAC-seq signals", col=c("purple", "lightblue"), main=colnames(data)[i])
		text(1.5,max(positive),paste("p value: ", round(p, 3), sep=""), col="red", cex=1.5)
		points(rep(1,length(positive)),positive)
		points(rep(2,length(negative)),negative)
		dev.off()} else {
		print ("No significant differences found!")}
	
	}


