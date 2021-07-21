#!/bin/bash


while read person sub_id
do 

mkdir $person
cd $person
scp /scratch/r.burtonpatel/dti_demos/README.md . 
printf "Hello, ${person}!\n" | cat - README.md > temp && mv temp ${person}_README.md
rm README.md
cd ..
done </work/mindlab/Projects/mci/mci_dti/dti_demo_7-21/attendance_list

while read sub_id
do
printf -v padded3 "%03d" $sub_id
printf -v padded2 "%02d" $sub_id



scp /work/mindlab/Projects/mci/mci_dti/sub-$padded3/dwi/sub-${padded2}_dwi.nii.gz . ||
scp /work/mindlab/Projects/mci/mci_dti/sub-$padded3/dwi/sub-${padded3}_dwi.nii.gz . 

done </work/mindlab/Projects/mci/mci_dti/dti_demo_7-21/sub_numbers
