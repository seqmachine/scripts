infile=$1
gene="TRAIP"

data=`zless $infile| cut -f2|head |tail -n1`

zless $infile|cut -f1,5,8,9,10 |grep -w $gene >$data"_"$gene".expr"

