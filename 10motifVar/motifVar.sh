#2017 April 17

#motif database, position weighted matrix
#bedtools getfasta
#motif scanning
#match scoring, log ratio???
#speed!

#wget http://homer.ucsd.edu/homer/custom.motifs

#the other rows are the positions specific probabilities for 
#each nucleotide (A/C/G/T). 

#get fasta file from VCF/BED
#bedtools getfasta -fi /home/tianr/02databases/bwa_indexes/hg19/hg19.fa -bed ~/Desktop/test.bed -fo ~/Desktop/test.fa

#meme suite, fimo

### try http:// if https:// URLs are not supported
### seqlog for motif graphics
#source("http://bioconductor.org/biocLite.R")
#biocLite("seqLogo")


#vcf to bed
distance=30 #30bp
#vcfFile="lncap.vcf.filtered.gz"
vcfFile=$1
hgRef="/Users/tianr/0projects/Constants/hg19.fa"
path="/Users/tianr/4pkgs/BEDTools/bin"

mkdir inputDir
out=outputDir
mkdir -p $out

echo "#INFO: make bed from vcf file."

#zless inputDir/$vcfFile | grep -v "#" | awk -v D=$distance '{print $1, ($2-D), ($2+D), $1"_"$2"_"$4"_"$5, $4, $5}' | tr " " "\t" > $out/$vcfFile".bed" 

echo "#INFO: get fasta file from bed."
#get fasta based on ref
#$path"/fastaFromBed" -db $hgRef -bed $out/$vcfFile".bed" -fo $out/$vcfFile".fa" -name

#
echo "#INFO: estimate mutational conseqences based on motifs."


cutoff=$2
N=$3
python readMotifDatabase.py custom.motifs $out/$vcfFile".fa" 30 $cutoff  $N >$out/$vcfFile".fa.results.txt"
