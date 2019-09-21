echo `date`
#-a -M
#Sep 20, 2019 -all, report all possible mapped

root=$1
prefix="hla."
fullHLAref="/home/tianr/dataset/7.19autoimmune/hla_ref/hla-cDNA"

if [ -s $root"_1.fastq.gz" ] && [ -s $root"_2.fastq.gz" ]; then
	library="paired"
elif [ -s $root".fastq.gz" ]; then
	library="single"
else
	echo "input file format is wrong, naming not standard."
	exit 1
fi

if [ $library == "paired" ]; then
#multiple runs!!!
	bwa mem -a -t 20 $fullHLAref $root"_1.fastq.gz" $root"_2.fastq.gz" >$root".SAM"
elif [ $library == "single" ]; then
	bwa mem -a -t 20 $fullHLAref $root".fastq.gz" >$root".SAM"
else
	echo "mapping could not be done."
	exit 2
fi


#filter out unmapped reads
samtools view -h -F 4 $root".SAM" >$prefix$root".sam"
rm $root".SAM"
samtools view -bS $prefix$root".sam" > $prefix$root".bam"
rm $prefix$root".sam"


if [ $library == "paired" ]; then
	samtools fastq -N --threads 2 -c 9 -1 $prefix$root"_1.fastq.gz" -2 $prefix$root"_2.fastq.gz" $prefix$root".bam"
elif [ $library == "single" ]; then
	samtools fastq -N --threads 2 $prefix$root".bam" | gzip >$prefix$root".fastq.gz" 	
else
	echo "bam to fastq could not be done."
	exit 3
fi


echo "count reads, very raw!"
samtools view $prefix$root".bam" | cut -f3 | sort | uniq -c | sort -k1nr | awk '{print $2"\t"$1}' >$prefix$root".counts"

echo "extract reads by assigned HLA raw types"
mkdir -p interData

for gene in A B C DRB1 DQB1 DPB1
do

	echo ">HLA-"$gene" aligned reads" >interData/$prefix$root"."$gene".fasta"
	samtools view $prefix$root".bam" | grep "_$gene\*" | cut -f10 | grep -v "\*" >>interData/$prefix$root"."$gene".fasta"

done

date

 


#mkdir -p temp
#samtools view -bS $root".SAM" > $root".BAM"

#samtools sort -m 4G -@ 2 -T `pwd`"/temp/"$root".BAM.sorted" -o $root".BAM.sorted" $root".BAM"
#samtools rmdup $root".BAM.sorted" $root".BAM.sorted.rmdup"
#samtools index $root".BAM.sorted.rmdup"
#rm $root".SAM"
#rm $root".BAM"
#rm $root".BAM.sorted"

#samtools view $root".BAM.sorted.rmdup" | awk '{split($3, A, ":"); if (A[1]=="HLA") print $0}' >hla.$root".SAM"
#echo `date`


