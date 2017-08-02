#TianR.

#####################################################################
#for non redundant lines, only print once, for big data 50 million lines
#apparently sort pipe uniq is not good, if input is is big sorting takes time

awk '!seen[$0]++' filename > results.txt
or
awk '{if(!seen[$0]) print $0; seen[$0]++}' filename >results.txt


#---------------------------------------------------------------------
#get seq from fastq file
awk 'NR%4==2' | awk '{print length($0)}'

#get reads total
cat sample1.fq | echo $((`wc -l`/4))

#fq to fa
sed -n '1~4s/^@/>/p;2~4p'

awk 'NR%4 == 1 {print ">" substr($0, 2)} NR%4 == 2 {print}'
