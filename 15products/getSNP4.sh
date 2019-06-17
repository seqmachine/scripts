#Jan 17, 2019

#May 7, 2019
#mpileup argument, BAQ too stringgent, shoud loose, other wise lose SNPs

mkdir -p temp

fq1=$1
fq2=$2
name=$3
#mom.ht01

#ref="/Users/tianr/0projects/Constants/bedFiles/humanTalent/ht01.fa"
#ref="/home/tianr/biodatabases/indexes/humanTalent_ht01/ht01.fa"
ref="/home/tianr/biodatabases/indexes/bwa/hg38ref/hg38"

BWAalign(){
	bwa mem -a -M $ref  $fq1 $fq2 >$name".SAM" 

	#take mapped
	cat $name".SAM" | grep chr > $name".SAM.mapped"
	rm $name".SAM"

	#SAM to BAM
	samtools view -bS $name".SAM.mapped" >$name".BAM"
	rm $name".SAM.mapped"
	}

SortUniqueIndex(){
	$SamtPath"samtools" sort -m 4G -T `pwd`"/temp/"$1".BAM.sorted" -o $1".BAM.sorted" $1".BAM"
        
	#$SamtPath"samtools" rmdup $1".BAM.sorted" $1".BAM.sorted.rmdup"
        #$SamtPath"samtools" index $1".BAM.sorted.rmdup"
	#PCR multiplex
	$SamtPath"samtools" index $1".BAM.sorted"

	#rm  $1".BAM.sorted"
        }


#SamtPath="/Users/tianr/3software.orginal/bioinfo/samtools-1.9/"
SamtPath=""

lociFile="/home/tianr/pipelines/getSNP/25loci.txt"

less $lociFile | awk -F "\t" '{print "chr"$3"\t"$4}' >$lociFile".pos"


alignPileup(){
	BWAalign
	#sort, rmdump
	SortUniqueIndex $name
	rm $name".BAM"

	#why mpileup does not work????
	#mpileup to check very position in interest!!!!
	#$SamtPath"samtools" mpileup -f $ref".fa" $name".BAM.sorted.rmdup" >$name".BAM.sorted.rmdup.mup"

	#-B, no BAQ
	#-A, do not discard anomalous read pairs	
	$SamtPath"samtools" mpileup -f $ref".fa" -A -B -l $lociFile".pos" $name".BAM.sorted" >$name".BAM.sorted.rmdup.mup"
	}

alignPileup

echo "Call SNPs now--------"

#echo $ref
#echo $name
#freebayes -f $ref".fa" $name".BAM.sorted.rmdup" |gzip > $name".all.vcf"


file=$name".BAM.sorted.rmdup.mup"
VarScanPath="/home/tianr/software/VarScan.v2.3.9.jar"

#minvarfreq=0 for germline genotyping

alpha=0.2 #ratio of alt, 0(ref homozygote),0.5(hetero),1(alt homozygote)

#strandSelection=0 #--strand-filter 1, ignore 90%; 0 means off
beta=0

#calls all positions, regardless of SNPs
java -jar $VarScanPath mpileup2cns $file --min-var-freq $alpha --strand-filter $beta --output-vcf 1 >$file".vcf"

#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  Sample1
#chr11   636627  .       C       .       .       PASS    ADP=0;WT=0;HET=0;HOM=0;NC=1     GT:GQ:SDP:DP:RD:AD:FREQ:PVAL:RBQ:ABQ:RDF:RDR:ADF:ADR    ./.:.:0

#April 28, 2019
#use "fake" ref genome file is no good, as the cluster is available, no need to compromise on hardwares

zless $file".vcf"| grep -v "#" >$file".vcf2"
# why there are so many SNPs are misssing????

echo "Get SNPs:"

#lociFile="/Users/tianr/0projects/Constants/bedFiles/humanTalent/25loci.txt"
lociFile="/home/tianr/pipelines/getSNP/25loci.txt"
#intergenic(CREB1 LOC151194)	ht014675690	2	207643083
#OXTR	ht0153576	3	8762685
#CLSTN2	ht016439886	3	139963653
#GATA2	ht019854612	3	128538371

python /home/tianr/pipelines/getSNP/readVCF2genotypes.py $lociFile $file".vcf2">$name".xls"
rm $file".vcf2"

#May 27, 2019 add minus strand corrections
python /home/tianr/pipelines/getSNP/correctMinusStrand.py $name".xls" > $name".adj.xls"

#cat $lociFile | awk -F "\t" '{print "chr"$3"_"$4"\t"$2"\t"$1}' >25loci.txt.tab
#vcfFile=$file".vcf"
#cat $vcfFile | awk '{print $1"_"$2"\t"$4"\t"$5}' >$vcfFile".tab"
#join -1 1 -2 1 <(sort -k1 25loci.txt.tab) <(sort -k1 $vcfFile".tab") > $vcfFile".out"



