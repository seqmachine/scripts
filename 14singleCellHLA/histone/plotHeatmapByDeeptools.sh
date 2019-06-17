#plot .bw heatmap across HLA region


multiBigwigSummary bins \
	-b `ls *.bw` \
	--region chr6:29721340:33129113 \
	--numberOfProcessors max/2 --binSize 1000 \
	-out scores_per_bin.npz --outRawCounts scores_per_bin.tab

plotCorrelation \
	-in scores_per_bin.npz \
    	--corMethod spearman --skipZeros \
    	--plotTitle "Spearman Correlation of Read Counts" \
   	 --whatToPlot heatmap --colorMap RdYlBu --plotNumbers \
    	-o heatmap_SpearmanCorr_readCounts.png   \
    	--outFileCorMatrix SpearmanCorr_readCounts.tab
