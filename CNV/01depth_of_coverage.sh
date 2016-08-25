#!/bin/bash
#Aug 11, 2016, Thu.

# usage ./depth_of_coverage.sh <$bam>

bedPath="/share/software/Base/bedtools/bedtools/bin/"
targetBed="/share/work/tianrui/database/bed/SeqCap_EZ_Exome_v3_primary.bed.gz"

bam=$1

$bedPath"coverageBed" -abam $bam -b $targetBed -d >$bam".doc"


#takes 20 min
