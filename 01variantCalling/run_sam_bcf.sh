#!/bin/bash
#Aug 5, 2016
#versions matter!
#samtools sort, bcftools call


id=$1
outdir="out_2016.8.5/"

samPath="/share/software/VariantCalling/samtools/samtools-1.3/"
refPath="/share/work/tianrui/database/refGenome/hg19.fa"
bcfPath="/share/software/VariantCalling/bcftools/bcftools-1.2/"


$samPath"samtools"  mpileup -ugf $refPath \
$id"_stomach_N.BAM.sorted.rmdup" $id"_stomach_C.BAM.sorted.rmdup" \
$id"_lymph_N.BAM.sorted.rmdup" $id"_lymph_C.BAM.sorted.rmdup" \
|$bcfPath"bcftools" call -vm -O z -o $outdir$id".vcf.gz"
