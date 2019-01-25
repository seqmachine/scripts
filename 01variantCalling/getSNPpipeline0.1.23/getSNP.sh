#Jan 17, 2019

mkdir -p temp

fq1=$1
fq2=$2
name=$3
#mom.ht01

ref="/Users/tianr/0projects/Constants/bedFiles/humanTalent/ht01.fa"



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
        $SamtPath"samtools" rmdup $1".BAM.sorted" $1".BAM.sorted.rmdup"
        $SamtPath"samtools" index $1".BAM.sorted.rmdup"
	rm  $1".BAM.sorted"
        }


SamtPath="/Users/tianr/3software.orginal/bioinfo/samtools-1.9/"


BWAalign
#sort, rmdump
SortUniqueIndex $name
rm $name".BAM"

freebayes -f $ref  $name".BAM.sorted.rmdup" |gzip > $name".all.vcf.gz"

zless $name".all.vcf" | grep -v "#" | awk '{if ($2==150) print $0}' >$name".vcf"

echo "Get SNPs:"

lociFile="/Users/tianr/0projects/Constants/bedFiles/humanTalent/25loci.txt"

python readVCF.py $lociFile $name".vcf" >$name".xls"


#why mpileup does not work????
#mpileup
#$SamtPath"samtools" mpileup -f $ref mom.ht01.BAM.sorted.rmdup >mom.ht01.mpileup


