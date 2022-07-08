#!/bin/bash

port="6443"
jpath="/api/v1/pods"


if [[ -z $1 || -z $2 || -z $3 ]]
then
	echo -e "All parameters must be provided\n"
	echo -e "Usage: getK8sImages.sh {registryNAME} {clusterIP} {outputFile}\n"
	exit 1
fi

curl -s -X GET https://"$2":"$port""$jpath" --header "Authorization: Bearer "$accessToken"" --insecure | \
jq '.items[].spec.containers[].image' | \
grep "^\"$1" | \
tr -d '"' | \
sed -r 's:([a-z]+\.)+[a-z]+\/::' | \
sort -u >> "$3"
