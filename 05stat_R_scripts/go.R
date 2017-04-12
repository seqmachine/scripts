library(clusterProfiler)
de <- names(geneList)[1:100]
yy <- enrichGO(de, 'org.Hs.eg.db', ont="BP", pvalueCutoff=0.01)
#yy <- enrichKEGG(de, pvalueCutoff=0.01)
go<--log10(yy$pvalue)
names(go)<-yy$Description

pdf("./aa.pdf")

#define the margin
#par(mai=c(1,3,1,1), ps=12, cex=1, cex.main=1)
#barplot(head(go),horiz=TRUE, col="lightblue", las=1, cex.names=0.6, col.axis="blue")
#dotplot(yy, showCategory=20)
#barplot(yy)

dev.off()

pdf("./aa.pdf")
kegg<-gseKEGG(geneList, organism = "hsa", keyType = "kegg", exponent = 1,
        nPerm = 1000, minGSSize = 10, maxGSSize = 500, pvalueCutoff = 0.05,
        pAdjustMethod = "BH", verbose = TRUE, use_internal_data = FALSE,
        seed = FALSE, by = "fgsea")
summary(kegg)
gseaplot(kegg, geneSetID="hsa04510")
dev.off()