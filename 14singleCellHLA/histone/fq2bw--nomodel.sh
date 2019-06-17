#June 6, 2019

#TianR

#from fq to bigwig

name=$1
bwa mem -t 12 ~/biodatabases/indexes/bwa/hg38ref/hg38 $name".fastq.gz" > $name".SAM"

samtools view -bS $name".SAM" > $name".bam"
rm  $name".SAM"

macs2 callpeak -t $name".bam" -f BAM -g hs -n $name -B -q 0.01 --nomodel

#wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bedGraphToBigWig
#wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.chrom.sizes

sort -k1,1 -k2,2n $name"_treat_pileup.bdg" > $name"_treat_pileup.bdg.sorted"
bedGraphToBigWig $name"_treat_pileup.bdg.sorted" ~/biodatabases/hg38.chrom.sizes $name".bw"
rm $name"_treat_pileup.bdg"  
rm $name"_treat_pileup.bdg.sorted"
