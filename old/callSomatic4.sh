#June 14, 2016
#call somatic
#July 27, 2016
#12 hours
#July 29
#over 30 hrs

#$1 is a list of sorted uniq bam file list in order

/share/software/VariantCalling/samtools/samtools-1.3/samtools mpileup \
-f /share/work/tianrui/database/refGenome/hg19.fa --bam-list $1 \
-q 1 -Q 20 --adjust-MQ 50 --max-depth 250 >$1".mpileup"

file=$1".mpileup"

java -jar /share/software/VariantCalling/VarScan/VarScan.v2.3.9.jar mpileup2snp $file --output-vcf 1 >$file".snp"
java -jar /share/software/VariantCalling/VarScan/VarScan.v2.3.9.jar mpileup2indel $file --output-vcf 1 >$file".indel"

