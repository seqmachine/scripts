#!/bin/bash
#Aug 3, 2016
#FreeBayes, study in depth!!!
#4hr for whole genome
#test how many hours for exome
#Aug 9,2016



bam=$1
targetBed="SeqCap_EZ_Exome_v3_primary.bed.gz"
outdir="out_exs_8.9"


/share/software/VariantCalling/freebayes/freebayes/bin/freebayes \
-f /share/work/tianrui/database/refGenome/hg19.fa \
-t <(zcat /share/work/tianrui/database/bed/$targetBed |grep "chr" |cut -f1-3) \
$bam |gzip >$outdir/$bam".wxs.vcf.gz" 




#qsub -j y -b y -cwd -l vf=4,p=2 ./run.freeBayes.sh mg5_lymph_C.BAM.sorted.rmdup
#qsub -j y -b y -cwd -l vf=4,p=2 ./run.freeBayes.sh mg5_lymph_N.BAM.sorted.rmdup
