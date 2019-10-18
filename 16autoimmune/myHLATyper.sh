#Sep 21, 2019
#B*refdir="interRef/"$antigen"-fa"

#Sep 24, 2019
#Oct 18, 2019


workdir=`pwd`


###########################################################################################
echo `date`
#-a -M
#Sep 20, 2019 -all, report all possible mapped

#Oct. 15, 2019
############################################
#HLA ref trimming
#assign reads to A, B, C, but only keep those only map to A or B or C
#Oct. 16, 2019

sampleID=$1
prefix="hla."
i=9
cutoff=3
readLen=51
optimalK=39

interdir="interData"
rm -r $interdir
mkdir -p $interdir


#fullHLAref="./python/refData/hla-class1-ARS"

zless /home/tianr/biodatabases/hla/hla_nuc.fasta.gz |tr " " "_" >./python/refData/hla_cDNA.fasta

fullHLAref="/home/tianr/dataset/7.19autoimmune/hla_ref/hla-cDNA"
#fullHLAref="./python/refData/hla-cDNA"
#library="paired"

#cd ./python/refData/
#bwa index -a is -p hla-class1-ARS hla-class1-ARS.fasta
#bwa index -a is -p hla_cDNA hla_cDNA.fasta
#cd ../../


fq2SAM(){

hlaREF=$1
root=$2

if [ -s $root"_1.fastq.gz" ] && [ -s $root"_2.fastq.gz" ]; then
	library="paired"
elif [ -s $root".fastq.gz" ]; then
	library="single"
else
	echo "input file format is wrong, naming not standard."
	exit 1
fi

if [ $library == "paired" ]; then
#multiple runs!!!
	bwa mem -a -t 20 $hlaREF $root"_1.fastq.gz" $root"_2.fastq.gz" >$root".SAM"
elif [ $library == "single" ]; then
	bwa mem -a -t 20 $hlaREF $root".fastq.gz" >$root".SAM"
else
	echo "mapping could not be done."
	exit 2
fi
}

extractHLAreads(){

#library=$1
root=$1
#filter out unmapped reads
samtools view -h -F 4 $root".SAM" >$prefix$root".sam"
rm $root".SAM"
samtools view -bS $prefix$root".sam" > $prefix$root".bam"
rm $prefix$root".sam"
#}

if [ -s $root"_1.fastq.gz" ] && [ -s $root"_2.fastq.gz" ]; then
	library="paired"
elif [ -s $root".fastq.gz" ]; then
	library="single"
else
	echo "input file format is wrong, naming not standard."
	exit 1
fi


if [ $library == "paired" ]; then
	samtools fastq -N --threads 2 -c 9 -1 $prefix$root"_1.fastq.gz" -2 $prefix$root"_2.fastq.gz" $prefix$root".bam"
elif [ $library == "single" ]; then
	samtools fastq -N --threads 2 $prefix$root".bam" | gzip >$prefix$root".fastq.gz" 	
else
	echo "bam to fastq could not be done."
	exit 3
fi
}

#echo "count reads, very raw!"
#samtools view $prefix$root".bam" | cut -f3 | sort | uniq -c | sort -k1nr | awk '{print $2"\t"$1}' >$prefix$root".counts"

#echo "extract reads by assigned HLA raw types"


