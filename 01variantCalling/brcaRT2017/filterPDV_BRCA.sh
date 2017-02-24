#Feb. 5, 2017
#Feb 15, 2017
#Tian R.
outputDir=0.5refinedVariants

mkdir -p $outputDir
input=$1
type=$2


#get BRCA1.2
pattern="BRCA1:NM_007294:|BRCA2:NM_000059:"
#Feb 24, 2017



#pattern=":NM_000546:|NPM1:NM_002520"
#get TP53, NPM longest (more often used) transcript

cutoff=1.5
#1.5% lower VAF not reliable

#varscan2 output
#Feb 24, 2017


#http://www.genenames.org/cgi-bin/gene_symbol_report?hgnc_id=1101

#BRCA1:NM_007294:
#BRCA2:NM_000059:


minDP=10
#minfreq=0.03
minfreq=0.1



root=`basename -s ".BAM.sorted.rmdup.up."$type".gz.out.hg19_multianno.txt" $input`

zcat -f $input |awk '{if ($6=="exonic") print $0}' | grep -v -w "synonymous SNV" |grep -v nonframeshift \
| awk -F "\t" -v DP=$minDP -v FRQ=$minfreq '{split($60,a,":");if($12 <=FRQ && a[4]>=DP){print $0}}' \
| awk -F "\t" -v MIN=$cutoff '{split($60, A, ":");split(A[7], B, "%"); if (B[1] >=MIN) {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$9"\t"$10"\t"B[1]"%""\t"$11"\t"$12"\t"$13"\t"$60}}' \
|awk -F "\t" '{split($9,M,","); for (i in M) print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"M[i]"\t"$10"\t"$11"\t"$12"\t"$13"\t"substr($14,1,3)}' | grep -E $pattern >$outputDir/$root"."$type".xls"



#for file in `ls *indel*txt`; do ./getExonicVAF.sh $file "indel"; done
#for file in `ls *.BAM.*snp.gz.*txt`; do ./getExonicVAF.sh $file snp; done

