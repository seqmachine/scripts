#Feb. 5, 2017
#Feb 15, 2017
#Tian R.
outputDir=0.5refinedVariants

mkdir -p $outputDir
input=$1
type=$2

pattern=":NM_000546:|NPM1:NM_002520"
#get TP53, NPM longest (more often used) transcript

cutoff=1.5
#1.5% lower VAF not reliable


root=`basename -s ".BAM.sorted.rmdup.up."$type".gz.out.hg19_multianno.txt" $input`

cat $input |grep exonic | awk -F "\t" -v MIN=$cutoff '{split($60, A, ":");split(A[7], B, "%"); if (B[1] >=MIN) {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$9"\t"$10"\t"B[1]"%"}}' |
awk -F "\t" '{split($9,M,","); for (i in M) print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"M[i]"\t"$10}' | grep -E $pattern >$outputDir/$root"."$type".xls"



#for file in `ls *indel*txt`; do ./getExonicVAF.sh $file "indel"; done
#for file in `ls *.BAM.*snp.gz.*txt`; do ./getExonicVAF.sh $file snp; done

