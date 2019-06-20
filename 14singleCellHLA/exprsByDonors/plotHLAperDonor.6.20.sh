#June 19, 2019
#TianR.


makeDonorDir(){
	pdir=$1
	
	sampleDonorTable=$2

	
	for dir in `less $sampleDonorTable | grep SRR |cut -f2 | sort | uniq |tr "\n" " "`
	do
		echo $dir
		mkdir -p $pdir/$dir
	done
	}



moveByDonor(){
	wdir=`pwd`
	sampleDonorTable=$1
	dir=$2
	less $sampleDonorTable | grep SRR | awk '{print "[ -d "$2" ] && mv "$1"* "$2}' >$dir/mvByDonor.sh	
	chmod +x $dir/mvByDonor.sh
	cd $dir
	./mvByDonor.sh
	cd $wdir
	}




goMove(){
	makeDonorDir $exprsDir $1
	moveByDonor $1 $exprsDir

	makeDonorDir $hlaDir $1
	moveByDonor $1 $hlaDir
	}


runByDonor(){
	donor=$1
	exprsDir=$2
	hlaDir=$3
	wdir=`pwd`

	rpkmDir=$exprsDir/$donor
	seqHLAdir=$hlaDir/$donor

	cd $rpkmDir
	~/pipelines/aggregate.all.gene.sh $seqHLAdir
	cp  all.tab.pdf  $wdir/$donor".HLA.pdf"
	cd $wdir
	}



#dataset 719
#run719(){
#	local stemDir="/home/tianr/dataset/singleCellRNAseq/multiple_myeloma_SRP132719_3.12"
#	local exprsDir=$stemDir"/RPKM"
#	local hlaDir=$stemDir"/results_SRP132719_multiple_myeloma/results_seq2hla.2019.3.12"
#	goMove $stemDir"/readme/SRP132719_SraRunTable.txt.c2p"
#}
#run719


#dataset 590
stemDir="/home/tianr/dataset/singleCellRNAseq/SRP158590_CD138positive_15patients_MM"
exprsDir=$stemDir"/RPKM"
hlaDir=$stemDir"/results_SRP158590_CD138positive_15patients_MM/results_sra2hla"
path="./"
$path"getCell2Donor2.sh" $stemDir"/readme/SRP158590_SraRunTable.txt"

sampleDonorTable=$stemDir"/readme/SRP158590_SraRunTable.txt.c2p"

goMove $sampleDonorTable


for dir in `less $sampleDonorTable | grep SRR |cut -f2 | sort | uniq |tr "\n" " "`
do
	#echo $dir
	runByDonor $dir $exprsDir $hlaDir
done

