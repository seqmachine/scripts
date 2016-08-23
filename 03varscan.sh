#Aug 9, 2016
#call normal tumor pairs
#call multiple samples together
#loosen parameters at beginning, filter at last
#mpile normal and binary is different

#June 14, 2016
#call somatic
#12 hours
/share/software/VariantCalling/samtools/samtools-1.3/samtools mpileup \
-f /share/work/tianrui/database/refGenome/hg19.fa -q 1 -Q 20 LN.bam.sorted.rmdup LC.bam.sorted.rmdup >normal-tumor.mpileup
java -jar /share/software/VariantCalling/VarScan/VarScan.v2.3.9.jar \
somatic normal-tumor.mpileup normal-tumor.varScan.output --mpileup 1


#July 29
#over 30 hrs
#$1 is a list of sorted uniq bam file list in order
/share/software/VariantCalling/samtools/samtools-1.3/samtools mpileup \
-f /share/work/tianrui/database/refGenome/hg19.fa --bam-list $1 \
-q 1 -Q 20 --adjust-MQ 50 --max-depth 250 >$1".mpileup"
file=$1".mpileup"
java -jar /share/software/VariantCalling/VarScan/VarScan.v2.3.9.jar mpileup2snp $file --output-vcf 1 >$file".snp"
java -jar /share/software/VariantCalling/VarScan/VarScan.v2.3.9.jar mpileup2indel $file --output-vcf 1 >$file".indel"



#
#[mpileup] 2 samples in 2 input files
#<mpileup> Set max per-file depth to 4000
#Min coverage:	8x for Normal, 6x for Tumor
#Min reads2:	2
#Min strands2:	1
#Min var freq:	0.2
#Min freq for hom:	0.75
#Normal purity:	1.0
#Tumor purity:	1.0
#Min avg qual:	15
#P-value thresh:	0.99
#Somatic p-value:	0.05
#Reading input from normal-tumor.mpileup
#Reading mpileup input...
#1830903870 positions in mpileup file
#140567992 had sufficient coverage for comparison
#140350028 were called Reference
#73 were mixed SNP-indel calls and filtered
#17246 were removed by the strand filter
#191509 were called Germline
#3308 were called LOH
#5026 were called Somatic
#802 were called Unknown
#0 were called Variant

