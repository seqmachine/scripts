#Sep 21, 2019
#B*
dir="interRef/B-fa"
mkdir -p $dir
fullHLAref="/home/tianr/dataset/7.19autoimmune/hla_ref/hla-cDNA"
name=$1

function get2dRef(){
#for i in 07
echo "get two digits B fasta from HLA ref files."

for i in 07 08 13 14 15 18 27 35 37 38 39 40 41 42 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 67 73 78 81 82 83
do
    python python/getFastaByID.py $fullHLAref".fasta" "B*"$i >$dir/"B"$i".fasta"

done
}


function generateKmer(){
echo "generate kmers for B ref and B regions reads."
date
cp kmer.sh interData
cd interData
./kmer.sh $name".B" ".fasta"
cd ..
cp kmer.sh interRef/B-fa
cd interRef/B-fa
for x in `ls *.fasta |cut -d "." -f1`
do
    ./kmer.sh $x ".fasta"
done
cd ..
date
}

echo "compute cosine similarity."
date
#for i in 08
for i in 07 08 13 14 15 18 27 35 37 38 39 40 41 42 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 67 73 78 81 82 83
do
    echo "kmer B"$i>interData/"B"$i".tab"
    ./cosine.sh interData/ hla.SRR7656496.B interRef/B-fa/ "B"$i >>interData/"B"$i".tab"
done
date
