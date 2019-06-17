#March 12, 2019
#shut up!!!!!
#optiType for precise Class I HLA typing for both RNA and DNA

#16 threads per process






runOptiTypeSingleEND(){

        root=$1 #root name of a file
        wdir=$2 #work dir 

        echo $root
        #echo $file
        #root=`basename -s ".fastq.gz" $file`
        gunzip $root".fastq.gz"
        #gunzip $root"_2.fastq.gz"

        #run at current dir
        
        docker run -v $wdir:/data/ -t fred2/optitype -i $root".fastq" --rna -v  -o /data/ -p $root 

        gzip $root".fastq"
        }



date


wdir=`pwd`
#for root in `ls *fastq.gz |cut -d "_" -f1 | sort |uniq`



for root in `ls *.sra |cut -d "." -f1`

#for root in SRR3534783
#for file in `ls *.fastq.gz`



do
        if [ ! -e $root"_result.tsv" ]; then
            	echo $root".sra"
		echo $root"_result.tsv to be done"
		if [ ! -e $root".fastq.gz" ]; then
 
			fastq-dump $root".sra" --gzip 
                	runOptiTypeSingleEND $root $wdir
		else
			echo $root".fastq.gz already there!"
			runOptiTypeSingleEND $root $wdir
		fi
        else
                echo $root"_result.tsv already there!"
        fi

done

date


