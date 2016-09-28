fileList=$1

touch interm

touch out

for sample in `cat $fileList |tr "\n" " "` 

do
        paste interm $sample".f6" >out
        cat out > interm #update interm 

done

firstSample=`cat $fileList |head -n1`

paste <(cat $firstSample |cut -f1-4) out >12_plus_ck_sample.doc

rm out interm

