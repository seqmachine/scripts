#!/bin/env Rscript
#Quantile normalization, good R programming practice!!!
#Sep 23, 2016

args <- commandArgs(trailingOnly = TRUE)

infile<-args[1]



quantile.norm<-function (PM){
	order.PM <- apply(PM, 2, sort) #get the same dimension of matrix with ordered columns 
	mean.PM <- apply(order.PM, 1, mean) #get the rowmean 
	rank<-apply(PM,2, rank, ties.method="first") #get the column rank 
	finish.PM<-apply(rank, 2, function(x) mean.PM[x]) #reorder the rowmean
	
	return (finish.PM) 
	}



#re check this function, might be buggy
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


#less 180.cnv | awk -F "\t" '{for(i=5;i<NF;i++) {if ($i >=2.5 || $i <= -2.5) {print $0} }}' |less


data<-read.table(infile, header=F)
#[tianrui@cluster dep_of_coverage]$ head -n1 12_sample.doc 
#chr1	9781181	9781358	PIK3CD_exon14_1		4583	3507	4628	4294	4115	3524	4987	4335	4205	3406	2898	3403


#head(data)

####log 0000 !!!!!
#if use log2 sample_doc / control_doc

logR<- log2((data[,5:16]+1)/(data[,17]+1))

#if only use sample_doc, take log, ignore control

#logR<-log2(data[,5:16]+1)


doc.norm<-quantile.norm(logR)

meanByrow<-apply(doc.norm,1,mean)
sdByrow<-apply(doc.norm,1,sd)

doc.std<-c()

for (i in 1:nrow(doc.norm)){doc.std<-rbind(doc.std, round((doc.norm[i,]-meanByrow[i])/sdByrow[i],2))}
write.table(cbind(data[,1:4], doc.std), file=paste(infile, ".logR.cnv", sep=""), sep="\t", row.names=F, col.names=F, quote=F)

#write.table(cbind(data[,1:4],apply(doc.std[,1:12], 2, function(x) judge.cnv(x,2.5))),file=paste(infile, ".cnv", sep=""), sep="\t", quote=F, row.names=F, col.names=F)



