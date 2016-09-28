#!/bin/bash
#Sep 22, 2016
#Sep 27, 2016

#for file in `ls *.vcf`; do cat $file |grep -v SS=1 > $file".somatic"; done
#!=1 might be somatic, might not be!!!

annPath="/share/software/Annotation/annovar/"



###########################
#4)annotation, filtering
# annovar is updated, based on many databases, gene based or filter based.
Ann(){
        inputVCF=$1

        perl $annPath"table_annovar.pl" <(zcat -f $inputVCF) \
$annPath"humandb/" -buildver hg19 -out $inputVCF".out" -remove \
-protocol refGene,cytoBand,esp6500siv2_all,snp138,ljb26_all \
-operation g,r,f,f,f -nastring . -vcfinput
}




#Sep 23, 2016
#zcat -f $1 |grep "SS=2;" >$1".somatic"
#Ann $1".somatic"


#snp, read2 >=3, $15, predicted deleterious only for one tool
mkdir snp
mv *snp*.txt snp
cd snp
for file in  `ls *.txt | grep snp`; do cat $file | grep -w "exonic"| grep -v -w "synonymous SNV" >$file".exonic"; done
for file in `ls *onic`; do ./run.grep180.sh $file >$file".sh"; chmod +x $file".sh"; ./$file".sh"; done
for file in `ls *snp*nic.180`; do cat $file |awk -F "\t" '{split($52,a,":");if(a[5] >=3) print $0}' > $file".pdv"; done

#indel
mkdir indel
mv *indel*.txt indel
cd indel
for file in  `ls *.txt | grep indel`; do cat $file | grep -w "exonic" >$file".exonic"; done
for file in `ls *onic`; do ./run.grep180.sh $file >$file".sh"; chmod +x $file".sh"; ./$file".sh"; done 
for file in `ls *indel*nic.180`; do cat $file |grep -v "nonframeshift" |awk -F "\t" '{split($52,a,":");if(a[5] >=3) print $0}' > $file".pdv"; done
