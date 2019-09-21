#Sep 19, 2019
#dsk, a k-mer generator other than jellyfish

#cp binary into /user/local/bin/

name=$1

i=5
readLen=51
dir=$name"_kmers"

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


mkdir-p $dir

while [ $i -lt $readLen ]
do
	echo $i
	dsk -file $name$suffix -kmer-size $i -out-dir $dir
	mv $dir/$name$type".h5" $dir/$name".k"$i$type".h5"
	dsk2ascii -file $dir/$name".k"$i$type".h5" -out $dir/$name".k"$i".txt"
	rm  $dir/$name".k"$i$type".h5"

	i=`expr $i + 2`
done
