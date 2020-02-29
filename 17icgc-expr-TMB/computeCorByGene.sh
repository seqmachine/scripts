#Feb 25, 2020
#TianR.
#extract per gene expr

#split -n 30 --additional-suffix ".genes" gene.list 


geneList=$1
exprTable="liri-jp-expr-all.tab"
tmb="liri-jp_258donor_mut_counts.tab"


for gene in `cat $geneList|tr "\n" " "`

do
	cat $exprTable | awk -v G=$gene '{if ($3==G) print $0}'>$gene".table"

	cat $gene".table" | grep Cancer |cut -f1,2,3,4 | sort -k1 >$gene".cancer.expr"
	join -1 1 -2 1 $gene".cancer.expr" $tmb >$gene".cancer.tab"
	rm $gene".cancer.expr"
        	
	cat $gene".table" | grep Liver |cut -f1,2,3,4 | sort -k1 >$gene".liver.expr"	
        join -1 1 -2 1 $gene".liver.expr" $tmb >$gene".liver.tab"
	rm $gene".liver.expr"
	rm $gene".table"
	
	Rscript cor.R $gene".liver.tab" $gene".cancer.tab" $gene

	mv $gene".liver.tab" output
	mv $gene".cancer.tab" output
done
