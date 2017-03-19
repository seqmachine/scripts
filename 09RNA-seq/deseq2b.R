#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)


#input file, row order and composition the same!!!

#test.tab

#gene1	20	1
#gene1	2	2
#gene2	8	10



#==> expr/598T.counts <==
#Name	NumReads
#ENST00000415118	0



library(DESeq2)

getDiff<-function(input){
	
	mydata<-read.table(input, header=F, sep="\t")
	countMatrix<-as.matrix(round(mydata[,-1]))
	rownames(countMatrix)<-mydata[,1]

	outfile=paste(input, ".diff.xls", sep="")
	if (ncol(mydata)==3) {
		#1:1 design	
		sampleNames<-c("treat1", "control1")
		table2<-data.frame(name=c("treat1", "control1"), condition=c("treat", "control"))
		}
	if (ncol(mydata)==7) {
		#1:1 design	
		sampleNames<-c("treat1", "treat2", "treat3", "control1", "control2", "control3")
		table2<-data.frame(name=c("treat1", "treat2", "treat3", "control1", "control2", "control3"), condition=c("treat","treat","treat","control","control","control"))
		}


	dds <- DESeqDataSetFromMatrix(countMatrix, colData=table2, design= ~ condition)
	
	dds <- dds[ rowSums(counts(dds)) > 1, ]
	#get normalized expr
	ori<-round(fpm(dds, robust=FALSE),2)	
	dds <- DESeq(dds)
	#get normalized expr
	#ori<-assay(dds)[["mu"]]###---what's wrong???
	colnames(ori)<-sampleNames
	res <- results(dds)
	return (list(ori=ori, res=res))
	}


expr<-getDiff(args[1])
head(expr$res)
head(expr$ori)
#str(expr.diff)
#summary(expr.diff)
mat<-cbind(as.matrix(expr$ori),round(as.matrix(expr$res),2))
#rank the matrix according pvaule adjusted
#mat[order(mat$padj)
write.table(mat, paste(args[1],".diff.xls", sep=""), sep = "\t", row.names = TRUE)

