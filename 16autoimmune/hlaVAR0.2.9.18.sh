#TianR <> Aug 23, 2019
#Aug 19, 2019
#Aug 12, 2019
#Sep 6, 2019

echo "@info: This script needs optitypENV, so prior to running, source/conda activate optitypeENV."

slicedFA="/home/tianr/dataset/7.19autoimmune/fastqFiles/SLE/sle665/8.9-mileup/classI-ARS.fa"
#Aug 22, 2019 life saver
#"source activate optitypeENV"

optiCMD="/home/tianr/tools/optitype/bin/OptiTypePipeline.py"

mkdir -p temp
cp $slicedFA temp
cat temp/classI-ARS.fa | sed "s/\*/@/g" >temp/classI-ARS.fasta
slicedFA="temp/classI-ARS.fasta"

#head $slicedFA

#running config
#threads, cores
td=6
mem=4G
#Sep 9, 2019
#strip harder 0, 1, 2

editingDistance=1

#file root name
name=$1

wdir=`pwd`
#library=$2
#library="single"
#library="paired"


checkDynamicFileSize(){

	file=$1
	#1s 1m 1h
	interval=$2

	if [ ! -s $file ];then
		echo $file" not exist!"
		exit 1
	else
		size=$(wc -c <$file)
		sleep $interval
		sizeNow=$(wc -c <$file)

		while [  $size != $sizeNow ]
		do
			size=$(wc -c <$file)
			#echo $size
			sleep $interval
			sizeNow=$(wc -c <$file)

		done 

		#echo $file" final size: "$size
		#return 0
		echo $size
	fi
	}


#echo `checkDynamicFileSize $1 2s`

#get seq data type, single or paired
#follow strict formats
if [ -s $name".fastq.gz" ]; then
	date
	echo "@info: seems that "$name".fastq.gz is sinlge end. Now, checking input file is intact or not."
	fileSize=`checkDynamicFileSize $name".fastq.gz" 30s`
	#variable not empty
	if [ ! -z $fileSize ]; then 
		library="single"
	else
		exit
	fi
elif [ -s $name"_1.fastq.gz" ] && [ -s $name"_2.fastq.gz" ]; then
	date
	echo "@info: seems that "$name"_1.fastq.gz and "$name"_2.fastq.gz is paired end. Now, checking input files are intact or not."
	fileSize1=`checkDynamicFileSize $name"_1.fastq.gz" 30s`
        fileSize2=`checkDynamicFileSize $name"_2.fastq.gz" 30s`
	if [ ! -z $fileSize1 ] && [ ! -z $fileSize2 ]; then
		library="paired"
	else
		exit
	fi
else
	date
	echo "input file naming does not follow rules."
	exit 1
fi 

runOptiType(){

	root=$1 #root name of a file
	wdir=$2 #work dir 

	echo $root
	#echo $file
	#root=`basename -s ".fastq.gz" $file`
	
	gunzip $root"_1.fastq.gz"
	gunzip $root"_2.fastq.gz"

	#run at current dir
	python $optiCMD --input $root"_1.fastq" $root"_2.fastq" --rna --outdir $wdir --prefix $root --verbose
	#docker run -v $wdir:/data/ -t fred2/optitype -i $root"_1.fastq" $root"_2.fastq" --rna -v  -o /data/ -p $root 

	gzip $root"_1.fastq"
	gzip $root"_2.fastq"
	}

runOptiTypeSingleEND(){

        root=$1 #root name of a file
        wdir=$2 #work dir 

        echo $root
        #echo $file
        #root=`basename -s ".fastq.gz" $file`
        gunzip $root".fastq.gz"
        #gunzip $root"_2.fastq.gz"

        #run at current dir
        python $optiCMD --input $root".fastq" --rna --outdir $wdir --prefix $root --verbose

        #docker run -v $wdir:/data/ -t fred2/optitype -i $root".fastq" --rna -v  -o /data/ -p $root 

        gzip $root".fastq"
        }



#if [  -s $name".fastq.gz" ] || [  -s $name"_1.fastq.gz" ]; then	
#	echo $name".fastq.gz already there"
#	#fastq-dump $name".sra" --gzip 
#else
#fi


# check file exists and not empty
if [ -s $name"_result.tsv" ]
then
	echo "HLA typing was done before."	
	typing=`cat $name"_result.tsv"|grep -v "Reads" | cut -f2-7 |tr "\t" " " |sed "s/\*/@/g"`
	#echo $typing	
else
	echo $name"_result.tsv not found!"
	if [ $library == "single" ]; then
		date
		echo "@info: starting HLA typing for "$name", sinlge end......"	
		runOptiTypeSingleEND $name $wdir
		date
		echo "@info: HLA typing done for "$name"."
	elif [ $library == "paired" ]; then
		echo $name
		echo $wdir
		echo "@info: starting HLA typing for "$name", paired end......"
		runOptiType $name $wdir
		date
		echo "@info: HLA typing done for "$name"."
	else
		echo "@info: HLA typing could not be run. seq library type unclear."
		exit 2
	fi 

	typing=`cat $name"_result.tsv"|grep -v "Reads" | cut -f2-7 |tr "\t" " " |sed "s/\*/@/g"`
	#echo $typing

