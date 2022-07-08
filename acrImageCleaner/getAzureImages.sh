#!/bin/bash

if [[ -z $1 || -z $2 ]]
then
	echo -e "All parameters must be provided\n"
	echo -e "Usage: getAzureImages.sh {registryNAME} {outputFile}\n"
	exit 1
fi

for repoName in $(az acr repository list --name "$1" --output tsv); do
az acr repository show-tags --name "$1" --repository "$repoName" --output tsv --detail | \
awk '{print $4,$3}' | \
sed -r 's/(.*[0-9]{4}-[0-9]{2}-[0-9]{2})(.*)/\1/' | \
sed "s:^:$repoName\::" \
>> "$2"
done

if [[ ! -s "$2" ]]
then
	echo "No images found, or file doesn't exist. Quitting.."
	exit 1;
fi
