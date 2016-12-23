#Tian R.<tianremi{AT}gmail.com>
#Nov. 1, 2016
#Dec. 23, 2016
#what is noise, what is artifacts!!!


BwaPath=""
ref="/home/tianr/databases/refgenome/hg19/hg19.fa"
SamtPath=""

targetBed="/home/tianr/projects/01brca1-2/brca1-2.bed"
FreeBayesPath="/home/tianr/softwares/freebayes/bin/"
annPath="/home/tianr/softwares/annovar/"
VarScanPath="/home/tianr/softwares/VarScan.v2.3.9.jar"
minvarfreq=0.005


r1=$1
r2=$2
new=$3





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
	rm $1".BAM"
	$SamtPath"samtools" index $1".BAM.sorted.rmdup"

	bamfile=$1".BAM.sorted.rmdup"
	$SamtPath"samtools" mpileup -l $targetBed -f $ref $bamfile >$bamfile".up"

	}



Call_varscan2(){
	file=$1
	outdir=$2
	#min-var-freq!!!!
	alpha=$minvarfreq

	java -jar $VarScanPath mpileup2snp $file --min-var-freq $alpha --output-vcf 1 |gzip >$file".snp.gz"
	java -jar $VarScanPath mpileup2indel $file --min-var-freq $alpha --output-vcf 1 |gzip >$file".indel.gz"
	}


Call_freebayes(){

	bam=$1
	outdir=$2

	$FreeBayesPath"freebayes" -f $ref -t <(zcat -f $targetBed |grep "chr" |cut -f1-3) $bam |gzip >$outdir/$bam".wxs.fb.vcf.gz" 
	}


Ann(){
	inputVCF=$1

	perl $annPath"table_annovar.pl" <(zcat -f $inputVCF) \
$annPath"humandb/" -buildver hg19 -out $inputVCF".out" -remove \
-protocol refGene,cytoBand,esp6500siv2_all,snp138,ljb26_all \
-operation g,r,f,f,f -nastring . -vcfinput
}




ToBam $r1 $r2 $new

SortUniqueIndex $new


Call_freebayes $new".BAM.sorted.rmdup" `pwd`
Call_varscan2 $new".BAM.sorted.rmdup.up" `pwd`


Ann $new".BAM.sorted.rmdup.wxs.fb.vcf.gz"
Ann $new".BAM.sorted.rmdup.up.snp.gz"
Ann $new".BAM.sorted.rmdup.up.indel.gz"

#01 should be fastqc
mkdir -p 02ReadsSum
for file in `ls *rmdup`
do
	samtools view $file  | cut -f3 | sort | uniq -c | sort -k1 -n -r \
| awk '{print $2"\t"$1}' >02ReadsSum/$file".reads.sum"
	Rscript ../chrStat.R 02ReadsSum/$file".reads.sum"

done


