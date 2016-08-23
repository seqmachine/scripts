#!/bin/bash
#June 13-15, 2016
#June 20, 2016
#July 21, 2016

#$1, r1.fq.gz
#$2, r2.fq.gz
#$3, name 



####################
#1)reads trimming, QC
#$1 R1
#$2 R2
#1 hr


TrimmoPath="/share/work/tianrui/software/Trimmomatic-0.32/"
BwaPath="/share/software/Alignment/bwa/bwa-0.7.13/bwa/"
SamtPath="/share/software/VariantCalling/samtools/samtools-1.3/"


FastqcPrep(){


java -jar $TrimmoPath"trimmomatic-0.32.jar" PE \
-threads 20 $1 $2 \
$1".clean.gz" $1".unpaired.gz" \
$2".clean.gz" $2".unpaired.gz" \
ILLUMINACLIP:$TrimmoPath"adapters/TruSeq3-PE.fa":2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50


}


#####################
#2)mapping, alignment, sam to bam
#around 3 hr, 4 fold compression

ToBam(){

$BwaPath"bwa mem -a -M /share/work/tianrui/database/refGenome/hg19.fa $1 $2 | "$SamtPath"samtools view -bS - >"$3".BAM"

}

######################what's wrong with new sort??????
#3) sort, mark duplicate
#spcify mem is essential
#30min around

SortUnique(){
$SamtPath"samtools sort -m 4G -@ 2 -T /tmp/"$1".BAM.sorted -o "$1".BAM.sorted "$1".BAM"
$SamtPath"samtools rmdup "$1".BAM.sorted" $1".BAM.sorted.rmdup"

}

echo $1
echo $2
echo $3
echo "#% step one: "`date`", preprocess fastq files."


#FastqcPrep $1 $2

echo "#% step two: "`date`", align reads."

#/share/software/Alignment/bwa/bwa-0.7.13/bwa/bwa mem -a -M /share/work/tianrui/database/refGenome/hg19.fa $1".clean.gz" $2".clean.gz" |/share/software/VariantCalling/samtools/samtools-1.3/samtools view -bS - >$3".BAM"

echo "#% step three: "`date`", sort and mark duplicates."
#SortUnique $3
/share/software/VariantCalling/samtools/samtools-1.3/samtools sort -m 4G -@ 2 -T `pwd`"/temp/"$3".BAM.sorted" -o $3".BAM.sorted" $3".BAM"
/share/software/VariantCalling/samtools/samtools-1.3/samtools rmdup $3".BAM.sorted" $3".BAM.sorted.rmdup"
echo "#% "`date`"  run ends."

