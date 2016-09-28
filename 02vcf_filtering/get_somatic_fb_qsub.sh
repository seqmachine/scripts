#Sep 19, 2016
#get somatic SNV by substracting germline-like control


#Sep 21, 2016 !!!!!!!!!


#re write file, put chr start end ref alt together
for file in `ls *.txt`
do 
	cat $file| grep -v "#" | grep -v -w "synonymous SNV" | grep "exonic" | grep -v "DP=1;" | grep -v "DP=2;" | grep -v "DP=3;" | grep -v "DP=4;" |awk '{print $1"_"$2"_"$3"_"$4"_"$5"\t"$0}' >$file".tag"
done



#control, germline like

#germ="DNANNFR1I160203-A8.rmdup.bam.bcft.vcf.gz.out.hg19_multianno.txt.tag"

germ="DNANNFR1I160203-A8.BAM.sorted.rmdup.wxs.fb.vcf.gz.out.hg19_multianno.txt.tag"


cat $germ |cut -f1 >$germ".id"


#get id only in tumor
for file in `ls *.tag`
do
	cat $file | cut -f1 >$file".id"
	cat $germ".id" | sort | uniq >$germ".id.u"
	cat $file".id" | sort | uniq >$file".id.u"
	cat $germ".id.u" $file".id.u" |sort |uniq -d > $file"@"$germ".shared"
	cat $file".id.u"  $file"@"$germ".shared" |sort | uniq -u >$file".id.somatic"	
done



#map id list to ann file
for file in `ls *.tag`
do
	cat $file".id.somatic" | awk -v INFILE=$file '{print "cat "INFILE"|grep -w "$1">> "INFILE".somatic.vcf"}' >$file".id.somatic.sh"
	chmod +x $file".id.somatic.sh"
	qsub -cwd -j y -b y ./$file".id.somatic.sh"
done


