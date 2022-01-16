#!/bin/bash
# Program Name: format_sql.bash
# Description: wraps SQL statements on one line so that they can be run in the Impala shell
# Usage: bash format_sql.bash path inputfile.sql outputfile.sql
path=$1
inFile=$2
outFile=$3
# remove the blank lines
sed -r '/^\s*$/d' $path/$inFile > $path/temp_file.sql
# delete lines with comments 
sed -i '/--/d' $path/temp_file.sql
# add a space to the end of each line
sed -i 's/$/ /' $path/temp_file.sql
# put everything on one line
cat $path/temp_file.sql | tr -d '\n' > $path/temp_file2.sql
# insert a new line at every semicolon
sed -i "s/;/;\n/g" $path/temp_file2.sql
# remove the leading space from each line
cut -c 2- < $path/temp_file2.sql > $path/$outFile
rm $path/temp_file.sql
rm $path/temp_file2.sql