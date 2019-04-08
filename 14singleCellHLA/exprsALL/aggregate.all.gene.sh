#April 8, 2019
#TianR
#each single cell has around 1000 gene detected at mRNA level, different single cells have different gene list, ensemble to make a unified gene list to faciliate normlization afterwards

 cat *rpkm | cut -f1 | sort | uniq >gene.list

aggreGeneList (){
    allGenes=$1
    eachRPKM=$2
    
    join -1 1 -2 1 -a 1 -e "0" -o 1.1,2.1,2.2,2.3 $allGenes <(sort -k1 $eachRPKM | uniq) \
|awk '{if ($2==0 && $3==0 && $4==0) {print $1,$4} else print $3,$4}' >$eachRPKM".unif"
    }




dir="/Users/tianr/0projects/hla2019/singleCELL/singleDonor_results_SRP140489_breast.3.19/results_seq2hla.3.18/singleD"



for file in `ls *.rpkm`
do
    echo $file
    root=`echo $file |cut -d "." -f1`
    echo $root
    aggreGeneList gene.list $file
    cat $file".unif" <(cat $dir/$root"-ClassI-class.expression"| cut -d " " -f1-2 | sed "s/://g") >$file".unif.acb"
    cat $file".unif.acb" | cut -d " " -f2 >$file".unif.acb2"
done



#last 3 lines are A C B


cat <(echo *acb |sed "s/.rpkm.unif.acb//g") <(paste *acb2) |tr " " "\t" > all.tab

Rscript hla.plotABCexprs2.R all.tab 

