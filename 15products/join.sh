cat /home/tianr/pipelines/getSNP/getSNPpipeline0.4.26/25loci.txt | awk -F "\t" '{print "chr"$3"_"$4"\t"$2"\t"$1}' >25loci.txt.tab

vcfFile=" S1.BAM.sorted.rmdup.mup.vcf"
cat $vcfFile | awk '{print $1"_"$2"\t"$4"\t"$5}' >$vcfFile".tab"

join -1 1 -2 1 <(sort -k1 25loci.txt.tab) <(sort -k1 $vcfFile".tab") > $vcfFile".tab.intersection"

