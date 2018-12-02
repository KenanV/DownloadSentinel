#!/bin/bash

#Choose orbit type: "FULL_ORBIT", "NRT", or "ALL"
orbit_type="ALL"

# Declaration of each name of sites
name="fyn"
#Declaration of positions as provided to dhus
declare -a orbits=("8"    "14"  "22"  "29"  "36"  "43"  "51"  "57"  "65"  "71"  "79"  "86"  "93" "100" "107" "114" "122" "128" "136" "143" "150" "157" "165" "171" "179" "186" "193" "200" "207" "214" "222" "228" "236" "243" "250" "257" "264" "265" "271" "279" "285" "293" "300" "307" "314" "322" "328" "336" "342" "350"  "357" "364" "371" "379" "385")
declare -a offset=("000"  "-1" "000"  "-1"   "0"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1"   "0"  "-1" "000"  "-1" "000"  "-1" "000" "000"  "-1" "000"  "-1" "000" "-1"  "000"  "-1" "000"  "-1" "000"  "-1" "000"  "-1"  "000"  "-1" "000" "-1")
#root path where quicklooks are to be stored
root_path="/data/sentinel3/quicklooks/"

#Loop through all orbits and create folders and download the product descriptions
for i in  {1..56}
do


	orbitNo=$((${orbits[i]} + ${offset[i]}))

	cd /home/kev/download/dhus

	echo "Creating folders"
	mkdir -p $root_path${name}
	mkdir -p $root_path${name}/csv

	#index
	for j in {1..2}
	do
	   /bin/bash dhusget.sh -d https://scihub.copernicus.eu/s3 -u s3guest -p s3guest -P$j -l 100  -F "platformname:Sentinel-3 AND producttype:SL_2_LST___ AND relativeorbitnumber:${orbitNo}" -C $root_path${name}/csv/orbit_${orbitNo}"_"$j.csv   
	echo "Done downloading ($j)"
	done
	cat $root_path${name}/csv/*.csv > $root_path${name}/all.csv
done

#Loop through all locations and concatenate all pages to one file and convert the content to something that can be downloaded

echo "delete existing file"
rm $root_path${name}/all_download.csv
echo "reformat csv files for downloading"
while IFS=, read -r col1 col2
do
	if [[ $orbit_type = "FULL_ORBIT" ]]; then
		if [[ $col1 = *"LN2_O_NT_"* ]]; then
			echo "$col2/\$value  $col1.zip" >> $root_path${name}/all_download.csv
		fi
	fi

	if [[ $orbit_type = "NRT" ]]; then
		if ! [[ $col1 = *"LN2_O_NT_"* ]]; then
			echo "$col2/\$value  $col1.zip" >> $root_path${name}/all_download.csv
		fi
	fi

	if [[ $orbit_type = "ALL" ]]; then
		echo "$col2/\$value  $col1.zip" >> $root_path${name}/all_download.csv
	fi

done < $root_path${name}/all.csv