assignReadByAg(){
#for gene in A
root=$1
for gene in A B C DRB1 DQB1 DPB1
do

	echo ">HLA-"$gene" aligned reads" >$interdir/$prefix$root"."$gene".fasta"
	#samtools view $prefix$root".bam" | grep "_$gene\*" | grep "NM:i:0" |awk '{if ($10 != "*"){print ">"$1"\n"$10}}' >>$interdir/$prefix$root"."$gene".fasta"
    samtools view $prefix$root".bam" | awk -v G=$gene '{split($3, arrayCHR, "*");if(arrayCHR[1]==G){print $0}}'\
| grep "NM:i:0" |awk '{if ($10 != "*"){print ">"$1"\n"$10}}' >>$interdir/$prefix$root"."$gene".fasta"

done

#Oct. 15, 2019
#20% reads map to A or B/C at the same time, should be remove by read ID
    #for class I genes:
    mkdir -p $interdir/temp
    for gene in A B C DRB1 DQB1 DPB1
    do
        #paired both, or only one
        cat $interdir/$prefix$root"."$gene".fasta" | grep ">" |grep -v ">HLA-" |sort | uniq >$interdir/temp/$gene".seqID"
    done
    #take unique ones
        cat $interdir/temp/*".seqID" | sort | uniq -u >$interdir/temp/abc.uniq
   
    for gene  in A B C DRB1 DQB1 DPB1
    do  
        cat $interdir/temp/$gene".seqID" $interdir/temp/abc.uniq | sort | uniq -d |sed "s/>//g" >$interdir/temp/$gene".id"
        seqtk subseq $interdir/$prefix$root"."$gene".fasta" $interdir/temp/$gene".id" > $interdir/temp/$prefix$root"."$gene".fasta"
        rm $interdir/$prefix$root"."$gene".fasta"
        mv  $interdir/temp/$prefix$root"."$gene".fasta" $interdir/
    done     
    rm -r $interdir/temp
}



get2dRef(){
    #for i in 07
    #echo "get two digits B fasta from HLA ref files."
    antigen=$1

    refdir="interRef/"$antigen"-fa"
    mkdir -p $refdir



    if [ $antigen == "A" ];then
        agList="01 02 03 11 23 24 25 26 29 30 31 32 33 34 36 43 66 68 69 74 80"     
    elif [ $antigen == "B" ];then
        agList="07 08 13 14 15 18 27 35 37 38 39 40 41 42 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 67 73 78 81 82 83"
    elif [ $antigen == "C" ];then
        agList="01 02 03 04 05 06 07 08 12 14 15 16 17 18"
    elif [ $antigen == "DRB1" ];then 
        agList="01 03 04 07 08 09 10 11 12 13 14 15 16"
    elif [ $antigen == "DQB1" ];then
        agList="02 03 04 05 06"
    elif [ $antigen == "DPB1" ];then
        agList="01 02 03 04 05 06 08 09 10 100 1000 1001 1002 1003 1004 1005 1006 1007 1008 1009 101 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 102 1020 1021 1022 1023 1024 1025 1026 1027 1028 1029 103 1030 1031 1032 1033 1034 1035 1036 104 105 106 107 108 109 11 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 13 130 131 132 133 134 135 136 137 138 139 14 140 141 142 143 144 145 146 147 148 149 15 150 151 152 153 154 155 156 157 158 159 16 160 161 162 163 164 165 166 167 168 169 17 170 171 172 173 174 175 176 177 178 179 18 180 181 182 183 184 185 186 187 188 189 19 190 191 192 193 194 195 196 197 198 199 20 200 201 202 203 204 205 206 207 208 209 21 210 211 212 213 214 215 216 217 218 219 22 220 221 222 223 224 225 226 227 228 229 23 230 231 232 233 234 235 236 237 238 239 24 240 241 242 243 244 245 246 247 248 249 25 250 251 252 253 254 255 256 257 258 259 26 260 261 262 263 264 265 266 267 268 269 27 270 271 272 273 274 275 276 277 278 279 28 280 281 282 283 284 285 286 287 288 289 29 290 291 292 293 294 295 296 297 298 299 30 300 301 302 303 304 305 306 307 308 309 31 310 311 312 313 314 315 316 317 318 319 32 320 321 322 323 324 325 326 327 328 329 33 330 331 332 333 334 335 336 337 338 339 34 340 341 342 343 344 345 346 347 348 349 35 350 351 352 353 354 355 356 357 358 359 36 360 361 362 363 364 365 366 367 368 369 37 370 371 372 373 374 375 376 377 378 379 38 380 381 382 383 384 385 386 387 388 389 39 390 391 392 393 394 395 396 397 398 399 40 400 401 402 403 404 405 406 407 408 409 41 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 44 440 441 442 443 444 445 446 447 448 449 45 450 451 452 453 454 455 456 457 458 459 46 460 461 462 463 464 465 466 467 468 469 47 470 471 472 473 474 475 476 477 478 479 48 480 481 482 483 484 485 486 487 488 489 49 490 491 492 493 494 495 496 497 498 499 50 500 501 502 503 504 505 506 507 508 509 51 510 511 512 513 514 515 516 517 518 519 52 520 521 522 523 524 525 526 527 528 529 53 530 531 532 533 534 535 536 537 538 539 54 540 541 542 543 544 545 546 547 548 549 55 550 551 552 553 554 555 556 557 558 559 56 560 561 562 563 564 565 566 567 568 569 57 570 571 572 573 574 575 576 577 578 579 58 580 581 582 583 584 585 586 587 588 589 59 590 591 592 593 594 595 596 597 598 599 60 600 601 602 603 604 605 606 607 608 609 61 610 611 612 613 614 615 616 617 618 619 62 620 621 622 623 624 625 626 627 628 629 63 630 631 632 633 634 635 636 637 638 639 64 640 641 642 643 644 645 646 647 648 649 65 650 651 652 653 654 655 656 657 658 659 66 660 661 662 663 664 665 666 667 668 669 67 670 671 672 673 674 675 676 677 678 679 68 680 681 682 683 684 685 686 687 688 689 69 690 691 692 693 694 695 696 697 698 699 70 700 701 702 703 704 705 706 707 708 709 71 710 711 712 713 714 715 716 717 718 719 72 720 721 722 723 724 725 726 727 728 729 73 730 731 732 733 734 735 736 737 738 739 74 740 741 742 743 744 745 746 747 748 749 75 750 751 752 753 754 755 756 757 758 759 76 760 761 762 763 764 765 766 767 768 769 77 770 771 772 773 774 775 776 777 778 779 78 780 781 782 783 784 785 786 787 788 789 79 790 791 792 794 795 796 797 798 799 80 800 801 802 803 804 805 806 807 808 809 81 810 811 812 813 814 815 816 817 818 819 82 820 821 822 823 824 825 826 827 828 829 83 830 831 832 833 834 835 836 837 838 839 84 840 841 842 843 844 845 846 847 848 849 85 850 851 852 853 854 855 856 857 858 859 86 860 861 862 863 864 865 866 867 868 869 87 870 871 872 873 874 875 876 877 878 879 88 880 881 882 883 884 885 886 887 888 889 89 890 891 892 893 894 895 896 897 898 899 90 900 901 902 903 904 905 906 907 908 909 91 910 911 912 913 914 915 916 917 918 919 92 920 921 922 923 924 925 926 927 928 929 93 930 931 932 933 934 935 936 937 938 939 94 940 941 942 943 944 945 946 947 948 949 95 950 951 952 953 954 955 956 957 958 959 96 960 961 962 963 964 965 966 967 968 969 97 970 971 972 973 974 975 976 977 978 979 98 980 981 982 983 984 985 986 987 988 989 99 990 991 992 993 994 995 996 997 998 999"

    fi
    
    echo "@INFO: extract two digit reference "$antigen" from total HLA ref."

    for i in $agList
    do
        python python/getFastaByID.py $fullHLAref".fasta" $antigen"*"$i >$refdir/$antigen$i".fasta"

    done
}


kmer(){

#cp binary into /user/local/bin/

id=$1
#optimalK=`expr $readLen - 2`
#K39
#optimalK=`expr $readLen - 12`

suffix=$2
#fastq.gz
#paired
#fasta
#fa

if [ $suffix == ".fastq.gz" ];then
	type=".fastq"
elif [ $suffix == ".fasta" ];then
	type=""
elif [ $suffix == ".fa" ];then
	type=""
else
	echo "input file type should be fastq.gz, fasta, fa!"
	exit 1
fi

dir=$id"_kmers"
mkdir -p $dir

#while [ $i -lt $readLen ]
#do
    #use 39mer
i=$optimalK
#echo $i
dsk -file $id$suffix -kmer-size $i -abundance-min $cutoff -out-dir $dir >/dev/null
mv $dir/$id$type".h5" $dir/$id".k"$i$type".h5"
dsk2ascii -file $dir/$id".k"$i$type".h5" -out $dir/$id".k"$i".txt" >/dev/null
rm  $dir/$id".k"$i$type".h5"

	#i=`expr $i + 2`
#done

}

generateKmer(){
    pre=$1
    
    #cp kmer.sh $interdir
    cd $interdir
    echo "@INFO: current directory is:"
    pwd
    echo $pre".fasta"
    kmer $pre ".fasta"
    #./kmer.sh $prefix ".fasta"
    #rm kmer.sh
    cd ../
    pre=""
   }

generateKmerReads(){
    thedir=$1
    cd $thedir
    echo "@INFO: current directory is:"
    pwd
    echo "@INFO: HLA ref fasta files are:"
    echo `ls *fasta`
    #cp kmer.sh $refdir
    for x in `ls *.fasta |cut -d "." -f1`
    do
        #echo $x
        #head $x".fasta"
        kmer $x ".fasta"
        #./kmer.sh $x ".fasta"
    done
    cd ../../

}

#####################################################
#for antigen in "A"
for antigen in "A" "B" "C" "DRB1" "DQB1" "DPB1"
do
    refdir="interRef/"$antigen"-fa"
    rm -r $refdir
    mkdir -p $refdir
    get2dRef $antigen
    
done

mkdir -p temp2
cat interRef/*-fa/*.fasta >temp2/hlaI.ars.fasta
#bwa index -a is -p hla_cDNA hla_cDNA.fasta
bwa index -a is -p temp2/hlaI.ars temp2/hlaI.ars.fasta
fq2SAM temp2/hlaI.ars $sampleID

#library="paired"
extractHLAreads $sampleID

assignReadByAg $sampleID

#############################################################
#for antigen in "A"
for antigen in "A" "B" "C" "DRB1" "DQB1" "DPB1"
do
    
    generateKmer $prefix$sampleID"."$antigen
    refdir="interRef/"$antigen"-fa"
    generateKmerReads $refdir

done


#########################################################

fname="hla."$sampleID

#threads for bowtie2
td=12

#refdirectory for ref, inter
#antigen=$2
#antigen="B"

i=9 #kmer min
cutoff=3 #kmer cutoff coverage
readLen=51
optimalK=39

pyDir="/home/tianr/dataset/2019.7.30-wholeblood-singleEND-RNA-seq-585G-117samples/test/python/"

#pyDir="./python/"


#zless /home/tianr/biodatabases/hla/hla_nuc.fasta.gz |tr " " "_" >./python/refData/hla_cDNA.fasta

#fullHLAref="/home/tianr/dataset/2019.7.30-wholeblood-singleEND-RNA-seq-585G-117samples/test/python/refData/hla_cDNA"
#fullHLAref="./python/refData/hla-cDNA"
#fullHLAref="/home/tianr/dataset/7.19autoimmune/hla_ref/hla-cDNA"

#fullHLAref="./python/refData/hla-class1-ARS"


computeCosine(){
	file1=$1
	file2=$2
	#make union k mers
    
    #in case file is empty
    #both not empty
    if [ -s $file1 ] && [ -s $file2 ];then
	    cat <(cut -d " " -f1 $file1) <(cut -d " " -f1 $file2) | sort | uniq >allKmers.txt
	    join -1 1 -2 1 -t " " -a 1 -e "0" -o 1.1,2.2 <(sort -k1 allKmers.txt) <(sort -k1 $file1) |cut -d " " -f2 >$file1".vct"
    	join -1 1 -2 1 -t " " -a 1 -e "0" -o 1.1,2.2 <(sort -k1 allKmers.txt) <(sort -k1 $file2) |cut -d " " -f2 >$file2".vct"
	    #echo $file1" "$file2
	    python $pyDir"calculateSimilarity.py" $file1".vct" $file2".vct"
	    rm allKmers.txt
    else
        echo "0"
    fi

	#rm $file1 $file2
	}	

typing(){
    antigen=$1
    prefix=$2
    output=$3

    if [ $antigen == "A" ];then
        agList="01 02 03 11 23 24 25 26 29 30 31 32 33 34 36 43 66 68 69 74 80"     
    elif [ $antigen == "B" ];then
        agList="07 08 13 14 15 18 27 35 37 38 39 40 41 42 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 67 73 78 81 82 83"
    elif [ $antigen == "C" ];then
        agList="01 02 03 04 05 06 07 08 12 14 15 16 17 18"
    elif [ $antigen == "DRB1" ];then 
        agList="01 03 04 07 08 09 10 11 12 13 14 15 16"
    elif [ $antigen == "DQB1" ];then
        agList="02 03 04 05 06"
    elif [ $antigen == "DPB1" ];then
        agList="01 02 03 04 05 06 08 09 10 100 1000 1001 1002 1003 1004 1005 1006 1007 1008 1009 101 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 102 1020 1021 1022 1023 1024 1025 1026 1027 1028 1029 103 1030 1031 1032 1033 1034 1035 1036 104 105 106 107 108 109 11 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 13 130 131 132 133 134 135 136 137 138 139 14 140 141 142 143 144 145 146 147 148 149 15 150 151 152 153 154 155 156 157 158 159 16 160 161 162 163 164 165 166 167 168 169 17 170 171 172 173 174 175 176 177 178 179 18 180 181 182 183 184 185 186 187 188 189 19 190 191 192 193 194 195 196 197 198 199 20 200 201 202 203 204 205 206 207 208 209 21 210 211 212 213 214 215 216 217 218 219 22 220 221 222 223 224 225 226 227 228 229 23 230 231 232 233 234 235 236 237 238 239 24 240 241 242 243 244 245 246 247 248 249 25 250 251 252 253 254 255 256 257 258 259 26 260 261 262 263 264 265 266 267 268 269 27 270 271 272 273 274 275 276 277 278 279 28 280 281 282 283 284 285 286 287 288 289 29 290 291 292 293 294 295 296 297 298 299 30 300 301 302 303 304 305 306 307 308 309 31 310 311 312 313 314 315 316 317 318 319 32 320 321 322 323 324 325 326 327 328 329 33 330 331 332 333 334 335 336 337 338 339 34 340 341 342 343 344 345 346 347 348 349 35 350 351 352 353 354 355 356 357 358 359 36 360 361 362 363 364 365 366 367 368 369 37 370 371 372 373 374 375 376 377 378 379 38 380 381 382 383 384 385 386 387 388 389 39 390 391 392 393 394 395 396 397 398 399 40 400 401 402 403 404 405 406 407 408 409 41 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 44 440 441 442 443 444 445 446 447 448 449 45 450 451 452 453 454 455 456 457 458 459 46 460 461 462 463 464 465 466 467 468 469 47 470 471 472 473 474 475 476 477 478 479 48 480 481 482 483 484 485 486 487 488 489 49 490 491 492 493 494 495 496 497 498 499 50 500 501 502 503 504 505 506 507 508 509 51 510 511 512 513 514 515 516 517 518 519 52 520 521 522 523 524 525 526 527 528 529 53 530 531 532 533 534 535 536 537 538 539 54 540 541 542 543 544 545 546 547 548 549 55 550 551 552 553 554 555 556 557 558 559 56 560 561 562 563 564 565 566 567 568 569 57 570 571 572 573 574 575 576 577 578 579 58 580 581 582 583 584 585 586 587 588 589 59 590 591 592 593 594 595 596 597 598 599 60 600 601 602 603 604 605 606 607 608 609 61 610 611 612 613 614 615 616 617 618 619 62 620 621 622 623 624 625 626 627 628 629 63 630 631 632 633 634 635 636 637 638 639 64 640 641 642 643 644 645 646 647 648 649 65 650 651 652 653 654 655 656 657 658 659 66 660 661 662 663 664 665 666 667 668 669 67 670 671 672 673 674 675 676 677 678 679 68 680 681 682 683 684 685 686 687 688 689 69 690 691 692 693 694 695 696 697 698 699 70 700 701 702 703 704 705 706 707 708 709 71 710 711 712 713 714 715 716 717 718 719 72 720 721 722 723 724 725 726 727 728 729 73 730 731 732 733 734 735 736 737 738 739 74 740 741 742 743 744 745 746 747 748 749 75 750 751 752 753 754 755 756 757 758 759 76 760 761 762 763 764 765 766 767 768 769 77 770 771 772 773 774 775 776 777 778 779 78 780 781 782 783 784 785 786 787 788 789 79 790 791 792 794 795 796 797 798 799 80 800 801 802 803 804 805 806 807 808 809 81 810 811 812 813 814 815 816 817 818 819 82 820 821 822 823 824 825 826 827 828 829 83 830 831 832 833 834 835 836 837 838 839 84 840 841 842 843 844 845 846 847 848 849 85 850 851 852 853 854 855 856 857 858 859 86 860 861 862 863 864 865 866 867 868 869 87 870 871 872 873 874 875 876 877 878 879 88 880 881 882 883 884 885 886 887 888 889 89 890 891 892 893 894 895 896 897 898 899 90 900 901 902 903 904 905 906 907 908 909 91 910 911 912 913 914 915 916 917 918 919 92 920 921 922 923 924 925 926 927 928 929 93 930 931 932 933 934 935 936 937 938 939 94 940 941 942 943 944 945 946 947 948 949 95 950 951 952 953 954 955 956 957 958 959 96 960 961 962 963 964 965 966 967 968 969 97 970 971 972 973 974 975 976 977 978 979 98 980 981 982 983 984 985 986 987 988 989 99 990 991 992 993 994 995 996 997 998 999"

    fi

    #for i in 08
    for i in $agList
    do
        #echo "kmer B"$i >
        [ -f $interdir/$antigen$i".tab" ] && rm $interdir/$antigen$i".tab"
        touch $interdir/$antigen$i".tab"
        #pwd
        #echo "B"$i" "`./cosine.sh interData/ $name".B" interRef/B-fa/ "B"$i` >>interData/"B"$i".tab"
        echo $antigen$i" "`computeCosine $interdir/$prefix"_kmers/"$prefix".k39.txt" $refdir/$antigen$i"_kmers/"$antigen$i".k39.txt"` >>$interdir/$antigen$i".tab"
    done


    geno1=`cat interData/$antigen*".tab" |sort -k2nr |head -n1 |cut -d " " -f1`
    cat $interdir/$antigen*".tab" |sort -k2nr >>$output
    echo "################################################################">>$output
    #rm interData/$antigen*".tab" 
    #echo "################"
    echo $geno1
    #echo "###############"
    }

targetedMapping(){
	#fetch fasta by seqtk

	#assignedHLA=mylist.txt	
	wdir=$1
    #wdir=interRef/B-fa/
    geno1=$2
	library=$3
    name=$4
	#single, or paired

	#seqtk subseq $slicedFA $assignedHLA | sed "s/@/*/g" >temp/$name"_assignedHLA.fa"

	#via bowtie2
	bowtie2-build $wdir$geno1".fasta" $wdir$geno1

	#mapping with bowtie2
	#7 min
	if [ $library == "single" ];then
		echo $library
		bowtie2 --all --threads $td -x $wdir$geno1 -U $name".fastq.gz" -S $name".sam"
	elif [ $library == "paired" ];then
		echo $library
		bowtie2 --all --threads $td -x $wdir$geno1 -1 $name"_1.fastq.gz"  -2 $name"_2.fastq.gz" -S $name".sam"
    elif [ $library == "fasta" ];then
        #use fasta as input
        bowtie2 --all --threads $td -x $wdir$geno1 -f  $interdir/$name"."$antigen".fasta" -S $name".sam"
        #unmapped
        samtools view -f4 $name".sam" |cut -f10 >>$interdir/$geno1".rm.fasta"
        rm $name".sam"

	else
		echo "@info: targetted mapping, needs to state library type, single or paired end!"
		exit 4
	fi
		
	#samtools view -bS $name".sam" >$name".BAM"
	#rm $name".sam"
}