fi

#variable empty test
if [ -z "$typing" ]
then
	echo "@info: HLA typing not successful, must exit!"
	exit 3
else
	[ -s mylist ] && rm mylist
	[ -s mylist.txt ] && rm mylist.txt
	#rm mylist mylist.txt
	
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
	library=$2
	#single, or paired

	seqtk subseq $slicedFA $assignedHLA | sed "s/@/*/g" >temp/$name"_assignedHLA.fa"

	#via bowtie2
	bowtie2-build temp/$name"_assignedHLA.fa" temp/$name"_assignedHLA"

	#mapping with bowtie2
	#7 min
	if [ $library == "single" ];then
		echo $library
		bowtie2 --threads $td -x temp/$name"_assignedHLA" -U $name".fastq.gz" -S $name".sam"
	elif [ $library == "paired" ];then
		echo $library
		bowtie2 --threads $td -x temp/$name"_assignedHLA" -1 $name"_1.fastq.gz"  -2 $name"_2.fastq.gz" -S $name".sam"

	else
		echo "@info: targetted mapping, needs to state library type, single or paired end!"
		exit 4
	fi
		
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
	$SamtPath"samtools" sort --threads $td -m $mem -T `pwd`"/temp/"$1".BAM.sorted" -o $1".BAM.sorted" $1".BAM"
        
	$SamtPath"samtools" rmdup $1".BAM.sorted" $1".BAM.sorted.rmdup"
        $SamtPath"samtools" index $1".BAM.sorted.rmdup"
	#PCR multiplex

	rm  $1".BAM.sorted" $1".BAM"
        }


#so called unique by excluding XS, 1520
#mapq=10

RecycleReads(){
	dir=$1
	library=$2
	
	mkdir -p $dir

	#strip perfect match:
	samtools view $name".BAM.sorted.rmdup" | grep "HLA:HLA" | grep "AS:i:" | grep "NM:i:0" \
|samtools view -b -T temp/$name"_assignedHLA.fa" > $dir/$name".0.bam"
	samtools view $name".BAM.sorted.rmdup" | grep "HLA:HLA" | grep "AS:i:" | grep -w "NM:i:1" \
|samtools view -b -T temp/$name"_assignedHLA.fa" > $dir/$name".1.bam"
	samtools view $name".BAM.sorted.rmdup" | grep "HLA:HLA" | grep "AS:i:" |grep -v "NM:i:0" |grep -v -w "NM:i:1"\
| samtools view -b -T temp/$name"_assignedHLA.fa" > $dir/$name".x.bam"

	for k in "0" "1" "x"
	do
		if [ $library == "paired" ]; then
			samtools fastq -N -c 9 --threads $td -1 $dir/$name"."$k"_1.fastq.gz" -2 $dir/$name"."$k"_2.fastq.gz" $dir/$name"."$k".bam"
		elif [ $library == "single" ]; then
			samtools fastq -N --threads $td $dir/$name"."$k".bam" |gzip >$dir/$name"."$k".fastq.gz"
		else
			echo "@info: filter read via partial.matched, needs to state library type: single or paired end!"
			exit 5
		fi
	
	done
}



#mapq=10

rm temp/$name"_mylist"

if [ -s  $name".BAM.sorted.rmdup" ];then
	echo "sort uniq already done."
else
	date
	echo "@info: starts targetted mapping against first round assigned HLA types."
	targetedMapping temp/$name"_mylist.txt" $library
	SortUniqueIndex $name
	date
	echo "@info: finished targetted mapping against first round assigned HLA types."
fi

if [ -s $name".partial.matched"*".fastq.gz" ];then
	echo `ls $name".partial.matched"*".fastq.gz"`
else
	date
	echo "@info: read filtering via partial.matched........ "
	#FilterPartialMatchedReads $name"_outFQ" $library $editingDistance
	RecycleReads $name"_outFQ" $library 
	date
	echo "@info: read filtering via partial.matched, done. "
fi

cd $name"_outFQ"

if [ $library == "single" ]; then
	runOptiTypeSingleEND $name".0" `pwd`
	runOptiTypeSingleEND $name".1" `pwd`
	runOptiTypeSingleEND $name".x" `pwd`

elif [ $library == "paired" ]; then
	runOptiType $name".0" `pwd`
	runOptiType $name".1" `pwd`
	runOptiType $name".x" `pwd`

else
	echo "@info: partial.matched series not run."
	exit 6
fi 

cd ..

echo $name"_result.tsv"
head $name"_result.tsv"
ls $name"_outFQ"/*".tsv"
head $name"_outFQ"/*".tsv"

#samtools mpileup -f $name"_assignedHLA.fa" -A -B $name".BAM.sorted.rmdup" >$name".mup"
#30 min

