#!/bin/bash
#June 13, 2016
#spcify mem is essential
#30min around

/share/software/VariantCalling/samtools/samtools-1.3/samtools sort -m 4G -@ 8 -T /tmp/$1".sorted" -o $1".sorted" $1
/share/software/VariantCalling/samtools/samtools-1.3/samtools rmdup $1".sorted" $1".sorted.rmdup"



#/share/software/VariantCalling/samtools/samtools-1.3/samtools merge LN.bam S221_07A_CHG008180-PDNAEI160006-WLM-LN_L001.sam.BAM \
#S221_07A_CHG008180-PDNAEI160006-WLM-LN_L001.r1.unpaired.sam.BAM \
#S221_07A_CHG008180-PDNAEI160006-WLM-LN_L001.r2.unpaired.sam.BAM

#/share/software/VariantCalling/samtools/samtools-1.3/samtools sort -T /tmp/LN.bam.sorted -O "bam" LN.bam > LN.bam.sorted
#/share/software/VariantCalling/samtools/samtools-1.3/samtools rmdup LN.bam.sorted LN.bam.sorted.rmdup

