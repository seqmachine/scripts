#!/bin/bash
#Aug 4, 2016
#Always call variants first, then filter, then annotate.

#Quality 30 (0.001 error probability)
#DP 10
#Alternative reads count 2
#RPL, RPR: reads placed left, right 2
#SAF, SAR: strand + - 1


file=$1

zcat $file| grep -v "#" | awk -F "\t" '\
{split($8,ba,";");split($10,shi,":");if ($6 >=30 && shi[2]>= 10 &&shi[5] >=2 \
&& ba[30]!="RPL=0" && ba[33]!="RPR=0" && ba[35]!="SAF=0" && ba[37]!="SAR=0") print $0}'
#print $6,$9,$10,ba[30],ba[33],ba[35],ba[37]

