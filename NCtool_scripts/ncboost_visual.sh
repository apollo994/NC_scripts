#!/usr/bin/env bash
#Fabio Zanarello, Sanger Institute, 2019


region=$1
reference=$2
name=$3

if [ -z $name ];then
  name="my_region"
fi

mkdir -p $name'_results'

echo $'\nRegion '$region' queried'
echo $'\nGenerating the input for NCBoost...\n'

python3.6.1 NCBoost_scripts/get_fake_SNVs.py --input $region --ref $reference --out $name'.NCinput'

echo $'\nRunning NCBoost, it could take a while...\n'

./NCBoost_scripts/ncboost_annotate.sh $name'.NCinput' $name'_ann.txt'


echo $'\nConverting result in wig format...\n'

python3.6.1 NCBoost_scripts/convert_NC_to_wig.py --input $name'_ann.txt' --out $name'_visual.wig' --reg $region --sam $name

mv $name'.NCinput' $name'_results'
mv $name'_ann.txt' $name'_results'
mv $name'_visual.wig' $name'_results'

echo $'\nDone! Your result and intermediate file are in '$name'_results folder'
echo $'You can visualise it in the genome browser!\n'
echo $'Ensembl'
echo $'https://www.ensembl.org/info/website/upload/index.html\n'
echo $'UCSC:'
echo $'https://genome.ucsc.edu/goldenPath/help/customTrack.html\n\n'
