#Sep 26, 2016
#Tian R.
#pipeline for QuanDev CNV detection for a cohort of small panel targeted exome seq data

#########################################################
#step 1: do doc on grid engine

#for file in `ls *bam`; do qsub -cwd -l vf=20G,p=2 -j y -b y "./depth180.sh $file"; done


##########################################################
#step 2: after all jobs finished, do data aggregation

fileList=$1

touch interm

touch out

for sample in `cat $fileList |tr "\n" " "` 

do
	python read_firstline.py $sample".doc" >$sample".doc.nr" 
	cat $sample".doc.nr" |cut -f6 > $sample".doc.nr.f6"	
	paste interm $sample".doc.nr.f6" >out
	cat out > interm #update interm	

done

firstSample=`cat $fileList |head -n1`".doc.nr"

paste <(cat $firstSample |cut -f1-4) out >12_sample.doc

rm out interm

#########################################################
#step 3: run R

#less 180.cnv | awk -F "\t" '{for(i=5;i<NF;i++) {if ($i >=2.5 || $i <= -2.5) {print $0} }}' >180.cnv2
#rm 180.cnv

#less cnv.info | grep -E 'loss|gain' | sort | uniq > cnv.info2
#rm cnv.info 

