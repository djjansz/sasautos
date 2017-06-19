#Desc: Find the largest files
#Usage: bash largest.sh /searchPath /outputFile
dir=$1
outFile=$2
cnt=0
getlist()
{
  find $dir -name '*.sas7bdat' -ls | sort -rnk 2 > $outFile
}
getlist
echo
echo "Done sending the list of files."