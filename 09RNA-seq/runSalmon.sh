#March 13, 2017
#Tian R.
#Get RNA expression level alignment free



path="/home/tianr/01softwares/0.3RNAseq/Salmon-0.8.1_linux_x86_64/"
mrnaFasta="Homo_sapiens.GRCh37.75.cdna.all.fa"
#ftp://ftp.ensembl.org/pub/release-75//fasta/homo_sapiens/cdna/

r1=$1
r2=$2
name=$3


#make index for salmon: only once
#./bin/salmon index -t $mrnaFasta -i hg19_transcript_index --type quasi -k 31

$path"bin/salmon" quant -i $path"hg19_transcript_index" -l A -1 $r1 -2 $r2 -o $name"_transcripts_quant_out"


#genome based alignment or transcript based???, no good
#./bin/salmon quant -t $mrnaFasta -l A -a $bamFile -o salmon.quant
