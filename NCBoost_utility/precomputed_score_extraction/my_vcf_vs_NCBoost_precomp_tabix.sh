#!/bin/bash
# Fabio Zanarello, Sanger Institute, 2019

#bash script that takes a vcf file (arg 1), extracts coordinates (saving in a file),
#read the file and ask to tabix if the coordinate are present in (arg 2) the precomputed
#NCBoost scores (https://storage.googleapis.com/ncboost/ncboost_score_hg19_v20190108.tsv.gz)
#and if present save the results in a file (arg 3), then the latter is used to
#create a new vcf strating from the initial vcf with new columns regarding
#the NCBoost score (NAs if not present) (arg 4)

#NOTE: the index file have to be present in the same folder
#(https://storage.googleapis.com/ncboost/ncboost_score_hg19_v20190108.tsv.gz.tbi)

# command example: sh my_vcf_vs_NCBoost_precomp_tabix.sh dataset/Initial_table_of_variants.txt dataset/ncboost_score_hg19_v20190108.tsv.gz inter_result.txt updated_vcf.txt


my_vcf=$1
NCBoost_precomp=$2
#/lustre/scratch115/teams/soranzo/projects/NCBoost/ncboost_score_hg19_v20190108.tsv.gz
output1=$3
output2=$4

# python script to extract coordinates from variants table
python get_only_cordinate.py --input $my_vcf --output coordinates_to_test.txt

# variables for progression counting
num_of_lines=$(< "coordinates_to_test.txt" wc -l)
counter=0

while read line ; do

    #coordinateto be extracted to be used in grep
    my_coord=${line#*:}
    my_coord=${my_coord%-*}

    # since the results is not only the desired coordinate
    # grep the desied one
    res_line=$(tabix $NCBoost_precomp $line | grep $my_coord)

    # verify if the result is positive or not, print on screen the proceeding
    # and if positive append a nuew line to the result folder
    if [ -z "$res_line" ]
    then
      echo "$line NOT is present in NCBoost score, $counter/$num_of_lines"
    else
      echo "$line is present in NCBoost score, $counter/$num_of_lines"
      echo $res_line>>$output1
    fi

    counter=$((counter+1))

done < coordinates_to_test.txt

rm coordinates_to_test.txt

python3 update_variants_table.py --vcf $my_vcf --inter_res $output1 --output $output2
