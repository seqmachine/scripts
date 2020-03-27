#March 27, 2020
#61.loci.peaks

mkdir -p  output

infile=$1

#sageExprs375.tab
expr=$2

#cutoff, 0.01
cutoff=$3

Rscript transpose.R $infile

join -1 1 -2 1 <(sort $expr) <(sort $infile".t") |tr " " "\t" >375.combined

#manually add sage1_expr after sample as header
#head -n1 61.loci.peaks.t |tr "sample" "sample\tsage1_expr" >header

head -n1  $infile".t"|tr "\t" " "|sed "s/sample/sample sage1_expr/"|tr " " "\t" >header
cat header 375.combined>$infile".combined.tab"
rm header
rm 375.combined

Rscript ttestPlots.R $infile".combined.tab" $cutoff
