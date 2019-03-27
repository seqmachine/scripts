#TianR. <ruitian@yeah.net>

#SRR7008765	SRR7008780	SRR7008784
#12.62 	0.0 	89.02 
#30.0 	84.65 	0.0 
#0.0 	0.0 	0.0 

#A
#B
#C

#RPKM

options <- commandArgs(trailingOnly = TRUE)

matrixfile<-options[1] #matrix file


quantile.norm<-function (PM){
        order.PM <- apply(PM, 2, sort) #get the same dimension of matrix with ordered columns 
        mean.PM <- apply(order.PM, 1, mean) #get the rowmean 
        rank<-apply(PM,2, rank, ties.method="first") #get the column rank 
        finish.PM<-apply(rank, 2, function(x) mean.PM[x]) #reorder the rowmean
        
        return (finish.PM) 
        }


df<-read.table(matrixfile, header=T)
#rownames(df)<-c("A", "B", "C")
mat<-as.matrix(df)
rownames(mat)<-c("A", "B", "C")


#epsilon is the RPKM closest to 0 in the matrix

epsilon<-min(mat[mat>0]) #

mat.log<-log2(mat+epsilon)



rownames(mat.log)<-c("A", "B", "C")
colnames(mat.log)<-c()

nameout<-paste(matrixfile,".pdf",sep="")
pdf(nameout)

print (paste("Saved output in",nameout))

library(gplots)

heatmap.2(mat.log, col=colorRampPalette(c("white", "black"))(n = 1000), scale="col", dendrogram="both", trace="none")

dev.off()





