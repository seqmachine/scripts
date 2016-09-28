#June 14, 2016
#call somatic
#12 hours
#Sep 21, 2016 !!!!!!!!
# panel, ref, what else (others!)
#5hrs
#Sep 23, 2016


tumor=$1

#control="DNANNFR1I160203-A8.BAM.sorted.rmdup"
control="DNANNFR1I160203-A8.rmdup.bam"


/share/software/VariantCalling/samtools/samtools-1.3/samtools mpileup -f /share/work/tianrui/database/refGenome/hg19.fa -q 1 -Q 20 $control $tumor >$tumor".mpileup"

java -jar /share/software/VariantCalling/VarScan/VarScan.v2.3.9.jar \
somatic $tumor".mpileup" $tumor".varScan.output" --mpileup 1 --output-vcf 1 --min-var-freq 0.005

#### --min-var-freq !!!!!!!!! Sep 23, 2016

#output vcf with somatic info as header
