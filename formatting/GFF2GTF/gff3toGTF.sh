#Feb 16, 2017

#GFF3
#NW_014804496.1  Gnomon  exon    25317   25503   .       +       .       ID=id8;Parent=rna2;Dbxref=GeneID:100430343,Genbank:XM_015144955.1;gbkey=mRNA;gene=SAMD11;product=sterile alpha motif domain containing 11%2C transcript variant X1;transcript_id=XM_015144955.1
#GTF
#chr1	unknown	exon	11874	12227	.	+	.	gene_id "DDX11L1"; gene_name "DDX11L1"; transcript_id "NR_046018"; tss_id "TSS16932";

#step 0 get contig chr table
#NW_014804496.1	1
#NW_014804497.1	1



#step1
#map contig to chr
python markChr.py contig2chr.tab /scratch/weigs/gene.data/mulatta/ref_Mmul_8.0.1_scaffolds.gff3 >mulatta.gff3rt &



#step 2
#less mulatta.gff3rt |awk '{split($9, A, ";");if ($3 =="gene" || $3 == "exon" || $3=="cDNA_match") print $1,$2,$3,$4,$5, $6, $7, $8, A[5]}' | grep "gene=" >part1
#less mulatta.gff3rt |awk '{split($9, A, ";");if ($3 =="mRNA" || $3 == "CDS" || $3=="ncRNA" || $3=="transcript" || $3=="primary_transcript") print $1,$2,$3,$4,$5, $6, $7, $8, A[6]}' | grep "gene=" >part2

cat mulatta.gff3rt| awk '{split($9,A,";"); for (i in A){split(A[i], B, "=");if (B[1]=="gene") {print $1,$2,$3,$4,$5,$6,$7,$8,"gene="B[2]}}}' >mulatta.gff3rt.gene



#step 3
#cat part* | sed "s/gene=/ /g"| awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\tgene_id ""\""$9"\""";"}' >mulatta.gtf 
cat mulatta.gff3rt.gene | sed "s/gene=/ /g"| awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\tgene_id ""\""$9"\""";"}' >mulatta.gtf 

rm mulatta.gff3rt.gene


#GTF format
#1	Gnomon	gene	25317	42650	.	+	.	gene_id "SAMD11";
#1	Gnomon	exon	25317	25503	.	+	.	gene_id "SAMD11";


