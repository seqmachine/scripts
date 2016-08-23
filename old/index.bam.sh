#!/bin/bash
#Aug 9, 2016
#index sorted bam for region based view or mutation calling purpose

#$1 is sorted rmdup bam

#10 min

/share/software/VariantCalling/samtools/samtools-1.3/samtools index $1
