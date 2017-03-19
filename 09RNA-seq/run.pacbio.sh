#Jan 11, 2017
#for output bam 3G, around 2 hrs mapping

outdir="output"
mkdir -p $outdir

inputFAfile="GSM1254204_hESC_H1_PacBio.fa.gz.1"
sraFile="SRR1020625.sra"
ref="/home/tianr/02databases/bwa_indexes/hg19.fa"
fqdumpPath="/home/tianr/01softwares/sratoolkit.2.8.0-ubuntu64/bin/"
SamtPath=""

#bwa mem -t2 -x pacbio $ref $inputFAfile| samtools view -b - >$outdir/$inputFAfile".bam"

#1 hr, for 2G target fastq.gz file
#$fqdumpPath"fastq-dump" $sraFile -O $outdir --gzip

fqFile=$outdir/`basename -s ".sra" $sraFile`".fastq.gz"

#ls -lh $fqFile

#1.5hr
#bwa mem -a -M $ref $fqFile|samtools view -bS - >$outdir/`basename -s ".sra" $sraFile`".bam"

mkdir -p temp

SortUniqueIndex(){
	bamFile=$1
	
        $SamtPath"samtools" sort -m 4G -@ 2 -T `pwd`"/temp/"$bamFile".sorted" -o $bamFile".sorted" $bamFile
        $SamtPath"samtools" rmdup $bamFile".sorted" $bamFile".sorted.rmdup"
        $SamtPath"samtools" index $bamFile".sorted.rmdup"
	rm $bamFile".sorted"
        }

rmdir temp

#cd $outdir
#15 min each
for file in `ls *.bam`
do
	SortUniqueIndex $file
done

#30min each
for file in `ls *.rmdup`
do
	$SamtPath"samtools" mpileup -f $ref $file >$file".mup"	
done

#Caution: pacbio data need to be corrected first!!!
