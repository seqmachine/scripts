exprSheet=$1

#BRCA-US_TRAIP_.expr

#11A, normal
cat $exprSheet |grep 11A | sort -k1 |cut -f1,4>$exprSheet".nor"

#01A cancer, read sample info
cat $exprSheet |grep 01A | sort -k1 |cut -f1,4 >$exprSheet".tum"

#join

join -1 1 -2 1 $exprSheet".nor" $exprSheet".tum" > $exprSheet".paired.tab"

#plot
#BRCA-US_TRAIP_.expr

cancer=`echo $exprSheet |cut -d "_" -f1`

echo $cancer

Rscript plot-paired-expr.R $exprSheet".paired.tab" $cancer
