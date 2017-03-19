#March 16, 2017
#TianR.
#ID conversion, Do it once, use it always.
#March 19, 2017, make use of knitr, make it smart!!!

dir="/home/tianr/03Datasets/wangp_data/mRNA_clean_data/clean_data/"


#1.5G, pairs
#./runSalmon.sh $dir"15N_HJNJYALXX_L5_1.clean.fq.gz" $dir"15N_HJNJYALXX_L5_2.clean.fq.gz" 15n

#./runSalmon.sh $dir"15T_HJNJYALXX_L5_1.clean.fq.gz" $dir"15T_HJNJYALXX_L5_2.clean.fq.gz" 15t

exprdir="expr"

mkdir -p $exprdir


for id in 15N 15T 19N 19T 598N 598T
do
	#./runSalmon.sh $dir$id*"_1.clean.fq.gz" $dir$id*"_2.clean.fq.gz" $id

	#copy expr level
	cat $id"_transcripts_quant_out/quant.sf" | cut -f1,5 >$exprdir/$id".counts"
done

cd $exprdir

#paste 15T".counts" 15N".counts" | cut -f1-2,4 |tail -n+2 |\
#awk '{split($0, A, "\t"); sum=0;for (i in A) {sum=A[i]+sum}; if (sum != 0) {print $0} }' >sample_15.tab

one2one(){
	
	infile1=$1
	infile2=$2
	outfile=$3

	paste $infile1 $infile2 | cut -f1-2,4 |tail -n+2 |\
awk '{split($0, A, "\t"); sum=0;for (i in A) {sum=A[i]+sum}; if (sum != 0) {print $0} }' >$outfile

	}

three3three(){
	t1=$1
	t2=$2
	t3=$3
	c1=$4
	c2=$5
	c3=$6		
	outfile=$7
	paste $t1 $t2 $t3 $c1 $c2 $c3 |cut -f1-2,4,6,8,10,12 |tail -n+2 |\
awk '{split($0, A, "\t"); sum=0;for (i in A) {sum=A[i]+sum}; if (sum != 0) {print $0} }' >$outfile

	}


#treatment, control
one2one 15T".counts" 15N".counts" sample_15.tab


#no header!
#all zero lines should be deleted


Rscript ../deseq2b.R sample_15.tab






