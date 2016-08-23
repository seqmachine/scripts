#June 14, 2016
#call somatic

#12 hours


/share/software/VariantCalling/samtools/samtools-1.3/samtools mpileup \
-f /share/work/tianrui/database/refGenome/hg19.fa -q 1 -Q 20 LN.bam.sorted.rmdup LC.bam.sorted.rmdup >normal-tumor.mpileup


java -jar /share/software/VariantCalling/VarScan/VarScan.v2.3.9.jar \
somatic normal-tumor.mpileup normal-tumor.varScan.output --mpileup 1


