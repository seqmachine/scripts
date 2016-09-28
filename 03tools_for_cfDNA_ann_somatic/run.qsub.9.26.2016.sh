#Sep 21, 2016
#6:00pm
#11:30 pm, second time, vcf

#Sep 23, 2016, 1hr
#Sep 26, 2016


file_list=$1

for file in `cat $file_list |tr "\n" " "`

do
	echo $file
	qsub -cwd -l vf=20G,p=2 -j y -b y "./varscan.somatic.sh $file"	
done
