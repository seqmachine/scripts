#July 9, 2019

#very raw method for matching skin gene test SK02 product genotype to phenotype


table=" ~/pipelines/getSNP/skinTable.tab"
genotype=$1

cat $table | awk '{split($4, A, ":");print $3"_"A[1]"\t"$0}' >$table"2"

cat $genotype | awk -v TB=$table"2" '{print "grep -w "$1"_"$2" "TB}' >$genotype".sh"

chmod +x $genotype".sh"

./$genotype".sh" |cut -f2-5 | sort -k1 > $genotype".report.txt"
rm $genotype".sh"

#==> sample1.genotype.txt <==
#sk02885479      GG
#sk021050450     CT


