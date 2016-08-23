#Aug 2, 2016

input=$1

zcat $input |awk '{if ($6=="exonic") print $0}' | grep -v nonframeshift | grep -v unknown >$input".fun"

file=$input".fun"

#paste <(cat $file | cut -f51-54 | cut -f1 | cut -d ":" -f1) \
#<(cat $file | cut -f51-54 | cut -f2 | cut -d ":" -f1) \
#<(cat $file | cut -f51-54 | cut -f3 | cut -d ":" -f1) \
#<(cat $file | cut -f51-54 | cut -f4 | cut -d ":" -f1) | sort | uniq -c >$input".fun.genotype.stat"


# filtering base on 6500 freq, MAF<0.005, SIFT=D putative functionally impaired genes
#-F "\t" is essential!!!


#no sift for indels

cat <(cat $file | awk -F "\t" '{if ($12 !="." && $12 <0.005) print $0}') \
<(cat $file | awk -F "\t" '{if ($12 !="." && $12 >0.995) print $0}') \
<(cat $file | awk -F "\t" '{if ($12 ==".") print $0}') > $file".pdv"


cat $file".pdv" |cut -f7 | sort | uniq | cut -d "," -f1 |sort | uniq >$file".pdv.gene"

