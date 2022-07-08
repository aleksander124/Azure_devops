#!/bin/bash

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]
then
	echo -e "All parameters must be provided\n"
	echo -e "Usage: sendEmail.sh {mailFrom} {mailTo} {mailSubject} {inputFile}\n"
	exit 1
fi

if [[ ! -s "$4" ]]
then
    echo "No images found in "$4" or file doesn't exists."
    exit 0;
fi

mail -v -r "$1" -s "$3" "$2" < "$4"
