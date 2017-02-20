#Feb 14, 2017
#Feb 20, 2017

dir="0.4annotatedVariants/"

for file in `ls $dir*indel*txt`; do ./getExonicVAF.sh $file "indel"; done
for file in `ls $dir*.BAM.*snp.gz.*txt`; do ./getExonicVAF.sh $file snp; done

mkdir -p snps
mkdir -p indels

dir="0.5refinedVariants/"

mv snps $dir
mv indels $dir

mv $dir*.snp.xls $dir"snps"
mv $dir*indel.xls $dir"indels"

grep chr $dir"snps/"*".snp.xls" |sed "s/.snp.xls:/\t/g" |sed "s/0.5refinedVariants\/snps\///g" >$dir"SNV.aggregated"
grep chr $dir"indels/"*".indel.xls" |sed "s/.indel.xls:/\t/g" |sed "s/0.5refinedVariants\/indels\///g" >$dir"INDEL.aggregated"



#aggregated variants
#292     chr17   7579472 7579472 G       C       exonic  TP53    nonsynonymous SNV       TP53:NM_000546:exon4:c.C215G:p.P72R     99.04%


summarize(){
	input=$1
	paste <(less $input | cut -f2-10 | sed "s/\t/@/g") <(less $input |cut -f1) | sort >$input".ids"
	paste <(less $input | cut -f2-10 | sed "s/\t/@/g") <(less $input |cut -f11) | sort |sed "s/%//g" >$input".freq"
	paste <(python ../summa.freq.sorted.py $input".freq" |sort -k1nr) <(python ../summa.ids.sorted.py $input".ids" | sort -k1nr |cut -f3) | sed "s/@/\t/g" >$input".summary3"
	#rm $input".ids" $input".freq" 
	}

cd $dir
summarize "SNV.aggregated"

#what is wrong with indel????
summarize "INDEL.aggregated"

