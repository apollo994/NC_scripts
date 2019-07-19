#!/bin/bash
#Fabio Zanarello, Sanger Institute, 2019

# bash script to execute a command as farm job
# run it from the NCBoost root forlder


job_name=$1
speed=$2
comand=$3

if [ -z $speed ];then
  speed=normal
fi

bsub -G team151 \
-o ${job_name}.out \
-e ${job_name}.err \
-M 4000 \
-J $job_name \
-R "select[mem>=4000] rusage[mem=4000] span[hosts=1]" \
-n1 \
-q $speed \
-- "$comand"
