#Jan 17, 2019

#exact position, bed seems to be 0-based???
#less 25loci.txt | awk -F "\t" '{print "chr"$3"\t"$4"\t"($4+1)}' >ht01.bed


#flanking +-150bp 
#chr start end name score strand
#less 25loci.txt | awk -F "\t" '{print "chr"$3"\t"($4-150)"\t"($4+150)"\tchr"$3"_"$4"\t""\t""."}' >ht01.bed

#bedtools getfasta -fi /Users/tianr/0projects/Constants/hg38/hg38.fa -bed ht01.bed -fo ht01.fa

bwa index -a is ht01.fa
