#!/bin/bash
#Aug 3, 2016
#FreeBayes, study in depth!!!
#4hr

bam=$1
/share/software/VariantCalling/freebayes/freebayes/bin/freebayes \
-f /share/work/tianrui/database/refGenome/hg19.fa $bam |gzip >out_2016.8.3/$bam".vcf.gz" 


#qsub -j y -b y -cwd -l vf=4,p=2 ./run.freeBayes.sh mg5_lymph_C.BAM.sorted.rmdup
#qsub -j y -b y -cwd -l vf=4,p=2 ./run.freeBayes.sh mg5_lymph_N.BAM.sorted.rmdup
