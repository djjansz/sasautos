#!/bin/bash
# Program Name: cutnum.bash
# Description: Search cut the numbers off the right of text files from the mainframe
# Usage: bash cutnum.bash /searchPath "cutpoint" 
dir=$1
cutpt=$2
cnt=0
getlist()
{
	IFS=$'\n'
	for file in $(find $dir -name "*.txt"); do
		if [ -f "$file" ]
		then
			echo "$file  IS A FILE"
			if [ -r "$file" ]
			then 
				cut -c1-$cutpt $file >> $file
				if [ $? -eq 0 ]
				then
					let cnt++
					echo 
					echo "$cnt: $file was cut" >> $outFile
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
echo "Done cutting up the files in $dir"
