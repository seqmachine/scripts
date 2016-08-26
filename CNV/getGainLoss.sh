#!/bin/bash
#Aug 25, 2016
#Aug26, 2016

#sorting to keep the orignal order!!!

Rscript cnv2.R $1

minimumDP=20

cat <(paste <(cat $1".gl" |grep -v chrom |sort) <(cat $1|sort) ) |\
awk '{if($4 !=0 || $5 !=0 || $9 !=0 || $10 !=0 || $14 !=0 || $15 !=0 ) print $0}'|\
awk -v MDP=$minimumDP '{if(($21+$22+$23+$24) >= MDP) print $0}' |\
awk '{split($19, A, ";"); split(A[1], B, "|"); if ($1==$16 && $2== $17) {print $16"\t"$17"\t"$18"\t"B[2]"\t"$4"_"$5":"$9"_"$10":"$14"_"$15"\t"$21"\t"$22"\t"$23"\t"$24"\t"$25"\t"$26"\t"$27"\t"$28}}' >$1".gl.m4"

rm $1".gl"

Rscript clean.multi.probe.R $1".gl.m4"

sort $1".gl.m4.u" >$1".gl.m4.u.s"

rm $1".gl.m4.u"
 
#chr10 75570597 1 0 -1 chr10 75570597 1 0 0 chr10 75570597 1 0 0	chr10	75570597	75570772	gn|NDST2;gn|RP11-574K11.18;ccds|CCDS7335;ens|ENSG00000166507;ens|ENSG00000243698;vega|OTTHUMG00000018488;vega|OTTHUMG00000018489	1	4	0	2	1	0	-2.32193	-0.736966	-1.32193

