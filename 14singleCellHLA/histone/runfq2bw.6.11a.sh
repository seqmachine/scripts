for file in `ls *fastq.gz`
do 
	name=`echo $file |cut -d "." -f1`
	#echo  `wc -c <$name".bw"`
	if [ -s $name".bw" ] && [ `wc -c <$name".bw"` -gt 384 ]
	then
		echo $name".bw" exists
		#./fq2bw--nomodel.sh $name
	else
		echo $name".bw" do not exist or .bw is 384 bytes
		./fq2bw--nomodel.sh $name

	fi
done 
