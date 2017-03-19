#Jan 18, 2017


#OK
#fetch_ucsc.py hg19 ref hg19_ref.txt
#cut -f2-11 hg19_ref.txt|genePredToGtf file stdin hg19_ref.gtf

# takes 1 hour

ref="/home/tianr/02databases/star_indexes/hg19"
fq1=$1
fq2=$2
name=$3


mkdir -p output


STAR \
--runThreadN 4 \
--genomeDir $ref \
--readFilesIn $fq1 $fq2 \
--readFilesCommand zcat \
--clip5pNbases 0 \
--outFilterType BySJout \
--outFilterMultimapNmax 20 \
--alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterMismatchNmax 999 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--outFileNamePrefix output/$name"_" \
--outSAMtype BAM SortedByCoordinate \
--chimSegmentMin 20 \
--chimOutType WithinBAM \
--quantMode TranscriptomeSAM GeneCounts \
--outReadsUnmapped Fastx
