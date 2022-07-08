#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]
then
	echo -e "All parameters must be provided\n"
	echo -e "Usage: searchNotUsed.sh {azureImageList} {k8sImageList} {outputNotusedFile} {outputUsedFile}\n"
	exit 1
fi

if [[ ! -s "$1" ]]
then
	echo "No images found in "$1", or file doesn't exist."
	exit 0
fi

if [[ ! -s "$2" ]]
then
	echo "No images found in "$2", or file doesn't exist."
	exit 0
fi

# Search is done this way to avoid duplicates in used list

for image in $(cat "$1" | awk '{print $1}')
do
	searchResult=`grep "$2" -e "$image"`

	if [ -z "$searchResult" ]
	then
		echo "$image" \
		>> "$3"
	else
		echo "$image" \
		>> "$4"
	fi
done
