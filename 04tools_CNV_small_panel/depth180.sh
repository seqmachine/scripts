#!/bin/bash
#Aug 11, 2016, Thu.
#Sep 19, 2016

# usage ./depth_of_coverage.sh <$bam>

bedPath="/share/software/Base/bedtools/bedtools/bin/"
targetBed="/share/work/tianrui/database/bed/FD180.bed"

bam=$1

mkdir -p dep_of_coverage

$bedPath"coverageBed" -abam $bam -b $targetBed -d >dep_of_coverage"/"$bam".doc"

