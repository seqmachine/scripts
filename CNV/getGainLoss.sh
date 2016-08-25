#!/bin/bash
#Aug 25, 2016

#sorting to keep the orignal order!!!

Rscript cnv2.R $1
cat <(paste <(cat $1".gl" |grep -v chrom |sort) <(cat $1|sort) ) |awk '{if($4 !=0 || $5 !=0 ) print $0}' >$1".gl.m"

rm $1".gl"
