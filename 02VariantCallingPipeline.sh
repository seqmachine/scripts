#!/bin/bash
#June 13-15, 2016
#June 20, 2016
#July 21, 2016


###################
#3 input files (arguments)

#$1, r1.fq.gz
#$2, r2.fq.gz
#$3, name 
#@Aug 9, 2016 TianR.<>


###################
#Step 0 QC
#FastQC/fastqc $file
####################
#Dependencies: trimmomatic, bwa, samtools (version matters!!!), bcftools, FreeBayes, Annovar

#databases: hg19.fa and hg19 bwa index files

#bed file: for small panel exome or whole exome seq intervals


TrimmoPath="/share/work/tianrui/software/Trimmomatic-0.32/"
BwaPath="/share/software/Alignment/bwa/bwa-0.7.13/bwa/"
SamtPath="/share/software/VariantCalling/samtools/samtools-1.3/"
ref="/share/work/tianrui/database/refGenome/hg19.fa"
FreeBayesPath="/share/software/VariantCalling/freebayes/freebayes/bin/"
targetBed="/share/work/tianrui/database/bed/SeqCap_EZ_Exome_v3_primary.bed.gz"
bcfPath="/share/software/VariantCalling/bcftools/bcftools-1.2/"
annPath="/share/software/Annotation/annovar/"

mkdir -p temp

####################
#1)reads trimming, should be cautious

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
	$BwaPath"bwa" mem -a -M $ref $1 $2 | $SamtPath"samtools" view -bS - >$3".BAM"
	}

######################what's wrong with new sort??????
#3) sort, mark duplicate
#spcify mem is essential
#30min around
#index, 10 min

SortUniqueIndex(){
	$SamtPath"samtools" sort -m 4G -@ 2 -T `pwd`"/temp/"$1".BAM.sorted" -o $1".BAM.sorted" $1".BAM"
	$SamtPath"samtools" rmdup $1".BAM.sorted" $1".BAM.sorted.rmdup"
	$SamtPath"samtools" index $1".BAM.sorted.rmdup"
	}



########################
#4) variant callers
#Aug 3, 2016
#FreeBayes, study in depth!!!
#4hr for whole genome
#test how many hours for exome 2hrs
#Aug 9,2016

Call_freebayes(){

	bam=$1
	outdir=$2

	$FreeBayesPath"freebayes" -f $ref \
-t <(zcat $targetBed |grep "chr" |cut -f1-3) \
$bam |gzip >$outdir/$bam".wxs.fb.vcf.gz" 
	}


Call_bcftools(){

	bam=$1
	outdir=$2

	$SamtPath"samtools"  mpileup -ugf $ref \
-l <(zcat $targetBed |grep "chr" |cut -f1-3) \
$bam |$bcfPath"bcftools" call -vm -O z -o $outdir/$bam".bcft.vcf.gz"
	}




###########################
#4)annotation, filtering
# annovar is updated, based on many databases, gene based or filter based.
Ann(){
	inputVCF=$1

	perl $annPath"table_annovar.pl" <(zcat $inputVCF) \
$annPath"humandb/" -buildver hg19 -out $inputVCF".out" -remove \
-protocol refGene,cytoBand,esp6500siv2_all,snp138,ljb26_all \
-operation g,r,f,f,f -nastring . -vcfinput
}



#qsub -j y -b y -cwd -l vf=4,p=2 ./run.freeBayes.sh mg5_lymph_C.BAM.sorted.rmdup
#qsub -j y -b y -cwd -l vf=4,p=2 ./run.freeBayes.sh mg5_lymph_N.BAM.sorted.rmdup

echo "#% step one: "`date`", preprocess fastq files."
FastqcPrep $1 $2

echo "#% step two: "`date`", align reads."
ToBam $1".clean.gz" $2".clean.gz" $3

echo "#% step three: "`date`", sort and mark duplicates."
SortUniqueIndex $3

echo "#% step four: "`date`", call mutations."
Call_freebayes $3".BAM.sorted.rmdup" `pwd`
Call_bcftools $3".BAM.sorted.rmdup" `pwd`  

echo "#% step five: "`date`", annotate mutations."  
Ann $3".BAM.sorted.rmdup.wxs.fb.vcf.gz"
Ann $3".BAM.sorted.rmdup.bcft.vcf.gz" 

echo "#% "`date`"  run ends."



