#Tian R.
#Nov 14, 2016

input=$1
 zcat -f $input |awk '{if ($6=="exonic") print $0}' | grep -v -w "synonymous SNV" |grep -v nonframeshift | awk -F "\t" '{split($51,a,":");if(a[2]>=20){print $0}}' >$input".fun"

