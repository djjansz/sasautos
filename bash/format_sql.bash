#!/bin/bash
# Program Name: format_sql.bash
# Description: wraps SQL statements on one line so that they can be run in the Impala shell
# Usage: bash format_sql.bash inputfile outputfile
inFile=$1
outFile=$2
# remove the blank lines
sed -r '/^\s*$/d' $inFile > $outFile
# delete lines with comments 
sed -i '/--/d' $outFile
# add a space to the end of each line
sed -i 's/$/ /' $outFile
# put everything on one line
cat $outFile | tr -d '\n' > $outFile
# insert a new line at every semicolon
sed -i "s/;/;\n/g" $outFile 
