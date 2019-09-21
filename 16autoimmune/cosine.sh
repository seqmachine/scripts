#Sep 21, 2019

pyDir="/home/tianr/dataset/2019.7.30-wholeblood-singleEND-RNA-seq-585G-117samples/test/python/"

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

#


#./cosine.sh interData/hla.SRR7656496.B interRef/B-fa/B52
#read
readDir=$1
#readDir="interData/"
name1=$2

#ref
refDir=$3
#refDir="interRef/B-fa/"
name2=$4
#hlaB-ars

dir1="interData/"$name1"_kmers/"
dir2="interRef/B-fa/"$name2"_kmers/"
#hlaA-ars.k11.txt
i=5
readLen=51

while [ $i -lt $readLen ]
do
	
	cosine=`computeCosine $dir1$name1".k"$i".txt" $dir2$name2".k"$i".txt"`
	echo $i"mer "$cosine	
	i=`expr $i + 2`
done

