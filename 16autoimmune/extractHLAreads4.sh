echo `date`
#-a -M
#Sep 20, 2019 -all, report all possible mapped

root=$1
prefix="hla."
i=9
cutoff=3
readLen=51
optimalK=39


interdir="interData"
rm -r $interdir
mkdir -p $interdir

for antigen in "A" "B" "C"
do
    refdir="interRef/"$antigen"-fa"
    rm -r $refdir
    mkdir -p $refdir
done


#fullHLAref="./python/refData/hla-class1-ARS"

zless /home/tianr/biodatabases/hla/hla_nuc.fasta.gz |tr " " "_" >./python/refData/hla_cDNA.fasta

fullHLAref="/home/tianr/dataset/7.19autoimmune/hla_ref/hla-cDNA"
#fullHLAref="./python/refData/hla-cDNA"
#library="paired"

#cd ./python/refData/
#bwa index -a is -p hla-class1-ARS hla-class1-ARS.fasta
#bwa index -a is -p hla_cDNA hla_cDNA.fasta
#cd ../../


fq2SAM(){
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
}

extractHLAreads(){
#filter out unmapped reads
samtools view -h -F 4 $root".SAM" >$prefix$root".sam"
rm $root".SAM"
samtools view -bS $prefix$root".sam" > $prefix$root".bam"
rm $prefix$root".sam"
#}

if [ $library == "paired" ]; then
	samtools fastq -N --threads 2 -c 9 -1 $prefix$root"_1.fastq.gz" -2 $prefix$root"_2.fastq.gz" $prefix$root".bam"
elif [ $library == "single" ]; then
	samtools fastq -N --threads 2 $prefix$root".bam" | gzip >$prefix$root".fastq.gz" 	
else
	echo "bam to fastq could not be done."
	exit 3
fi
}

#echo "count reads, very raw!"
#samtools view $prefix$root".bam" | cut -f3 | sort | uniq -c | sort -k1nr | awk '{print $2"\t"$1}' >$prefix$root".counts"

#echo "extract reads by assigned HLA raw types"


assignReadByAg(){
#for gene in A
for gene in A B C DRB1 DQB1 DPB1
do

	echo ">HLA-"$gene" aligned reads" >$interdir/$prefix$root"."$gene".fasta"
	samtools view $prefix$root".bam" | grep "_$gene\*" | grep "NM:i:0" |awk '{if ($10 != "*"){print ">"$1"\n"$10}}' >>$interdir/$prefix$root"."$gene".fasta"

done
}



get2dRef(){
    #for i in 07
    #echo "get two digits B fasta from HLA ref files."
    antigen=$1

    refdir="interRef/"$antigen"-fa"
    mkdir -p $refdir



    if [ $antigen == "A" ];then
        agList="01 02 03 11 23 24 25 26 29 30 31 32 33 34 36 43 66 68 69 74 80"     
    elif [ $antigen == "B" ];then
        agList="07 08 13 14 15 18 27 35 37 38 39 40 41 42 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 67 73 78 81 82 83"
    elif [ $antigen == "C" ];then
        agList="01 02 03 04 05 06 07 08 12 14 15 16 17 18"
    fi
    
    echo "@INFO: extract two digit reference "$antigen" from total HLA ref."

    for i in $agList
    do
        python python/getFastaByID.py $fullHLAref".fasta" $antigen"*"$i >$refdir/$antigen$i".fasta"

    done
}

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


generateKmer(){
    pre=$1
    
    #cp kmer.sh $interdir
    cd $interdir
    echo "@INFO: current directory is:"
    pwd
    echo $pre".fasta"
    kmer $pre ".fasta"
    #./kmer.sh $prefix ".fasta"
    #rm kmer.sh
    cd ../
   }

genereteKmerReads(){
    refdir=$1
    cd $refdir
    echo "@INFO: current directory is:"
    pwd
    echo "@INFO: HLA ref fasta files are:"
    echo `ls *fasta`
    #cp kmer.sh $refdir
    for x in `ls *.fasta |cut -d "." -f1`
    do
        #echo $x
        #head $x".fasta"
        kmer $x ".fasta"
        #./kmer.sh $x ".fasta"
    done
    cd ../../

}


echo "@INFO: start mapping to HAL full reference:"
fq2SAM
echo "@INFO: start extracting reads via antigens:"
extractHLAreads
assignReadByAg

KbyAg(){
    antigen=$1
    get2dRef $antigen
    generateKmer $prefix$root"."$antigen

    refdir="interRef/"$antigen"-fa"
    genereteKmerReads $refdir
}
 
KbyAg "A"
KbyAg "B"
KbyAg "C"

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


