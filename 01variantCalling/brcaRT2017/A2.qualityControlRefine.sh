#Feb 20. 2017

#--------------------------------------------
#capture ratio, reads sum
dir="1QC_01_readsSum"

mkdir -p $dir

for file in `ls 0.1bamFiles/*rmdup`
do
        #echo $file
	name=`basename $file`
	samtools view $file  | cut -f3 | sort | uniq -c | sort -k1 -n -r \
| awk '{print $2"\t"$1}' >$dir/$name".reads.sum"
        Rscript ../statR/chrStat4BRCA.R $dir/$name".reads.sum"

done


#--------------------------------------------
#depth vs coverage, detailed bed files!!!
dir="1QC_02_coverage"
mkdir -p $dir
default=40

for file in `ls 0.3mpileUps/*.up`
do
	name=`basename $file`
	cat $file |cut -f4 >$dir/$name".doc"
	Rscript ../statR/computeCoverage.R $dir/$name".doc" $default
	rm $dir/$name".doc"
	rm $dir/$name".doc.xls"
done >$dir/coverage.xls




#------------------------------------------------
#get refined putative deleterious of VUS(variants of unknown significance)

for file in `ls 0.4annotatedVariants/*.txt|grep snp`
do
#	echo $file
	../filterPDV_BRCA.sh $file snp
done

for file in `ls 0.4annotatedVariants/*.txt|grep indel`
do
#	echo $file
	../filterPDV_BRCA.sh $file indel
done





