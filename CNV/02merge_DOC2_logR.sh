#Aug 12, 2016

patList=$1
#patient list

cat $patList| tr "\n" "\t" |awk -v LIST=$patList '{print "paste <(zcat "$1".doc.gz) \
<(zcat "$2".doc.gz |cut -f6) \
<(zcat "$3".doc.gz |cut -f6) \
<(zcat "$4".doc.gz |cut -f6)>"LIST".merged"}' >$patList".sh"

chmod +x $patList".sh"

./$patList".sh"


cat $patList".merged" | awk '{print $0"\t"log(($6+1)/($6+1))/log(2)"\t"log(($7+1)/($6+1))/log(2)"\t"log(($8+1)/($6+1))/log(2)"\t"log(($9+1)/($6+1))/log(2)}' >$patList".merged.logR"

rm cat $patList".merged"

python read_firstline.py $patList".merged.logR" >$patList".merged.logR.nr"

rm $patList".merged.logR"
