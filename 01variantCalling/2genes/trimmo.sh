#Feb 6, 2017
#TianR.
#keep 150 bp from 5 prime end
#Feb 20, 2017,,, not a single base trimming !!!!!!!!



trimmoPath="/home/tianr/01softwares/seqtools/Trimmomatic-0.36/"
dir="raw"
id=$1
r1="_L001_R1_001.fastq.gz"
r2="_L001_R2_001.fastq.gz"

temp="Unpaired_trash"
mkdir -p $temp

java -jar $trimmoPath"trimmomatic-0.36.jar" PE $dir/$id$r1 $dir/$id$r2 \
$id$r1".clean.gz" $temp/$id$r1".unpaired" \
$id$r2".clean.gz" $temp/$id$r2".unpaired" CROP:190


#run variant calling
new=`echo $id |awk '{split($0, A, "_");print A[1]}'`

#echo $new

./fq2vcf3.sh $id$r1".clean.gz" $id$r2".clean.gz" $new 
