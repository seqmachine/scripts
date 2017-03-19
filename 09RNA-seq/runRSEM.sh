#March 12, 2017
#Tian R.
#From star output bam file to diff expr

#RSEM can user bowtie2 and star aligner

#databases
#ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/
#ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_24/gencode.v24.annotation.gtf.gz
#rsem-sam-validator <input.sam/input.bam/input.cram>
#convert-sam-for-rsem --help
#--transcript-to-gene-map knownIsoforms.txt



#step 1: build the references:
#try --gff3, but not recommended

rsem-prepare-reference \
--gtf ref/hg19.gtf \
ref/hg19.fa ref/hg19_ref

#if no genome ref is available, use de novo assembly transcriptome
rsem-prepare-reference \
--transcript-to-gene-map ref/ref_mapping.txt \
ref/hg19.fa ref/hg19_ref 
#ref_mapping.txt format
#gene transcript

#step 2: call expr
rsem-calculate-expression -p 4 --paired-end \
--bam \
--estimate-rspd \
--append-names \
--output-genome-bam \
exp/$id".bam" \
ref/hg19_ref exp/$id

#plot
rsem-plot-model $id $id"_diagnostic.pdf"


#data matrix and diff
#DESeq2???

rsem-generate-data-matrix treatment1.genes.results \
treatment2.genes.results treatment3.genes.results \
control1.genes.results control2.genes.results \
control3.genes.results > GeneMat.txt

rsem-run-ebseq GeneMat.txt 3,3 GeneMat.results
rsem-control-fdr GeneMat.results 0.05 GeneMat.de.txt
