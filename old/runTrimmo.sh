
#$1
#$2
#1 hr


path="/export/software/RNA/Trinity/trinityrnaseq-2.2.0/trinity-plugins/Trimmomatic-0.32/"

java -jar $path"trimmomatic-0.32.jar" PE \
-threads 20 $1 $2 \
$1".clean.gz" $1".unpaired.gz" \
$2".clean.gz" $2".unpaired.gz" \
ILLUMINACLIP:$path"adapters/TruSeq3-PE.fa":2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50


