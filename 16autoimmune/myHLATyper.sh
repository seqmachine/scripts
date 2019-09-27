#Sep 24, 2019
input=$1


date
./extractHLAreads4.sh $input
date

sec="hla."$input
for gene in A B C
do
    ./classifyTwoDigts.sh $sec $gene
done
date
