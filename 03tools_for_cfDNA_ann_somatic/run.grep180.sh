cat 180.list | awk -v INP=$1 '{print "grep -w "$1" "INP">> "INP".180"}' 

