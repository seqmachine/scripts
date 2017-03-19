#Tian R.
#Jan 4, 2017


bsmapperPath="/home/tianr/projects/DNAmethylation/lab/dependencies/rmap-2.1/bin/"
methPipePath="/home/tianr/projects/DNAmethylation/lab/methpipe-3.4.2/bin/"
pyLibPath="/home/tianr/projects/DNAmethylation/lab/"
targetBED=
depPath="/home/tianr/projects/DNAmethylation/lab/dependencies/"


ref="/home/tianr/projects/DNAmethylation/lab/methpipe-data/data/genome/"
fq_1=$1
fq_2=$2
id=$3

#------------------------------------------------------------
#mapping, adapter trimming, QC, BseqC (github, hutuqiu)
#-----------------------------------------------------------
$bsmapperPath"rmapbs-pe" -o $id".mr" -c $ref -m 8 $fq_1 $fq_2

#----------------------------------------------------------
#sort and remove duplicates
python $pyLibPath"removeDup.py" <(sort -k1,1 -k2,2n -k3,3n -k6,6 $id".mr")> $id".mr.uniq" 
#----------------------------------------------------------

#---------------------------------------------------------
#compute methy level and coverage over individual CpG site:
#use -n for CpG only!!!

$methPipePath"methcounts"  -o $id".meth" -c $ref -v $id".mr.uniq"
#----------------------------------------------------------

#---------------------------------------------------------
#overall methy level
$methPipePath"levels" -o $id".levels" $id".meth"
#---------------------------------------------------------

#----------------------------------------------------------
#estimate bisulfite conversion rate
$methPipePath"bsrate"  -o $id".bsrate" -c $ref -v $id".mr.uniq"
#----------------------------------------------------------


#---------------------------------------------------------
#identify hyper-methylated regions, hypermr, for plant???
#---------------------------------------------------------
$methPipePath"hypermr"  -o $id".hypermr" -i 15 -v $id".meth" 


#--------------------------------------------------------
#identify hypo-methylated regions, hmr
$methPipePath"hmr"  -o $id".hmr" -i 15 -v $id".meth"          
#--------------------------------------------------------


#-------------------------------------------------------
#identify partially-methylated domains
$methPipePath"pmd"  -o $id".pmd" -i 15 -v $id".meth"          

#-------------------------------------------------------

#------------------------------------------------------
#per region methyl level
#bed and .meth should be sorted first !!!!
$methPipePath"roimethstat" -o $id".meth.bed" $targetBED $id".meth"
#------------------------------------------------------


#------------------------------------------------------
#create bigwig file for visual
awk '{print $1 "\t" $2 "\t" $2+1 "\t" $4":"$6 "\t" $5 "\t" $3}' $id".meth" |cut -f 1-3,5 >$id".meth.bed"
$depPath"wigToBigWig" $id".meth.bed" $depPath"hg19.chrom.sizes" $id".meth.bw"
rm $id".meth.bed"
#-----------------------------------------------------



#------------------------------------------------------
#typical comparisons, treatment versus control, at each CpG site basis
#$methPipePath"methdiff" -o $id"_"$id-tr".methdiff" $id".meth" $id-tr".methdiff"
#------------------------------------------------------


#---------------------------------------------------
#Differentially methylated regions (DMRs)
#$methPipePath"dmr" $id"_"$id-tr".methdiff" $id".hmr" $id-tr".hmr" $id"_lt_"$id-tr".dmr" $id-tr"_lt_"$id".dmr"
#--------------------------------------------------


outdir=$id"_"`date -I`"_results"
mkdir -p $outdir

mv $id* $outdir
