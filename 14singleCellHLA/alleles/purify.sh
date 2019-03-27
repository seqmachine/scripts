#March 25, 2019

infile=$1

# at least 10 reads
cat $infile|grep -v "Reads" | awk -F "\t" '{if ($8 >=10) print $0}' | cut -f2-7 >$infile".tab2"

if [ -s $infile".tab2" ]; then
    echo `echo $infile|cut -d "_" -f1`"@"`cat $infile.tab2` >$infile".tab"
else
    echo "filtered out!"
fi

rm $infile".tab2"

