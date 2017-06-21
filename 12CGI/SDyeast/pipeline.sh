#May 5, 2017
#processor=8
#around 2 hours

#major bug is with crossOver.py
#very sensitive to segfile!!!

#May 8, 2017
#gc_maker.py bug, Shaliu tackled.
#more tests on more data is necessary!!!

#May 24, 2017
#enable CGI
#www-data previliage


#May 25, 2017
#www-data previliage problem
#typo


#path="/home/zhanglab/Desktop/01yeast/"

#target = "/var/www/data/"

#target="/home/zhanglab/Desktop/rawData/"

#base="WT1"
catchup=`ls /var/www/data/*.gz |cut -d "_" -f1 | awk '{print substr($0, 1, (length($0)-1))}' | sort | uniq`

base=`basename $catchup` 
baseCap=`basename $catchup | awk '{print toupper($0)}'`



mkdir -p /var/www/data/$baseCap"_results/"

#mkdir -p $target$baseCap"_results"

for id in a b c d
do
	name=$base$id
	echo $name
	if test -e "/var/www/data/"$name*"_"*".fq.gz"; then
		zless "/var/www/data/"$name*"_"*".fq.gz" >"/var/www/data/"$baseCap$id".fastq"
	fi

 	if test -e "/var/www/data/"$name*"_"*".fastq.gz"; then
                zless "/var/www/data/"$name*"_"*".fastq.gz" >"/var/www/data/"$baseCap$id".fastq"
        fi

done
rm /var/www/data/*.fq.gz
rm /var/www/data/*.fastq.gz

#March 22, 2017
#Tian R.

#dependencies

#takes around 1 h for 1G fq.gz file
python ReadAligner_v2.2/readAligner_bioobc.py $baseCap

cp -r ReadAligner_v2.2/$baseCap GenotypeCaller_v2.2/input/
rm -r ReadAligner_v2.2/$baseCap/*
rmdir ReadAligner_v2.2/$baseCap/

cd GenotypeCaller_v2.2/ 

python genotypeCaller.py $baseCap

cd ..

cp  GenotypeCaller_v2.2/output/$baseCap/$baseCap".txt" CrossOver_v6.3/segfiles/
#rm -r GenotypeCaller_v2.2/output/*
rm -r GenotypeCaller_v2.2/input/*


echo "INFO: run crossover......................................."

cd CrossOver_v6.3/
python crossOver.py $baseCap
cp out/$baseCap/* /var/www/data/$baseCap"_results/"


echo "INFO: R plotting ......................................."

#plot R
cd ..

cd PlotSeg_v1.0/

Rscript plotTetradSeg.R $baseCap
cp *pdf /var/www/data/$baseCap"_results/"
rm *pdf
#rm ../CrossOver_v6.3/segfiles/*
rm -r ../CrossOver_v6.3/out/*



#/home/zhanglab/Desktop/rawData/$base"_results/"
cd ..

#make sure rm old results
rm -r /var/www/html/$baseCap"_results/" 
mv /var/www/data/$baseCap"_results/" /var/www/html

echo "open localhost/"$baseCap"_results/ for results!"

#rm uploaded files in /var/www/data directory:
rm /var/www/data/*.fastq
