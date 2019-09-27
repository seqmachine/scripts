#Sep 21, 2019
#B*refdir="interRef/"$antigen"-fa"

#Sep 24, 2019

workdir=`pwd`

name=$1
#threads for bowtie2
td=12

#refdirectory for ref, inter
antigen=$2
#antigen="B"
refdir="interRef/"$antigen"-fa"
mkdir -p $refdir

interdir="interData"
mkdir -p $interdir
i=9 #kmer min
cutoff=3 #kmer cutoff coverage
readLen=51
optimalK=39

pyDir="/home/tianr/dataset/2019.7.30-wholeblood-singleEND-RNA-seq-585G-117samples/test/python/"

#pyDir="./python/"


#zless /home/tianr/biodatabases/hla/hla_nuc.fasta.gz |tr " " "_" >./python/refData/hla_cDNA.fasta

#fullHLAref="/home/tianr/dataset/2019.7.30-wholeblood-singleEND-RNA-seq-585G-117samples/test/python/refData/hla_cDNA"
#fullHLAref="./python/refData/hla-cDNA"
fullHLAref="/home/tianr/dataset/7.19autoimmune/hla_ref/hla-cDNA"

#fullHLAref="./python/refData/hla-class1-ARS"


output=$name"."$antigen".tsv"
[ -f $output ] && rm $output
touch $output


computeCosine(){
	file1=$1
	file2=$2
	#make union k mers
    
    #in case file is empty
    #both not empty
    if [ -s $file1 ] && [ -s $file2 ];then
	    cat <(cut -d " " -f1 $file1) <(cut -d " " -f1 $file2) | sort | uniq >allKmers.txt
	    join -1 1 -2 1 -t " " -a 1 -e "0" -o 1.1,2.2 <(sort -k1 allKmers.txt) <(sort -k1 $file1) |cut -d " " -f2 >$file1".vct"
    	join -1 1 -2 1 -t " " -a 1 -e "0" -o 1.1,2.2 <(sort -k1 allKmers.txt) <(sort -k1 $file2) |cut -d " " -f2 >$file2".vct"
	    #echo $file1" "$file2
	    python $pyDir"calculateSimilarity.py" $file1".vct" $file2".vct"
	    rm allKmers.txt
    else
        echo "0"
    fi

	#rm $file1 $file2
	}	


typing(){
    antigen=$1
    prefix=$2
    if [ $antigen == "A" ];then
        agList="01 02 03 11 23 24 25 26 29 30 31 32 33 34 36 43 66 68 69 74 80"     
    elif [ $antigen == "B" ];then
        agList="07 08 13 14 15 18 27 35 37 38 39 40 41 42 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 67 73 78 81 82 83"
    elif [ $antigen == "C" ];then
        agList="01 02 03 04 05 06 07 08 12 14 15 16 17 18"
    fi

    #for i in 08
    for i in $agList
    do
        #echo "kmer B"$i >
        [ -f $interdir/$antigen$i".tab" ] && rm $interdir/$antigen$i".tab"
        touch $interdir/$antigen$i".tab"
        #pwd
        #echo "B"$i" "`./cosine.sh interData/ $name".B" interRef/B-fa/ "B"$i` >>interData/"B"$i".tab"
        echo $antigen$i" "`computeCosine $interdir/$prefix"_kmers/"$prefix".k39.txt" $refdir/$antigen$i"_kmers/"$antigen$i".k39.txt"` >>$interdir/$antigen$i".tab"
    done


    geno1=`cat interData/$antigen*".tab" |sort -k2nr |head -n1 |cut -d " " -f1`
    cat $interdir/$antigen*".tab" |sort -k2nr >>$output
    echo "################################################################">>$output
    #rm interData/$antigen*".tab" 
    #echo "################"
    echo $geno1
    #echo "###############"
    }


###################################################################################################################################
echo "@INFO: start first allele typing."

typing $antigen $name"."$antigen

echo ">"$geno1" filtered out" >$interdir/$geno1".rm.fasta"

targetedMapping(){
	#fetch fasta by seqtk

	#assignedHLA=mylist.txt	
	wdir=$1
    #wdir=interRef/B-fa/
    geno1=$2
	library=$3
	#single, or paired

	#seqtk subseq $slicedFA $assignedHLA | sed "s/@/*/g" >temp/$name"_assignedHLA.fa"

	#via bowtie2
	bowtie2-build $wdir$geno1".fasta" $wdir$geno1

	#mapping with bowtie2
	#7 min
	if [ $library == "single" ];then
		echo $library
		bowtie2 --all --threads $td -x $wdir$geno1 -U $name".fastq.gz" -S $name".sam"
	elif [ $library == "paired" ];then
		echo $library
		bowtie2 --all --threads $td -x $wdir$geno1 -1 $name"_1.fastq.gz"  -2 $name"_2.fastq.gz" -S $name".sam"
    elif [ $library == "fasta" ];then
        #use fasta as input
        bowtie2 --all --threads $td -x $wdir$geno1 -f  $interdir/$name"."$antigen".fasta" -S $name".sam"
        #unmapped
        samtools view -f4 $name".sam" |cut -f10 >>$interdir/$geno1".rm.fasta"
        rm $name".sam"

	else
		echo "@info: targetted mapping, needs to state library type, single or paired end!"
		exit 4
	fi
		
	#samtools view -bS $name".sam" >$name".BAM"
	#rm $name".sam"
}

targetedMapping $refdir"/" $geno1 "fasta"

kmer(){

#cp binary into /user/local/bin/

name=$1
#optimalK=`expr $readLen - 2`
#K39
#optimalK=`expr $readLen - 12`

suffix=$2
#fastq.gz
#paired
#fasta
#fa

if [ $suffix == ".fastq.gz" ];then
	type=".fastq"
elif [ $suffix == ".fasta" ];then
	type=""
elif [ $suffix == ".fa" ];then
	type=""
else
	echo "input file type should be fastq.gz, fasta, fa!"
	exit 1
fi

dir=$name"_kmers"
mkdir -p $dir

#while [ $i -lt $readLen ]
#do
    #use 39mer
i=$optimalK
#echo $i
dsk -file $name$suffix -kmer-size $i -abundance-min $cutoff -out-dir $dir >/dev/null
mv $dir/$name$type".h5" $dir/$name".k"$i$type".h5"
dsk2ascii -file $dir/$name".k"$i$type".h5" -out $dir/$name".k"$i".txt" >/dev/null
rm  $dir/$name".k"$i$type".h5"

	#i=`expr $i + 2`
#done

}

generateKmerReads(){
    echo "generate kmers for B ref and B regions reads."
    prefix=$1
    cp kmer.sh $interdir
    cd $interdir
    #./kmer.sh $name".B" ".fasta"
    kmer $prefix ".fasta"
    rm kmer.sh 
    cd ..

}

generateKmerReads $geno1".rm"
second=`typing $antigen $geno1".rm"`
#./cosine.sh interData/ $geno1".rm" interRef/B-fa/ "B81"

echo "#HLA typing is :" >>$output
echo $geno1" "$second >>$output
