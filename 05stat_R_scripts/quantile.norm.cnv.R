#Quantile normalization, good R programming practice!!!
#Sep 23, 2016


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


less 180.cnv | awk -F "\t" '{for(i=5;i<NF;i++) {if ($i >=2.5 || $i <= -2.5) {print $0} }}' |less


data<-read.table("12_sample.doc", header=F)
head(data)
quantile.norm<-function (PM){
order.PM <- apply(PM, 2, sort) #get the same dimension of matrix with ordered columns 
mean.PM <- apply(order.PM, 1, mean) #get the rowmean 
rank<-apply(PM,2, rank, ties.method="first") #get the column rank 
finish.PM<-apply(rank, 2, function(x) mean.PM[x]) #reorder the rowmean
return (finish.PM) 
}
doc.norm<-log2(quantile.norm(data[,5:16])+1)
meanByrow<-apply(doc.norm,1,mean)
sdByrow<-apply(doc.norm,1,sd)
doc.std<-c()
for (i in 1:nrow(doc.norm)){doc.std<-rbind(doc.std, round((doc.norm[i,]-meanByrow[i])/sdByrow[i],2))}
write.table(cbind(data[,1:4], doc.std), file="180.cnv", sep="\t", row.names=F, col.names=F)

apply(data[1:6,5:16], 2, function(x) judge.cnv(x,2.5))
write.table(cbind(data[,1:4],apply(data[,5:16], 2, function(x) judge.cnv(x,2.5))),file="cnv.info", sep="\t", quote=F, row.names=F, col.names=F)



