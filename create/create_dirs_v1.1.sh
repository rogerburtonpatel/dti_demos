#!/bin/bash

cd /work/mindlab/Projects/mci/mci_dti/dti_demo_7-21 
#paste -d"\n" attendance_list sub_numbers > people_and_nums

echo "Creating directories and importing subject files..." 

while read i 
do

# Make folder for each attendee of demo with custom README.md
mkdir $i
chmod 777 -R $i
cd $i
scp /scratch/r.burtonpatel/dti_demos/README.md . 
printf "Hello, ${i}!\n" | cat - README.md > temp && mv temp ${i}_README.md
rm README.md
# chmod 755 ${i}_README.md

# ... and read the line below, their chosen number, as a subject number to import 
# their desired subject to their directory. E.g. if file reads 
# Psyche 
# 7 
# the program will import subject number 7 to Psyche's folder. 
read i

# 0-pads subject names 
printf -v padded3 "%03d" $i
printf -v padded2 "%02d" $i

# Copies over subject file, accounting for varying zero-padding. Silences errors. 

cp ../../sub-$padded3/dwi/sub-${padded3}_dwi.nii.gz . 2> /dev/null || cp ../../sub-$padded3/dwi/sub-${padded2}_dwi.nii.gz . 2> /dev/null


cd ..


done </work/mindlab/Projects/mci/mci_dti/dti_demo_7-21/people_and_nums

echo "Complete!" 
#rm /work/mindlab/Projects/mci/mci_dti/dti_demo_7-21/people_and_nums
