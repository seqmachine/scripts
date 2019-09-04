#June 14, 2019
#TianR

size=1024000
dir=big
mkdir -p $dir
for file in `ls *bw`
do
	if [ `wc -c <$file` -gt $size ]
	then
		mv $file $dir
	else
		echo `ls -lh $file` 	
	fi
done
