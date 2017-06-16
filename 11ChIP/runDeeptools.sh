#June 16, 2017
#heatmap, profiler
#10 min

#sudo pip install deeptools
#Visualization of ChIP-seq data using Heatmaps
#deeptools, galaxy, good tools! 

bigWig=$1
bed=$2


computeMatrix reference-point -S $bigWig -R $bed \
--beforeRegionStartLength 3000 \
--regionBodyLength 5000 \
--afterRegionStartLength 3000 \
--skipZeros -o $bigWig".matrix.mat.gz"


plotHeatmap -m $bigWig".matrix.mat.gz" \
--plotFileFormat "pdf" \
-out $bigWig".Heatmap.pdf" \
--colorMap RdBu \
--whatToShow 'heatmap and colorbar' \
--zMin -1 \
--zMax 1 \
--kmeans 3
