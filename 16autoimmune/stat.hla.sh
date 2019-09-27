#Sep 24, 2019
file="ag.txt"
[ -f $file ] && rm $file
touch $file
for ag in A B C DRB1 DRA1 DQB1 DPB1
do
    
    echo $ag":"`python ../python/countHLA2d.py ../python/refData/hla.SRR7656496.counts $ag |cut -d " " -f1 |cut -d "*" -f2 | sort | tr "\n" " "` >> $file

done

