#2016.07.21
#2 hr

/share/software/Alignment/bwa/bwa-0.7.13/bwa/bwa mem -a -M \
/share/work/tianrui/database/refGenome/hg19.fa \
S221_07A_CHG008180-PDNAEI160006-XLX-SN_L001_R1.fastq.gz.clean.gz S221_07A_CHG008180-PDNAEI160006-XLX-SN_L001_R2.fastq.gz.clean.gz \
|/share/software/VariantCalling/samtools/samtools-1.3/samtools view -bS  - >"XLX-SN.BAM"




