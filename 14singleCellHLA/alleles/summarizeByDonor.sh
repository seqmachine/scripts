#Marh 26, 2019

cat *tsv.tab | cut -d "@" -f2 |awk '{for(i=1; i<=NF; i++){if(substr($i, 1,1)=="A"){a[i]=$i} }; gene="";for (k in a) { gene=gene" "a[k];a[k]=""};print gene}' | grep A |sed  's/^ *//' | awk '{if($1 < $2) {print $1"/"$2} else {print $2"/"$1}}' | sort | uniq -c | sort -k1nr |awk '{print $2, $1}'| head -n3
echo "##################"
cat *tsv.tab |awk '{for(i=1; i<=NF; i++){if(substr($i, 1,1)=="B"){a[i]=$i} }; gene="";for (k in a) { gene=gene" "a[k];a[k]=""};print gene}' | grep B |sed  's/^ *//' | awk '{if($1 < $2) {print $1"/"$2} else {print $2"/"$1}}' | sort | uniq -c | sort -k1nr |awk '{print $2, $1}'| head -n3
echo "##################"
cat *tsv.tab |awk '{for(i=1; i<=NF; i++){if(substr($i, 1,1)=="C"){a[i]=$i} }; gene="";for (k in a) { gene=gene" "a[k];a[k]=""};print gene}' | grep C |sed  's/^ *//' | awk '{if($1 < $2) {print $1"/"$2} else {print $2"/"$1}}' | sort | uniq -c | sort -k1nr |awk '{print $2, $1}'|head -n3
