#SRP132719
#rnaseqdir="/home/tianr/dataset/singleCellRNAseq/multiple_myeloma_SRP132719_3.12/fastqFiles_paired_168/output"
#seqHLAdir="/home/tianr/dataset/singleCellRNAseq/multiple_myeloma_SRP132719_3.12/results_SRP132719_multiple_myeloma/results_seq2hla.2019.3.12"


#SRP158590
rnaseqdir="/home/tianr/dataset/singleCellRNAseq/SRP158590_CD138positive_15patients_MM/fastqFiles_441/output"
seqHLAdir="/home/tianr/dataset/singleCellRNAseq/SRP158590_CD138positive_15patients_MM/results_SRP158590_CD138positive_15patients_MM/results_sra2hla"

cd $rnaseqdir

for file in `ls *_Aligned.sortedByCoord.out.bam |cut -d "_" -f1`

do
	echo $file
	/home/tianr/pipelines/getRPKM.sh $file
done


