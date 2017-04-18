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
 
