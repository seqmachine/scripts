#2017 April 17

#motif database, position weighted matrix
#bedtools getfasta
#motif scanning
#match scoring, log ratio???
#speed!

wget http://homer.ucsd.edu/homer/custom.motifs

#the other rows are the positions specific probabilities for 
#each nucleotide (A/C/G/T). 

#get fasta file from VCF/BED
bedtools getfasta -fi /home/tianr/02databases/bwa_indexes/hg19/hg19.fa -bed ~/Desktop/test.bed -fo ~/Desktop/test.fa

#meme suite, fimo

### try http:// if https:// URLs are not supported
### seqlog for motif graphics
source("http://bioconductor.org/biocLite.R")
biocLite("seqLogo")


#vcf to bed
distance=30 #30bp
vcfFile=test.vcf
hgRef="/Users/tianr/0projects/Constants/hg19.fa"
mkdir inputDir
out=outputDir
mkdir -p $out

cat inputDir/$vcfFile | grep -v "#" | awk -v D=$distance '{print $1, ($2-D), ($2+D), $1"_"$2"_"$4"_"$5, $4, $5}' | tr " " "\t" > $out/$vcfFile".bed" 

#get fasta based on ref
fastaFromBed -db $hgRef -bed $out/$vcfFile".bed" -fo $out/$vcfFile".fa" -name

#
