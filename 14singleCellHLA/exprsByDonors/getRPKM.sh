#April 1, 2019
#TianR
#April 7, 2019 do not select 0 in the first place
#April 8, 2019 remove redundancies


id=$1

#id="SRR7009001"

mkdir -p RPKM

samtools view $id"_Aligned.sortedByCoord.out.bam" | wc -l >RPKM/$id".depth"

ref="/home/tianr/biodatabases/indexes/STAR/hg19/hg19_ref.txt"

if [ ! -s $ref".transcript.length" ]; then

	less $ref |awk '{split($10, A, ",");split($11, B, ",");  sum=0;for (i=1;i< length(A);i++) {sum+=B[i]-A[i]}; print $1"\t"$2"\t" sum}' |awk '{if ($1 != X) print $0; X=$1}' >$ref".transcript.length2"

	cat $ref".transcript.length2" | sort | uniq |awk '{if ($1 != X) print $0; X=$1}'> $ref".transcript.length"

	rm $ref".transcript.length2"



else
	echo "transcript length genome wide is there already!"
fi

less $id"_ReadsPerGene.out.tab" |grep -v "N_" |cut -f1,3 | awk '{if ($2 >0) print $0}' >RPKM/$id".counts"

#remove "select by zero"!

join -1 2 -2 1  <(sort -k2 $ref".transcript.length") <(sort -k1 RPKM/$id".counts") \
| awk -v DEP=`cat RPKM/$id".depth"` '{print $1"\t"$2"\t"1000*$4/$3*1000000/DEP}' >RPKM/$id".rpkm"
