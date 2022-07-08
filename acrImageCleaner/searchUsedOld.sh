#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 ]]
then
	echo -e "All parameters must be provided\n"
	echo -e "Usage: searchUsedOld.sh {azureImageList} {usedImageList} {outputFile} {imageDaysOld}\n"
	exit 1
fi

if [[ ! -s "$1" ]]
then
	echo "No images found in "$2" for processing, or file doesn't exist."
	exit 0
fi

currentDateEpoch=`date +%s`

for image in $(cat "$2")
do
	imageDate=`grep "$1" -e "$image\ " | awk '{print $2}'`
	imageDateEpoch=`date -d "$imageDate" +%s`

	if [[ $(($currentDateEpoch-$imageDateEpoch))/86400 -gt "$4" ]]

	then
		echo "$image" >> "$3"
	fi
done
