#TianR. Feb 24, 2017

#file root name
new=$1

#outputdir
outdir=$2


annPath="/home/tianr/01softwares/0.1VariantCall/annovar/"
VarScanPath="/home/tianr/01softwares/0.1VariantCall/VarScan.v2.3.9.jar"
minvarfreq=0.005
strandSelection=0 #--strand-filter 1, ignore 90%; 0 means off

Call_varscan2(){
        file=$1
        outdir=$2
        #min-var-freq!!!!
        alpha=$minvarfreq
	beta=$strandSelection

        #--strand-filter 0
        #default is 1, meaning ignore variants with over 90% support on one strand      


        java -jar $VarScanPath mpileup2snp $file --min-var-freq $alpha --strand-filter $beta --output-vcf 1 |gzip >$file".snp.gz"
        java -jar $VarScanPath mpileup2indel $file --min-var-freq $alpha --strand-filter $beta --output-vcf 1 |gzip >$file".indel.gz"
        }



Call_freebayes(){

        bam=$1
        outdir=$2

        $FreeBayesPath"freebayes" -f $ref -t <(zcat -f $targetBed |grep "chr" |cut -f1-3) $bam |gzip >$outdir/$bam".wxs.fb.vcf.gz" 
        }


Ann(){
        inputVCF=$1

        perl $annPath"table_annovar.pl" <(zcat -f $inputVCF) \
$annPath"humandb/" -buildver hg19 -out $inputVCF".out" -remove \
-protocol refGene,cytoBand,esp6500siv2_all,avsnp147,dbnsfp30a \
-operation g,r,f,f,f -nastring . -vcfinput
}



mkdir -p $outdir
Call_varscan2 $new".BAM.sorted.rmdup.up" $outdir

Ann $new".BAM.sorted.rmdup.up.snp.gz"
Ann $new".BAM.sorted.rmdup.up.indel.gz"

