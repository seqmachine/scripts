infile=$1

#cat $infile |grep -A2 "12-31"
#each end of the year


paste <(cat $infile |grep -A2 "12-31" |awk '{if(NR %4 ==1) {print $0}}') \
<(cat $infile |grep -A2 "12-31" |awk '{if(NR %4 ==2) {print $0}}') \
<(cat $infile |grep -A2 "12-31" |awk '{if(NR %4 ==3) {print $0}}') |\
sort -k2 |cut -f2,4,6 |sed "s/-12-31//g" |sed "s/"元"//g">$infile".tab"


Rscript plot.R $infile".tab"
