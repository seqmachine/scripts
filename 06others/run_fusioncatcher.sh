#Aug 17, 2016


fcPath="/home/tianrui/softwares/fusioncatcher"

inputdir=$1


cd $inputdir

ln -s *R1*gz reads_1.fq.gz
ln -s *R2*gz reads_2.fq.gz

cd ..

$fcPath"/bin/fusioncatcher" -d $fcPath"/data/current/" --input $inputdir --output $inputdir"_out"

