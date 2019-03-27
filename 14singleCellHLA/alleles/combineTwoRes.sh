#March 26, 2019
#Tian R.
root="/Users/tianr/0projects/hla2019/singleCELL"


#dataset="results_SRP132719_multiple_myeloma"
dataset=$1

#donor="MM16"

#soft1="optitypeResults3.13"
soft1=$2
#soft2="results_seq2hla.2019.3.12"
soft2=$3

donor=$4


combineTwoRes(){
    root=$1
    dataset=$2
    donor=$3
    soft1=$4
    soft2=$5
    
    mkdir -p $root/$dataset/$donor

    cd $root/$dataset/$soft1/$donor
    echo `pwd`
    cp $root/purify.sh .

    for file in `ls *.tsv`; do ./purify.sh $file; done
    #mv *tab $root/$dataset/$donor
    
    #SRR6710264_result.tsv.tab 

    list=`ls *"tsv.tab" |cut -d "_" -f1` 
    #echo $list
    
    mv *".tab" $root/$dataset/$donor

    cd $root/$dataset/$soft2/$donor
    echo `pwd`
    cp $root/transformseq2opti.sh .

    for file in $list; do ./transformseq2opti.sh $file"-ClassI-class.HLAgenotype4digits"; done
    mv *"digits.tab" $root/$dataset/$donor
    }


combineTwoRes $root $dataset $donor $soft1 $soft2
cd $root
cp summarizeByDonor.sh $root/$dataset/$donor
cd $root/$dataset/$donor
./summarizeByDonor.sh > $root/$dataset/$donor".counts"
