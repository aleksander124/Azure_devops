#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 || -z $4 || -z $5 ]]
then
	echo -e "All parameters must be provided\n"
	echo -e "Usage: deleteImages.sh {registryNAME} {azureImagesList} {notUsedImageList} {imageDaysOld} {test/realRun}\n"
	exit 1
fi

if [[ ! -s "$2" ]]
then
	echo "No images found in "$3" for processing, or file doesn't exist."
	exit 0
fi

currentDateEpoch=`date +%s`

if [[ "$5" != "realRun" ]]

then

	echo "##[warning] Test run mode"

	for image in $(cat "$3")
	do
		imageDate=`grep "$2" -e "$image\ " | awk '{print $2}'`
		imageDateEpoch=`date -d "$imageDate" +%s`

		if [[ $(($currentDateEpoch-$imageDateEpoch))/86400 -gt "$4" ]]

			then
				echo "##[debug] "$image": Will be deleted"
			else
				echo "##[debug] "$image": Will not be deleted: image age threshold not exceeded"
		fi
	done
else

	echo "##[warning] Real run mode"

	for image in $(cat "$3")
	do
		imageDate=`grep "$2" -e "$image\ " | awk '{print $2}'`
		imageDateEpoch=`date -d "$imageDate" +%s`

		if [[ $(($currentDateEpoch-$imageDateEpoch))/86400 -gt "$4" ]]

			then
				az acr repository delete --name "$1" --image "$image" -y
		fi
	done
fi
