#Aug 19, 2019

#Aug 12, 2019

slicedFA="/home/tianr/dataset/7.19autoimmune/fastqFiles/SLE/sle665/8.9-mileup/classI-ARS.fa"

mkdir -p temp
cp $slicedFA temp
cat temp/classI-ARS.fa | sed "s/\*/@/g" >temp/classI-ARS.fasta
slicedFA="temp/classI-ARS.fasta"

#head $slicedFA

name=$1
wdir=`pwd`

#donor7

runOptiType(){

	root=$1 #root name of a file
	wdir=$2 #work dir 

	echo $root
	#echo $file
	#root=`basename -s ".fastq.gz" $file`
	gunzip $root"_1.fastq.gz"
	gunzip $root"_2.fastq.gz"

	#run at current dir
	
	docker run -v $wdir:/data/ -t fred2/optitype \
-i $root"_1.fastq" $root"_2.fastq"  \
--rna -v  -o /data/ -p $root 

	gzip $root"_1.fastq"
	gzip $root"_2.fastq"
	}


# check file exists and not empty
if [ -s $name"_result.tsv" ]
then
	echo "HLA typing was done before."	
	typing=`cat $name"_result.tsv"|grep -v "Reads" | cut -f2-7 |tr "\t" " " |sed "s/\*/@/g"`
	#echo $typing	
else
	echo $name"_result.tsv not found!"
	runOptiType $name $wdir
	typing=`cat $name"_result.tsv"|grep -v "Reads" | cut -f2-7 |tr "\t" " " |sed "s/\*/@/g"`
	#echo $typing

fi

#variable empty test
if [ -z "$typing" ]
then
	echo "must exit!"
	exit
else
	rm mylist mylist.txt
	
	for my_type in $typing
	do
		grep $my_type $slicedFA | head -n1 | sed "s/>//g" >>temp/$name"_mylist"
	done
	
	sort temp/$name"_mylist" | uniq > temp/$name"_mylist.txt"

fi 


targetedMapping(){
	#fetch fasta by seqtk

	#assignedHLA=mylist.txt	
	assignedHLA=$1
	seqtk subseq $slicedFA $assignedHLA | sed "s/@/*/g" >temp/$name"_assignedHLA.fa"

	#via bowtie2
	bowtie2-build temp/$name"_assignedHLA.fa" temp/$name"_assignedHLA"

	#mapping with bowtie2
	#7 min
	bowtie2 -x temp/$name"_assignedHLA" -1 $name"_1.fastq.gz"  -2 $name"_2.fastq.gz" -S $name".sam"
	samtools view -bS $name".sam" >$name".BAM"
	rm $name".sam"
}


#donor7
#"A\*34:02" "A\*66:01" "B\*57:03" "B\*39:10" "C\*07:01" "C\*12:03"
#donor1
#for my_type in "A\*02:01" "A\*68:02" "B\*07:02" "B\*15:10" "C\*03:04" "C\*04:01"
#for my_type in "A\*30:01" "A\*36:01" "B\*53:01" "B\*53:01" "C\*04:01" "C\*04:01"


SamtPath=""
SortUniqueIndex(){
	$SamtPath"samtools" sort -m 4G -T `pwd`"/temp/"$1".BAM.sorted" -o $1".BAM.sorted" $1".BAM"
        
	$SamtPath"samtools" rmdup $1".BAM.sorted" $1".BAM.sorted.rmdup"
        $SamtPath"samtools" index $1".BAM.sorted.rmdup"
	#PCR multiplex

	rm  $1".BAM.sorted" $1".BAM"
        }


#so called unique by excluding XS, 1520
#mapq=10

selectByMAPQ(){
	dir=$1
	mapq=$2

	mkdir -p $dir
	samtools view $name".BAM.sorted.rmdup" | grep "HLA:HLA" | grep "AS:i" | awk -v Q=$mapq '{if($5 < Q) print $0}'  \
|samtools view -b -T temp/$name"_assignedHLA.fa" > $dir/$name".MAPQ"$mapq".bam"

	samtools fastq -N -c 9 -@ 4 -1 $dir/$name".MAPQ"$mapq"_1.fastq.gz" -2 $dir/$name".MAPQ"$mapq"_2.fastq.gz" $dir/$name".MAPQ"$mapq".bam"
	}


mapq=10
targetedMapping temp/$name"_mylist.txt"
rm temp/$name"_mylist"

SortUniqueIndex $name

selectByMAPQ $name"_outFQ" $mapq

cd $name"_outFQ"

runOptiType $name".MAPQ"$mapq `pwd`
cd ..

echo $name"_result.tsv"
head $name"_result.tsv"
ls $name"_outFQ"/*".tsv"
head $name"_outFQ"/*".tsv"

#samtools mpileup -f $name"_assignedHLA.fa" -A -B $name".BAM.sorted.rmdup" >$name".mup"
#30 min

