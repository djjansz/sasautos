#!/bin/bash
# Program Name: grep4.bash
# Description: Search for a phrase in a directory and it's subdirectories
# Usage: bash grep4.bash /searchPath "pattern" /outputFile
dir=$1
pat=$2
outFile=$3
cnt=0
getlist()
{
	IFS=$'\n'
	for file in $(find $dir -name "*.sas"); do
		if [ -f "$file" ]
		then
			echo "$file  IS A FILE"
			if [ -r "$file" ]
			then 
				grep -in $pat "$file"
				if [ $? -eq 0 ]
				then
					let cnt++
					echo 
					echo "$cnt: $file CONTAINS THE PATTERN $pat" >> $outFile
				fi
			fi
		elif [ -d "$file" ]
		then
			echo "$file IS A DIRECTORY"
		elif [ -e "$file" ] 
		then
			echo "$file EXISTS"
		else
			echo "$file HAS UNKNOWN TYPE"
		fi
	done
}
getlist
echo
echo "Done sending the file type to stdout and creating the output file $outFile that contains the list of files with the pattern $pat"
