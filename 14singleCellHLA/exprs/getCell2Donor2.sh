#Mar. 13, 2019

#get single cells to patients corespondence

#cut -f6,13 $1 >$1".c2p"

#firt line is headers
cut -f5,8 $1| sed '1d' >$1".c2p" #March 23


#$1 SRP132719_SraRunTable.txt
#$2 working dir

dir=$2

#Run	source_name
#SRR6710256	MM16
#SRR6710257	MM16

title="patient"


for patID in `cut -f2 $1".c2p"| grep -v $title | sort | uniq`

do
    mkdir -p $dir/$patID
done


cat $1".c2p" | grep -v $title | awk '{print "mv "$1"* "$2}' >$1".c2p.sh"

chmod +x $1".c2p.sh"

mv $1".c2p.sh" $dir

#$dir/$1".c2p.sh"



