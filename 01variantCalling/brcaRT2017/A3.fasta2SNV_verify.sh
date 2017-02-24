#Feb 17, 2017
#input=$1

#echo ">"$input
#cat $input
#echo


#map fasta
#fa=$1
fa=sanger.2017.02.17.fasta

#bowtie2 -x /home/tianr/02databases/bowtie2_indexes/hg19 -f $fa >$fa".SAM"
#extract given locus

locus=41246151
chr="chr17"
#locus=41246086 
less  $fa".SAM"| grep -v "@" | cut -f1,3,4,10 | awk -v POS=$locus -v CHR=$chr '{if ($2==CHR) {print $1,$2,POS,substr($4,(POS-$3+1),1)}}'\
>$fa".loci"
