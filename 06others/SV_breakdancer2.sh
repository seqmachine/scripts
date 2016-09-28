#Aug 16, 2016
#Aug 29, 2016

id=$1

#make config file
#/share/software/VariantCalling/breakdancer/perl/bam2cfg.pl -g -h $id"_stomach_C.BAM.sorted" $id"_stomach_N.BAM.sorted" >$id".cfg"

#run breakdancer-max
/share/software/VariantCalling/breakdancer/build/bin/breakdancer-max -q 10 -d $id".ctx" $id".cfg" > $id".ctx"

