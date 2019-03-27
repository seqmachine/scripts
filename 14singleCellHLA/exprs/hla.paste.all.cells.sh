# March 22, 2019
# tianr

#==> SRR7008765-ClassI-class.expression <==
#A: 12.62 RPKM
#C: 0.0 RPKM
#B: 0.0 RPKM

#==> SRR7008780-ClassI-class.expression <==
#A: 0.0 RPKM
#C: 0.0 RPKM
#B: 84.65 RPKM

#==> SRR7008784-ClassI-class.expression <==
#A: 89.02 RPKM
#C: 0.0 RPKM
#B: 0.0 RPKM


mkdir -p expressionTable


suffix="-ClassI-class.expression"

#expression.table

#reorder A B C

cat <(ls *$suffix | cut -d "-" -f1 | xargs echo |tr " " "\t") <(paste *$suffix) \
|sed "s/RPKM//g" >expression.table

cat <(cat expression.table | sed '3 d') <(cat expression.table | awk 'NR==3 { print $0}') \
|sed "s/A: //g" | sed "s/B: //g" |sed "s/C: //g" >./expressionTable/expression.table3

rm expression.table

Rscript hla.plotABCexprs.R ./expressionTable/expression.table3
