#!/bin/bash

# Declaration of each folder where data can be stored
declare -a file_directories=("/mnt/Sentinel3/LST/Denmark/NR" "/mnt/Sentinel3/LST/Denmark/NT" )

#root path where quicklooks are to be stored
output_root_path="/mnt/Sentinel3/LST/Denmark/NR"

csv_file_name="/data/sentinel3/quicklooks/fyn/all_download.csv"


#loop through file and download the quicklooks
echo "Reading download file:$root_path${names[$i]}/all_download.csv"
while IFS=' ' read -r url fileName
do
	echo "******************************************************************************************************************"
	echo "URL:  $url"
	echo "File: $fileName"

	if ![[ $fileName = *"LN2_O_NT_"* ]]; then
		echo "It's huge download since it is a full orbit!"
	fi

	output_full_path=$output_root_path/$fileName
	doesExist=false
	echo "Does file: $fileName exists?";
	for j in ${!file_directories[@]}
	do
		possible_file_name=${file_directories[$j]}/$fileName;

		echo "   Checking $possible_file_name";
		if [ -f $possible_file_name ] ; then
			doesExist=true
			echo "   File existed";
		fi
	done
	echo " File existed: $doesExist";
	if [ "$doesExist" = false ] ; then
		echo "   No. File $fullpath3 does not exists";
		echo "   Downloading ...";
		wget --no-check-certificate --user=s3guest --password=s3guest -O "$output_full_path" "$url"
	fi
	echo "******************************************************************************************************************"

done <"$csv_file_name"
