#March 25, 2019

#tranform seq2HLA output format to optitype

infile=$1

cat $infile|grep -v "#" | tr  "\n" "\t" | cut -f2,4,7,9,12,14 >$infile".tab2"

echo `echo $infile |cut -d "-" -f1`"@"`cat $infile".tab2"` >$infile".tab"
rm $infile".tab2"



