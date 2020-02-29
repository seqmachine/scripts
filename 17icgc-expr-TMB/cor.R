#Feb 25, 2020
#spearman, rank based, dandiao ma?

args = commandArgs(trailingOnly=TRUE)

liverTable<-args[1]
cancerTable<-args[2]
gene<-args[3]

liver<-read.table(liverTable)
x1<-cor(liver[,4], liver[,5], method = "spearman")

cancer<-read.table(cancerTable)
x2<-cor(cancer[,4], cancer[,5], method = "spearman")

#liver, cancer (from left to the right)
write.table(cbind(x1,x2,nrow(liver), nrow(cancer)), file=paste("./output/",paste(gene, ".cor.txt", sep="")), sep="\t", quote=FALSE, row.names=gene, col.names=FALSE)