###################################################################################################################################


outdir=$fname"_results"
mkdir -p $outdir

#interdir="interData"
#mkdir -p $interdir

################################################################################################################################

#for antigen in A 
for antigen in A B C DRB1 DPB1 DQB1
do

    refdir="interRef/"$antigen"-fa"
    mkdir -p $refdir
   
    output=$fname"."$antigen".tsv"
    [ -f $output ] && rm $output
    touch $output

    echo "@INFO: start first allele typing."
    geno1=`typing $antigen $fname"."$antigen $output`

    echo $geno1

    echo ">"$geno1" filtered out" >$interdir/$geno1".rm.fasta"
    targetedMapping $refdir"/" $geno1 "fasta" $fname
    

    ##############
    generateKmer $geno1".rm"

    second=`typing $antigen $geno1".rm" $output`
    echo "#HLA typing is :" >>$output
    if [ $geno1 != $second ]; then
        echo $geno1" "$second |sed "s/$antigen/$antigen*/g" >>$output
    elif [ $geno1 == $second ]; then
        second=`head -n2 $output| tail -n1 |cut -d " " -f1`
        echo $geno1" "$second |sed "s/$antigen/$antigen*/g" >>$output
    else
        echo "something wrong!"
    fi
    mv $output $outdir
    geno1=""
    second=""

done


