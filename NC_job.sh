#!/bin/bash

# bash script to execute a run of NCBoost
# run it from the NCBoost root forlder
# to have a normal run (avoid the farm job)
# thype fast as 4th parameter

job_name=$1
input=$2
output=$3
speed=$4

res_folder=${job_name}_res

mkdir -p ${res_folder}


if [ "$speed" == "fast" ];then
	./NCBoost_scripts/ncboost_annotate.sh \
	${input} \
	${res_folder}/${output}
else
	bsub -G team151 \
	-o /$res_folder/${job_name}.out \
	-M 4000 \
	-J $job_name \
	-R"select[mem>=4000] rusage[mem=4000] span[hosts=1]" \
	-n1 \
	-q normal \
	-- "./NCBoost_scripts/ncboost_annotate.sh $input $res_folder/$output "
fi


#./NCBoost_scripts/ncboost_annotate.sh \
#${input} \
#${res_folder}/${output}
